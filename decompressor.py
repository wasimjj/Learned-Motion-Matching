import sys
sys.path.append('./misc')

from torch.utils.tensorboard import SummaryWriter
import time
import torch
import NNModels
import CustomFunctions
import numpy as np

# runtime start
start_time = time.time()

# checking if GPU is available
print(torch.cuda.get_device_name(0)) 
device = torch.device("cuda")

# load data
xData = CustomFunctions.LoadData("XData", True)
yData = CustomFunctions.LoadData("YData", True)

hierarchy = CustomFunctions.LoadData("HierarchyData")
hierarchy = [int(hierarchy[i][0]) for i in range(len(hierarchy))]

# list of tensors
xTensor = []
yTensor = []
qTensor = []
pTensor = []
yFinal = []
qFinal = []
pNorm  = []

for i in range(len(xData)):
    xTensor.append(torch.tensor(xData[i], dtype=torch.float).to(device))
    yTensor.append(torch.tensor(yData[i], dtype=torch.float).to(device))

# compute forward kinematics
qTensor = CustomFunctions.ForwardKinematics(yTensor, hierarchy)

# calculate the rotation matrix
for i in range(len(yTensor)):
    yInfo = torch.empty(yTensor[i].size(0), 0).to(device)
    qInfo = torch.empty(qTensor[i].size(0), 0).to(device)

    for j in range(0, yTensor[i].size(1), 13):
        yInfo = torch.cat((yInfo, yTensor[i][:,j:j+3], CustomFunctions.quaternion_rotation_matrix(yTensor[i][:,j+3:j+7]), yTensor[i][:,j+7:j+13]), dim=1)
        qInfo = torch.cat((qInfo, qTensor[i][:,j:j+3], CustomFunctions.quaternion_rotation_matrix(qTensor[i][:,j+3:j+7]), qTensor[i][:,j+7:j+13]), dim=1)

    yFinal.append(yInfo)
    qFinal.append(qInfo)

for i in range(len(yData)):
    pTensor.append(torch.cat((yFinal[i], qFinal[i]), dim=1))

xTensor = CustomFunctions.StandardizeData(xTensor, dim=0)
pNorm   = CustomFunctions.StandardizeData(pTensor, dim=0)

# relevant dataset indexes
lTransforms = []
lVelocities = []
sTransforms = []
sVelocities = []

[lTransforms.extend(list(range(i + 0, i + 7)))  for i in range(0, yTensor[0].size(1), 13)]
[lVelocities.extend(list(range(i + 7, i + 13))) for i in range(0, yTensor[0].size(1), 13)]
[sTransforms.extend(list(range(i + 0, i + 7)))  for i in range(yTensor[0].size(1), pTensor[0].size(1), 13)]
[sVelocities.extend(list(range(i + 7, i + 13))) for i in range(yTensor[0].size(1), pTensor[0].size(1), 13)]

# define nn params
compressor   = NNModels.Compressor(n_feature=yTensor[0].size(1) * 2, n_hidden=512, n_hidden2=512, n_hidden3=512, n_output=32).to(device)
decompressor = NNModels.Decompressor(n_feature=24+32, n_hidden=512, n_output=yTensor[0].size(1)).to(device)

# dataloader settings
train = NNModels.CustomDataset((xTensor, yFinal, qFinal, pNorm), window=2)
train_loader = NNModels.Data.DataLoader(train, shuffle=True, batch_size=32)
c_optimizer, c_scheduler = NNModels.TrainSettings(compressor)
d_optimizer, d_scheduler = NNModels.TrainSettings(decompressor)

# training settings
epochs = 200
logFreq = 10

# init tensorboard
writer = SummaryWriter()

