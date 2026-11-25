# HPC Assignment #1: Optimization of ADI (Alternating-Direction Implicit)

This project focuses on the parallelization and performance optimization of the **ADI (Alternating-Direction Implicit)** integration kernel from the [Polybench/C](https://sourceforge.net/p/polybench/wiki/Home/) benchmark suite using **CUDA**.

---

## Authors Information

- **Raffaele Cimino**  
  - GitHub: [@Rafxf04](https://github.com/Rafxf04) 
  - Email: [401858@studenti.unimore.it](mailto:401858@studenti.unimore.it)   
  - Role: Implementation of optimized CUDA kernels (), algorithmic optimizations (), benchmark presentation (`Problem-Anatomy-and-Profiling-the-ADI-Alternating-Direction-Implicit-Stencil-Solver.pptx`), and test script improvements.

- **Sorelle Sandra Simo Defo** (Sandra0502)  
  - GitHub: [@Sandra0502](https://github.com/Sandra0502)  
  - Email: [403213@studenti.unimore.it](mailto:403213@studenti.unimore.it)  
  - Role: Implementation of CUDA parallelization variants ().

---

## Project Structure & Implementations

### Reference Implementation
- **`adi_ref.c` (Reference - `ref`)**:
  - Pure sequential baseline version directly from Polybench/C.

### Raffaele Cimino Implementations (`_rc`)


### Sandra Implementations (`Method*`)


### Headers, Build System & Documentation
- **`adi.h`**:
  - Problem definitions, dataset dimension presets (`MINI`, `SMALL`, `STANDARD`, `LARGE`, `EXTRALARGE`), and data types (`DATA_TYPE`).
- **`common/`**:
  - Polybench support utilities for accurate timing measurement (`POLYBENCH_TIME`) and array dumping (`POLYBENCH_DUMP_ARRAYS`):
    - `common/polybench.c`: Core timing and array print routines.
    - `common/polybench.h`: Definitions, configuration switches, and macro helpers.
- **`Makefile`**:
  - GNU Make build system configured with CUDA (`nvcc`)
- **`test.sh`**:
  - Automated bash verification script that compares output matrices against the reference sequential run (`adi_ref`).
- **`Problem-Anatomy-and-Profiling-the-ADI-Alternating-Direction-Implicit-Stencil-Solver.pptx`**:
  - Presentation and profiling analysis of the ADI stencil solver on an NVIDIA Jetson Nano (quad-core ARM Cortex-A57), covering performance metrics, cache locality, SIMD vectorization, and efficiency comparisons.

---

## Building and Configuration

The build system is driven by `make`.

### Available Targets
- `make build`: Compiles the binary without executing it.
- `make run`: Compiles (if needed) and executes the target binary.
- `make all`: Compiles all available `adi_*` implementations.
- `make clean`: Removes all compiled `adi_*` executables.

### Build Variables
You can pass the following variables to `make`:
- **`VER`**: Specifies which implementation to build (default: `ref`).  
  Available values:
  - **Sequential Baseline**: `ref`
  - **Raffaele Cimino Implementations**: 
  - **Sandra Implementations**: 
- **`DATASET`**: Specifies the problem dimensions (default: `mini`).  
  Available sizes:
  - `mini`: $N = 32$, $TSTEPS = 2$
  - `small`: $N = 500$, $TSTEPS = 10$
  - `standard`: $N = 1024$, $TSTEPS = 50$ (Polybench default)
  - `large`: $N = 2000$, $TSTEPS = 50$
  - `extralarge`: $N = 4000$, $TSTEPS = 100$
- **`NTHREADS`**: Sets the compilation macro for thread count (default: host core count via `nproc`).
- **`DUMP_ARRAYS`**: When set (e.g. `DUMP_ARRAYS=1`), enables output array dumping to `stderr` for numerical verification.

---

## Commands for Reproducing the Experiments

All execution times are measured directly by the Polybench timing harness in seconds.

### 1. Clean Build Environment
Always ensure previous builds are cleared before running benchmarks:
```sh
make clean
```

### 2. Baseline Sequential Benchmark
Measure the execution time of the sequential reference implementation:
```sh
# Run with standard dataset
make run VER=ref DATASET=standard

# Run with large dataset
make run VER=ref DATASET=large
```

### 3. Benchmarking Parallel Versions with Default Threads
Build and run each parallel version:
```sh
# Raffaele Cimino implementations
make run VER=v1_rc DATASET=standard

# Sandra implementations

```

## Verification & Correctness Checking

To verify that the parallel optimizations produce identical results to the reference code, use the verification script `test.sh`.

### Running the Test Script
```sh
# Test specific versions with standard dataset
./test.sh v1_rc


# Test with a specific dataset size (e.g. mini or small)
DATASET=small ./test.sh v2_rc
```

### How Verification Works
1. The script (`./test.sh`) compiles `adi_ref` with `DUMP_ARRAYS=1`, dumping the matrix elements formatted to standard error (`stderr`).
2. The reference output is cached in `/tmp/hpc-lab-ref_$DATASET.txt`.
3. The specified parallel version is compiled with `DUMP_ARRAYS=1` and its output redirected to a temporary file via `mktemp`.
4. A file comparison (`diff -q`) checks that all elements match the sequential reference.
