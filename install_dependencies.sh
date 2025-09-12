#!/bin/bash
set -e

# k-spaceFirstOrder Build System Enhancement - Dependency Installer
# This script provides cross-platform dependency installation for k-spaceFirstOrder

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

log_success() {
    echo -e "${GREEN}✓${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

log_error() {
    echo -e "${RED}✗${NC} $1"
}

# Determine sudo usage (act often runs as root without sudo)
if [ "$(id -u)" -eq 0 ]; then
    SUDO=""
elif command -v sudo >/dev/null 2>&1; then
    SUDO="sudo"
else
    SUDO=""
fi

# Function to detect OS
detect_os() {
    log_info "Detecting operating system..."

    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command -v apt-get >/dev/null 2>&1; then
            OS="ubuntu"
            PACKAGE_MANAGER="apt-get"
            log_success "Detected Ubuntu/Debian Linux"
        elif command -v dnf >/dev/null 2>&1; then
            OS="fedora"
            PACKAGE_MANAGER="dnf"
            log_success "Detected Fedora/RHEL Linux"
        elif command -v pacman >/dev/null 2>&1; then
            OS="arch"
            PACKAGE_MANAGER="pacman"
            log_success "Detected Arch Linux"
        else
            log_error "Unsupported Linux distribution. No supported package manager found."
            log_info "Supported: apt-get (Ubuntu/Debian), dnf (Fedora/RHEL), pacman (Arch)"
            exit 1
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
        PACKAGE_MANAGER="brew"
        log_success "Detected macOS"
    else
        log_error "Unsupported operating system: $OSTYPE"
        log_info "Supported: Linux (Ubuntu/Debian, Fedora/RHEL, Arch), macOS"
        exit 1
    fi
}

# Function to install Ubuntu/Debian packages
install_ubuntu() {
    log_info "Installing dependencies for Ubuntu/Debian..."

    # Update package list
    log_info "Updating package list..."
    ${SUDO} apt-get update

    # Install required packages
    REQUIRED_PACKAGES="build-essential cmake libhdf5-dev libfftw3-dev pkg-config"
    log_info "Installing: $REQUIRED_PACKAGES"
    ${SUDO} apt-get install -y $REQUIRED_PACKAGES

    log_success "Ubuntu/Debian dependencies installed successfully"
}

# Function to install Fedora/RHEL packages
install_fedora() {
    log_info "Installing dependencies for Fedora/RHEL..."

    # Install required packages
    REQUIRED_PACKAGES="gcc-c++ cmake hdf5-devel fftw-devel pkgconfig"
    log_info "Installing: $REQUIRED_PACKAGES"
    ${SUDO} dnf install -y $REQUIRED_PACKAGES

    log_success "Fedora/RHEL dependencies installed successfully"
}

# Function to install Arch Linux packages
install_arch() {
    log_info "Installing dependencies for Arch Linux..."

    # Install required packages
    REQUIRED_PACKAGES="gcc cmake hdf5 fftw pkgconf"
    log_info "Installing: $REQUIRED_PACKAGES"
    ${SUDO} pacman -S --needed $REQUIRED_PACKAGES

    log_success "Arch Linux dependencies installed successfully"
}

# Function to install macOS packages
install_macos() {
    log_info "Installing dependencies for macOS..."

    # Check if Homebrew is installed
    if ! command -v brew >/dev/null 2>&1; then
        log_error "Homebrew is not installed."
        log_info "Please install Homebrew first:"
        log_info "  /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
        exit 1
    fi

    # Install required packages (skip ones already installed to avoid tap conflicts)
    # libomp provides OpenMP runtime for Apple Clang
    REQUIRED_PACKAGES=(cmake hdf5 fftw pkg-config libomp)
    TO_INSTALL=()
    for PKG in "${REQUIRED_PACKAGES[@]}"; do
        if brew list --formula "$PKG" >/dev/null 2>&1; then
            log_info "Already installed: $PKG (skipping)"
        else
            TO_INSTALL+=("$PKG")
        fi
    done
    if [ ${#TO_INSTALL[@]} -gt 0 ]; then
        log_info "Installing: ${TO_INSTALL[*]}"
        brew install "${TO_INSTALL[@]}"
    else
        log_info "All required Homebrew packages already installed"
    fi

    log_success "macOS dependencies installed successfully"

    # If running in GitHub Actions, export pkg-config and CMake hints for dependencies
    if [[ -n "${GITHUB_ENV}" ]]; then
        BREW_PREFIX=$(brew --prefix)
        echo "PKG_CONFIG_PATH=${BREW_PREFIX}/opt/fftw/lib/pkgconfig:${BREW_PREFIX}/opt/hdf5/lib/pkgconfig:${PKG_CONFIG_PATH}" >> "${GITHUB_ENV}"
        echo "CMAKE_PREFIX_PATH=${BREW_PREFIX}/opt/fftw;${BREW_PREFIX}/opt/hdf5;${CMAKE_PREFIX_PATH}" >> "${GITHUB_ENV}"
        echo "HDF5_ROOT=${BREW_PREFIX}/opt/hdf5" >> "${GITHUB_ENV}"
        echo "FFTW_ROOT=${BREW_PREFIX}/opt/fftw" >> "${GITHUB_ENV}"
        log_info "Exported Homebrew pkg-config and CMake paths to GITHUB_ENV"
    fi
}

# Function to verify installations
verify_installation() {
    log_info "Verifying installations..."

    # Check CMake
    if command -v cmake >/dev/null 2>&1; then
        CMAKE_VERSION=$(cmake --version | head -n1)
        log_success "CMake: $CMAKE_VERSION"
    else
        log_error "CMake not found"
        return 1
    fi

    # Check HDF5
    if [[ "$OS" == "macos" ]]; then
        if brew list hdf5 >/dev/null 2>&1; then
            log_success "HDF5: Installed via Homebrew"
        else
            log_warning "HDF5: Not found via Homebrew"
        fi
    else
        if pkg-config --exists hdf5; then
            HDF5_VERSION=$(pkg-config --modversion hdf5)
            log_success "HDF5: $HDF5_VERSION"
        else
            log_warning "HDF5: Not found via pkg-config"
        fi
    fi

    # Check FFTW3
    if pkg-config --exists fftw3; then
        FFTW_VERSION=$(pkg-config --modversion fftw3)
        log_success "FFTW3: $FFTW_VERSION"
    else
        log_warning "FFTW3: Not found via pkg-config"
    fi

    # Check compiler
    if command -v g++ >/dev/null 2>&1; then
        GCC_VERSION=$(g++ --version | head -n1)
        log_success "Compiler: $GCC_VERSION"
    elif command -v clang++ >/dev/null 2>&1; then
        CLANG_VERSION=$(clang++ --version | head -n1)
        log_success "Compiler: $CLANG_VERSION"
    else
        log_error "No C++ compiler found"
        return 1
    fi

    return 0
}

# Main execution
main() {
    echo "========================================"
    echo "k-spaceFirstOrder Dependency Installer"
    echo "========================================"

    # Detect OS
    detect_os

    # Install dependencies based on OS
    case $OS in
        ubuntu)
            install_ubuntu
            ;;
        fedora)
            install_fedora
            ;;
        arch)
            install_arch
            ;;
        macos)
            install_macos
            ;;
        *)
            log_error "Unsupported OS: $OS"
            exit 1
            ;;
    esac

    # Verify installation
    echo
    if verify_installation; then
        log_success "All dependencies installed successfully!"
        echo
        log_info "Next steps:"
        log_info "  1. Configure: cmake -S . -B build -DCMAKE_BUILD_TYPE=Release -DUSE_OPENMP=ON"
        log_info "  2. Build: cmake --build build --parallel"
        log_info "  3. The build system will automatically detect system packages"
    else
        log_warning "Some dependencies may not be properly installed"
        log_info "You can still build k-spaceFirstOrder, but it may fall back to building dependencies from source"
    fi
}

# Run main function
main "$@"