# train the network. range = epochs
for t in range(epochs + 1):
    epochLoss = 0.0
    lreg = 0.0
    sreg = 0.0
    vreg = 0.0
    lloc = 0.0
    lvel = 0.0
    lchr = 0.0
    cvel = 0.0

    epoch_time = time.time()

    # batch
    for batch_idx, (x, y, q, p) in enumerate(train_loader):

        x.to(device), y.to(device), q.to(device), p.to(device)

        # (seq. length, batch size, features) <- (batch size, seq. length, features)
        x = torch.transpose(x, 0, 1)
        y = torch.transpose(y, 0, 1)
        q = torch.transpose(q, 0, 1)
        p = torch.transpose(p, 0, 1)

        # generate latent variables Z
        zPred = compressor(p)

        # reconstruct pose Y
        f = torch.cat((x, zPred), dim=2)
        yPred = decompressor(f)

        # recompute forward kinematics
        qPred = torch.stack(CustomFunctions.ForwardKinematics(yPred, hierarchy), dim=0)
        
        # compute latent regularization losses
        loss_lreg = 0.10000 * torch.nn.MSELoss()(zPred[:,:,0:10], torch.zeros_like(zPred[:,:,0:10]))
        loss_sreg = 0.00000 * torch.nn.L1Loss() (zPred[:,:,10:20], torch.zeros_like(zPred[:,:,10:20]))
        loss_vreg = 0.00000 * torch.nn.L1Loss() ((zPred[1,:,20:32] - zPred[0,:,20:32]) / 0.017, torch.zeros_like(zPred[0,:,20:32]))

        # local & character space losses
        loss_loc  = 6.00000 * torch.nn.L1Loss()(yPred[:,:,lTransforms], y[:,:,lTransforms])
        loss_chr  = 1.00000 * torch.nn.L1Loss()(qPred[:,:,lTransforms], q[:,:,lTransforms])

        # local & character space velocity losses
        loss_lvel = 0.1 * torch.nn.L1Loss()(yPred[1,:,7:13] - yPred[0,:,7:13] / 0.017, y[1,:,7:13] - y[0,:,7:13] / 0.017)
        loss_cvel = 0.1 * torch.nn.L1Loss()(qPred[1,:,7:13] - qPred[0,:,7:13] / 0.017, q[1,:,7:13] - q[0,:,7:13] / 0.017)

        loss = loss_lreg + loss_sreg + loss_vreg + loss_loc + loss_chr + loss_lvel + loss_cvel

        # clear gradients for next train
        c_optimizer.zero_grad()
        d_optimizer.zero_grad()

        # backpropagation, compute gradients
        loss.backward()

        # apply gradients
        c_optimizer.step()
        d_optimizer.step()

        # step learning rate schedule
        c_scheduler.step()
        d_scheduler.step()

        # log loss value
        epochLoss += loss.item()
        lreg += loss_lreg.item()
        sreg += loss_sreg.item()
        vreg += loss_vreg.item()
        lloc += loss_loc.item()
        lchr += loss_chr.item()
        lvel += loss_lvel.item()
        cvel += loss_cvel.item()

    # just printing where training is
    if t % logFreq == 0:
        print("Epoch:", t, "\tLoss:", epochLoss, "\tRuntime:", (time.time() - epoch_time) * logFreq / 60, "minutes")
        print(lreg, sreg, vreg, lloc, lchr, lvel, cvel)
    # log loss in tensorboard
    writer.add_scalar('Decompressor Loss', epochLoss, t)

# save character space transforms (Q)
with open('database/QData.txt', "w+") as f:
    for i in range(len(pTensor)):
        for j in range(pTensor[i].size(0)):
            np.savetxt(f, pTensor[i][j].cpu().detach().numpy()[None], delimiter=" ")

        np.savetxt(f, [''], fmt='%s')

# save latent variables (Z)
with open('database/ZData.txt', "w+") as f:
    for i in range(len(yTensor)):
        # p = CustomFunctions.NormalizeData(torch.cat((yTensor[i], qTensor[i]), dim=1), dim=1)
        
        for j in range(pNorm[i].size(0)):
            zPred = compressor(pNorm[i][j])
            np.savetxt(f, zPred.cpu().detach().numpy()[None], delimiter=" ")

        np.savetxt(f, [''], fmt='%s')

# export compressor model
torch.onnx.export(
    compressor, torch.rand(1, 1, yTensor[0].size(1) * 2, device=device), 
    "onnx/compressor.onnx", export_params=True,
    opset_version=9, do_constant_folding=True,
    input_names = ['x'], output_names = ['z']
)

# export decompressor model
torch.onnx.export(
    decompressor, torch.rand(1, 1, 56, device=device), 
    "onnx/decompressor.onnx", export_params=True,
    opset_version=9, do_constant_folding=True,
    input_names = ['x'], output_names = ['y']
)

# runtime end
print("Decompressor runtime: %s minutes" % ((time.time() - start_time) / 60))