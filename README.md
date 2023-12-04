# Starfive Parsec3 (Patched) 
# 1. Introduction
This repository focused on building & running PARSEC3 Benchmark suite on linux/amd64 and linux/riscv64 platforms.

Originally forked from [ppeetteerrs](https://github.com/ppeetteerrs/gem5-RISC-V-PARSEC), this repository adds some extra patches and adjustments to port the **whole** PARSEC3 benchmark suite to build & run successfully without errors on linux/amd64 and linux/riscv64.

Besides, as part of the port & build work, several docker container images are built and uploaded to the Dockerhub(flyinghorse0510), which facilitate the procedure of build & test dramatically. All Dockerfiles used for building these images can be found in the repository [Starfive Builder](http://192.168.110.45/sag/starfive_builder).

# 2. Benchmark status
Currently, all benchmarks can be compiled and run successfully without errors. The table below shows the benchmark status:

| Benchmark     | Compilation(linux/amd64, native)  | Compilation(linux/riscv64, native)   | Run(linux/amd64) | Run(linux/riscv64) | Previously run on FPGA(simmedium) |
| ------------- | --------------------------------- | ------------------------------------ | ---------------- | ------------------ | ------ |
| blackscholes  | ✅                                | ✅                                   | ✅               | ✅                 | ✅ |
| bodytrack     | ✅                                | ✅                                   | ✅               | ✅                 | ✅ |
| canneal       | ✅                                | ✅                                   | ✅               | ✅                 | ✅ |
| dedup         | ✅                                | ✅                                   | ✅               | ✅                 | ✅ |
| facesim       | ✅                                | ✅                                   | ✅               | ✅                 | ✅ |
| ferret        | ✅                                | ✅                                   | ✅               | ✅                 | ✅ |
| fluidanimate  | ✅                                | ✅                                   | ✅               | ✅                 | ✅ |
| freqmine      | ✅                                | ✅                                   | ✅               | ✅                 | ✅ |
| raytrace      | ✅                                | ✅                                   | ✅               | ✅                 | ✅ |
| streamcluster | ✅                                | ✅                                   | ✅               | ✅                 | ✅ |
| swaptions     | ✅                                | ✅                                   | ✅               | ✅                 | ✅ |
| vips          | ✅                                | ✅                                   | ✅               | ✅                 | ✅ |
| x264          | ✅                                | ✅                                   | ✅               | ✅                 | ✅ |

> All build and test work on linux/riscv64 is under QEMU emulator

**Typically, running on FPGA with simmedium size requires 10-20 hours to complete**

# 3. Extra Changes Made
The extra patches and adjustments made to port this benchmark suite are shown below:

| Benchmark     | Compile Error       | Runtime Error         | Cause        | Mitigation |
| ------------- | ------------------- | --------------------- | ------------ | ---------- |
| blackscholes  | / | / | / | / |
| bodytrack     | /| / | / | / |
| canneal       | / | / | / | / |
| dedup         | / | / | / | / |
| facesim       | / | segmentation fault | double-free memory in deconstruction of some class | remove `delete` in deconstruct function of that class |
| ferret        | / | program self-assert error | compile with `-O2` flag | fallback to `-O1` flag |
| fluidanimate  | / | / | / | / |
| freqmine      | / | / | / | / |
| raytrace      | 1. unsupported instructions on `riscv64` 2. static link with dynamic library | stuck after multi-thread execution | 1. lack `riscv64` implementation of `atomic-fetch-add` 2. inappropriate cmake configuration 3. double-destroy mutex lock and cond variable | 1. implement `atomic-fetch-add` in `riscv64` using C++ `<atomic>` library 2. hook `g++` to filter out `-Bdynamic` flag issued by cmake when compiling 3. remove `pthread_mutex_destroy` and `pthread_cond_destroy` in specific class |
| streamcluster | / | / | / | / |
| swaptions     | / | / | / | / |
| vips          | cross-compile error for `riscv64` | / | inappropriate cross-compile configuration | use native compile under QEMU emulator |
| x264          | / | segmentation fault | compile with `-O2` flag | fallback to `-O1` flag |

# 4. Build

Use customized and self-build docker container images to compile the benchmark suite. All Dockerfiles and scripts can be found within [Starfive Builder](http://192.168.110.45/sag/starfive_builder)

> Notice: currently you need to have sudo/root access to compile natively for `linux/riscv64` platform since it utilizes Linux kernel's binfmt_misc features which invokes QEMU user space emulator to run the `riscv64` version container directly on an `amd64` machine.

## 4.1 Clone source
```bash
# clone repo
git clone http://gitlab.starfivetech.com/sag/parsec-star5-fpga.git --depth 1
# pull benchmark input data from lfs storage
cd parsec-star5-fpga
git lfs pull
# extract benchmark input data
bash ./get-inputs
```

## 4.2 Build for `linux/amd64` platform

```bash
# enter source directory
cd parsec-star5-fpga
# build with container
docker run --rm -it -v .:/parsec3 -v ./amd64:/output --platform=linux/amd64  flyinghorse0510/parsec3-builder all
# if everything goes well, compiled and generated files will be under ./amd64 directory
# `images` contains the binary executables and helper bash scripts
# `logs` contains the build log
```

## 4.3 Build for `linux/riscv64` platform
> make sure you have the sudo/root access and the `binfmt` kernel module has been enabled for the current running kernel

```bash
# register for kernel's binfmt_misc
sudo docker run --privileged --rm flyinghorse0510/multiarch-riscv64 --reset
# enter source directory
cd parsec-star5-fpga
# build with container
docker run --rm -it -v .:/parsec3 -v ./riscv64:/output --platform=linux/riscv64  flyinghorse0510/parsec3-builder all
# if everything goes well, compiled and generated files will be under ./riscv64 directory
# `images` contains the binary executables and helper bash scripts
# `logs` contains the build log
```

# 5. Usage

under each benchmark's folder:

```bash
./run.sh <NUM_THREADS>
# for example
./run.sh 1 # run with 1 thread for this benchmark
./run.sh 4 # run with 4 threads for this benchmark
```

