# kspaceFirstOrder - Unified C++ Implementation

[![CI](https://github.com/your-org/kspaceFirstOrder-unified/actions/workflows/ci.yml/badge.svg)](https://github.com/your-org/kspaceFirstOrder-unified/actions/workflows/ci.yml)
[![License: LGPL v3](https://img.shields.io/badge/License-LGPL%20v3-blue.svg)](https://www.gnu.org/licenses/lgpl-3.0)

## Overview

k-Wave is an open source toolbox originally written MATLAB designed for the time-domain simulation of propagating acoustic waves in 1D, 2D, or 3D. The toolbox has a wide range of functionality, but at its heart is an numerical model that can account for both linear or nonlinear wave propagation, an arbitrary distribution of heterogeneous material parameters, and power law acoustic absorption. See the [k-Wave website](http://www.k-wave.org) for further details.

This project is a unified C++ implementation of the k-Wave toolbox that accelerates 2D/3D simulations using optimized implementations for different computational backends:

- **OpenMP**: Multi-threaded CPU implementation for shared memory systems
- **CUDA**: GPU-accelerated implementation for NVIDIA GPUs

The unified codebase supports small to moderate grid sizes (e.g., 128×128 to 10,000×10,000 in 2D or 64×64×64 to 512×512×512 in 3D) on systems with shared memory or CUDA-capable GPUs. 2D simulations can be carried out in both normal and axisymmetric coordinate systems (OpenMP only).

## Features

- **Unified Build System**: Cross-platform CMake-based build system
- **Multiple Backends**: OpenMP (CPU) and CUDA (GPU) implementations
- **Cross-Platform**: Linux, macOS, and Windows support
- **High Performance**: Optimized for modern CPUs and GPUs
- **Flexible**: Support for linear/nonlinear wave propagation
- **Extensible**: Easy to add new backends or platforms

## Repository Structure

- **`CMakeLists.txt`** - Main CMake configuration and build setup
- **`cmake/`** - CMake modules for dependency detection, compiler flags, and platform setup
- **`src/`** - Unified source code organized by functionality:
  - **`core/`** - Shared functionality (containers, HDF5 I/O, logging, parameters, utilities)
  - **`backends/`** - Backend-specific implementations (OpenMP CPU, CUDA GPU)
  - **`platforms/`** - Platform-specific code (Linux/macOS, Windows)
- **`tests/`** - Test suite for validation and regression testing
- **`docs/`** - Documentation and API reference
- **`scripts/`** - Build and utility scripts
- **`plans/`** - Project planning and unification documentation
- **`.github/`** - GitHub Actions CI/CD workflows
- **`LICENSE.md`** - Project license information

## Prerequisites

This project uses CMake's **FetchContent** module for automatic dependency management, which automatically downloads and builds most required libraries during the build process.

### Essential Requirements

- **C++ Compiler**: GCC 6.0+, Intel C++ 2018+, or Visual Studio 2017+
- **CMake**: Version 3.18 or higher
- **Git**: For downloading dependencies via FetchContent

### Automatically Managed Dependencies

The following dependencies are automatically downloaded and built during compilation:

- **HDF5 Library**: Version 1.14.4 (fetched from GitHub)
- **FFTW Library**: Version 3.3.10 (for OpenMP backend, fetched from official site)
- **Zlib**: For HDF5 compression support (included with HDF5)

### Backend-Specific Dependencies

#### OpenMP Backend (Default)
- **OpenMP**: Version 4.0+ (included with most modern compilers)

#### CUDA Backend (Optional)
- **CUDA Toolkit**: Version 9.0 - 11.x
- **NVIDIA GPU**: With compute capability 3.0+

### Platform-Specific Requirements

#### Linux
```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install build-essential cmake git

# CentOS/RHEL/Fedora
sudo yum install gcc gcc-c++ cmake git
```

#### macOS
```bash
# Using Homebrew
brew install cmake git
```

#### Windows
- Install [Visual Studio 2017+](https://visualstudio.microsoft.com/) with C++ development tools
- Install [CMake](https://cmake.org/download/)
- Install [Git](https://git-scm.com/download/win) (if not already installed)

## Building

### Quick Start

```bash
# Clone the repository
git clone https://github.com/waltsims/kspaceFirstOrder-unified.git
cd kspaceFirstOrder-unified

# (Optional) Install system dependencies automatically
# Supports Ubuntu/Debian, Fedora/RHEL, Arch, and macOS (Homebrew)
./install_dependencies.sh

# Create build directory
mkdir build && cd build

# Configure with CMake
cmake .. -DUSE_CUDA=OFF  # For OpenMP only
# or
cmake .. -DUSE_CUDA=ON   # For CUDA support

# Build
cmake --build . --config Release --parallel
```

### One-time Dependency Installer (Optional)

For a smoother setup on Linux and macOS, you can use the provided installer to install CMake and system libraries (HDF5, FFTW3, pkg-config) via your native package manager.

```bash
# From the repository root
./install_dependencies.sh
```

What it does:
- Detects your OS (Ubuntu/Debian, Fedora/RHEL, Arch, macOS)
- Installs required packages using apt/dnf/pacman/brew
- Verifies installation of CMake, HDF5, FFTW3, and a C++ compiler

Notes:
- On macOS you need Homebrew installed first. If you do not have it, the script will print the install command.
- If a system package is not available or too old, the CMake build will still fall back to building dependencies from source via FetchContent.

### Detailed Build Instructions

#### 1. Configure Build Options

The build system supports several configuration options:

```bash
# Basic configuration
cmake .. \
  -DCMAKE_BUILD_TYPE=Release \
  -DUSE_CUDA=ON \
  -DUSE_OPENMP=ON \
  -DBUILD_TESTS=OFF

# Advanced options
cmake .. \
  -DCMAKE_INSTALL_PREFIX=/usr/local \
  -DHDF5_ROOT=/path/to/hdf5 \
  -DCUDA_TOOLKIT_ROOT_DIR=/path/to/cuda \
  -DCMAKE_CXX_COMPILER=g++-9
```

#### 2. Build Configuration Options

| Option | Default | Description |
|--------|---------|-------------|
| `USE_CUDA` | `OFF` | Enable CUDA GPU backend |
| `USE_OPENMP` | `ON` | Enable OpenMP CPU backend |
| `BUILD_TESTS` | `OFF` | Build test suite |
| `CMAKE_BUILD_TYPE` | `Release` | Build type (Debug/Release) |

#### 3. Platform-Specific Builds

##### Linux with CUDA
```bash
cmake .. \
  -DUSE_CUDA=ON \
  -DCUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda \
  -DHDF5_ROOT=/usr/local/hdf5

make -j$(nproc)
```

##### macOS with OpenMP
```bash
cmake .. \
  -DUSE_CUDA=OFF \
  -DCMAKE_OSX_SYSROOT=/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk

make -j$(sysctl -n hw.ncpu)
```

##### Windows with Visual Studio
```bash
cmake .. \
  -G "Visual Studio 16 2019" \
  -DUSE_CUDA=ON \
  -DHDF5_ROOT="C:/Program Files/HDF5"

cmake --build . --config Release --parallel
```

### Build Artifacts

After successful compilation, the following files are created:

- `kspaceFirstOrder-OMP`: OpenMP CPU executable
- `kspaceFirstOrder-CUDA`: CUDA GPU executable (if CUDA enabled)
- `*.so/*.dylib/*.dll`: Shared libraries (if configured)

## Usage

### Command Line Interface

Both executables support the same command-line interface:

```bash
# Show help
./kspaceFirstOrder-OMP --help
./kspaceFirstOrder-CUDA --help

# Basic simulation run
./kspaceFirstOrder-OMP -i input.h5 -o output.h5

# Advanced options
./kspaceFirstOrder-CUDA \
  --input_file=input.h5 \
  --output_file=output.h5 \
  --checkpoint_file=checkpoint.h5 \
  --verbose \
  --progress_print_interval=10
```

### Input/Output Format

The simulation uses HDF5 format for input and output data:

- **Input**: Simulation parameters, material properties, and initial conditions
- **Output**: Time-series data, sensor recordings, and checkpoint files
- **Format**: Compatible with k-Wave MATLAB toolbox

### Backend Selection

The appropriate backend is automatically selected based on:

1. **CUDA Backend**: Used when CUDA is available and requested
2. **OpenMP Backend**: Default fallback for CPU-only systems
3. **Automatic Detection**: CMake automatically detects available backends

## Performance Optimization

### CPU Optimization (OpenMP)

```bash
# Use all available CPU cores
export OMP_NUM_THREADS=$(nproc)
./kspaceFirstOrder-OMP -i input.h5

# Pin threads to specific cores (Linux)
export OMP_PROC_BIND=close
```

### GPU Optimization (CUDA)

```bash
# Select specific GPU
export CUDA_VISIBLE_DEVICES=0
./kspaceFirstOrder-CUDA -i input.h5

# Multi-GPU support (future feature)
export CUDA_VISIBLE_DEVICES=0,1
```

### Memory Considerations

- **CPU**: Limited by system RAM
- **GPU**: Limited by GPU memory
- **Large Simulations**: Use checkpoint/restart functionality
- **Out-of-Core**: Automatic memory management for large grids

## Testing

### Build Tests
```bash
# Enable testing during configuration
cmake .. -DBUILD_TESTS=ON
cmake --build . --target test
```

### Functional Testing
```bash
# Run basic functionality tests
ctest -V

# Run specific test categories
ctest -R "integration"
ctest -R "performance"
```

## Development

### Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/new-feature`
3. Make your changes and add tests
4. Run the test suite: `ctest`
5. Submit a pull request

### Code Style

- Use C++11 standard features
- Follow the existing code style and naming conventions
- Add documentation for new functions and classes
- Include unit tests for new functionality

### Adding New Backends

1. Create new directory under `src/backends/`
2. Implement required interfaces from `src/core/`
3. Add CMake configuration in `src/CMakeLists.txt`
4. Update documentation and build instructions

## Troubleshooting

### Common Issues

#### CMake Configuration Errors
- Ensure all dependencies are installed and in PATH
- Check HDF5 library version compatibility
- Verify CUDA toolkit installation (if using CUDA)

#### Compilation Errors
- Check compiler version compatibility
- Ensure C++11 support is enabled
- Verify include paths and library linking

#### Runtime Errors
- Check input file format and parameters
- Verify GPU memory availability (CUDA)
- Ensure proper thread affinity (OpenMP)

### Getting Help

- **Documentation**: Check the `docs/` directory
- **Issues**: Report bugs on GitHub Issues
- **Discussions**: Use GitHub Discussions for questions
- **k-Wave Community**: Visit the [k-Wave website](http://www.k-wave.org)

## License

This project is licensed under the GNU Lesser General Public License v3.0. See the [LICENSE](LICENSE.md) file for details.

## Citation

If you find this software useful for your academic work, please consider citing:

**B. E. Treeby, J. Jaros, A. P. Rendell, and B. T. Cox**, "Modeling nonlinear ultrasound propagation in heterogeneous media with power law absorption using a k-space pseudospectral method," J. Acoust. Soc. Am., vol. 131, no. 6, pp. 4324-4336, 2012.

**J. Jaros, A. P. Rendell, and B. E. Treeby**, "Full-wave nonlinear ultrasound simulation on distributed clusters with applications in high-intensity focused ultrasound," Int. J. High Perform. Comput., vol. 30, no. 2, pp. 137-155, 2016.

## Acknowledgments

This software was developed by the SC@FIT Research Group at Brno University of Technology as part of the k-Wave toolbox project.
