# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.16

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = "/home/pau1o-hs/Documents/Learned Motion Matching"

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = "/home/pau1o-hs/Documents/Learned Motion Matching/build"

# Include any dependencies generated for this target.
include CMakeFiles/Stepper.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/Stepper.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/Stepper.dir/flags.make

CMakeFiles/Stepper.dir/Stepper.cpp.o: CMakeFiles/Stepper.dir/flags.make
CMakeFiles/Stepper.dir/Stepper.cpp.o: ../Stepper.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir="/home/pau1o-hs/Documents/Learned Motion Matching/build/CMakeFiles" --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object CMakeFiles/Stepper.dir/Stepper.cpp.o"
	/bin/x86_64-linux-gnu-g++-9  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/Stepper.dir/Stepper.cpp.o -c "/home/pau1o-hs/Documents/Learned Motion Matching/Stepper.cpp"

CMakeFiles/Stepper.dir/Stepper.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/Stepper.dir/Stepper.cpp.i"
	/bin/x86_64-linux-gnu-g++-9 $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E "/home/pau1o-hs/Documents/Learned Motion Matching/Stepper.cpp" > CMakeFiles/Stepper.dir/Stepper.cpp.i

CMakeFiles/Stepper.dir/Stepper.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/Stepper.dir/Stepper.cpp.s"
	/bin/x86_64-linux-gnu-g++-9 $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S "/home/pau1o-hs/Documents/Learned Motion Matching/Stepper.cpp" -o CMakeFiles/Stepper.dir/Stepper.cpp.s

CMakeFiles/Stepper.dir/CustomLib.cpp.o: CMakeFiles/Stepper.dir/flags.make
CMakeFiles/Stepper.dir/CustomLib.cpp.o: ../CustomLib.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir="/home/pau1o-hs/Documents/Learned Motion Matching/build/CMakeFiles" --progress-num=$(CMAKE_PROGRESS_2) "Building CXX object CMakeFiles/Stepper.dir/CustomLib.cpp.o"
	/bin/x86_64-linux-gnu-g++-9  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/Stepper.dir/CustomLib.cpp.o -c "/home/pau1o-hs/Documents/Learned Motion Matching/CustomLib.cpp"

CMakeFiles/Stepper.dir/CustomLib.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/Stepper.dir/CustomLib.cpp.i"
	/bin/x86_64-linux-gnu-g++-9 $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E "/home/pau1o-hs/Documents/Learned Motion Matching/CustomLib.cpp" > CMakeFiles/Stepper.dir/CustomLib.cpp.i

CMakeFiles/Stepper.dir/CustomLib.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/Stepper.dir/CustomLib.cpp.s"
	/bin/x86_64-linux-gnu-g++-9 $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S "/home/pau1o-hs/Documents/Learned Motion Matching/CustomLib.cpp" -o CMakeFiles/Stepper.dir/CustomLib.cpp.s

# Object files for target Stepper
Stepper_OBJECTS = \
"CMakeFiles/Stepper.dir/Stepper.cpp.o" \
"CMakeFiles/Stepper.dir/CustomLib.cpp.o"

# External object files for target Stepper
Stepper_EXTERNAL_OBJECTS =

Stepper: CMakeFiles/Stepper.dir/Stepper.cpp.o
Stepper: CMakeFiles/Stepper.dir/CustomLib.cpp.o
Stepper: CMakeFiles/Stepper.dir/build.make
Stepper: /home/pau1o-hs/Documents/libtorch/lib/libtorch.so
Stepper: /home/pau1o-hs/Documents/libtorch/lib/libc10.so
Stepper: /home/pau1o-hs/Documents/libtorch/lib/libkineto.a
Stepper: /usr/local/cuda/lib64/stubs/libcuda.so
Stepper: /usr/local/cuda/lib64/libnvrtc.so
Stepper: /usr/local/cuda/lib64/libnvToolsExt.so
Stepper: /usr/local/cuda/lib64/libcudart.so
Stepper: /home/pau1o-hs/Documents/libtorch/lib/libc10_cuda.so
Stepper: /home/pau1o-hs/Documents/libtorch/lib/libc10_cuda.so
Stepper: /home/pau1o-hs/Documents/libtorch/lib/libc10.so
Stepper: /usr/local/cuda/lib64/libcufft.so
Stepper: /usr/local/cuda/lib64/libcurand.so
Stepper: /usr/local/cuda/lib64/libcublas.so
Stepper: /usr/lib/x86_64-linux-gnu/libcudnn.so
Stepper: /usr/local/cuda/lib64/libnvToolsExt.so
Stepper: /usr/local/cuda/lib64/libcudart.so
Stepper: CMakeFiles/Stepper.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir="/home/pau1o-hs/Documents/Learned Motion Matching/build/CMakeFiles" --progress-num=$(CMAKE_PROGRESS_3) "Linking CXX executable Stepper"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/Stepper.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/Stepper.dir/build: Stepper

.PHONY : CMakeFiles/Stepper.dir/build

CMakeFiles/Stepper.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/Stepper.dir/cmake_clean.cmake
.PHONY : CMakeFiles/Stepper.dir/clean

CMakeFiles/Stepper.dir/depend:
	cd "/home/pau1o-hs/Documents/Learned Motion Matching/build" && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" "/home/pau1o-hs/Documents/Learned Motion Matching" "/home/pau1o-hs/Documents/Learned Motion Matching" "/home/pau1o-hs/Documents/Learned Motion Matching/build" "/home/pau1o-hs/Documents/Learned Motion Matching/build" "/home/pau1o-hs/Documents/Learned Motion Matching/build/CMakeFiles/Stepper.dir/DependInfo.cmake" --color=$(COLOR)
.PHONY : CMakeFiles/Stepper.dir/depend

