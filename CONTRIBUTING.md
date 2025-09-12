# Contributing to kspaceFirstOrder

First off, thank you for considering contributing to `kspaceFirstOrder`. It's people like you that make this such a great tool. Following these guidelines helps to communicate that you respect the time of the developers managing and developing this open source project. In return, they should reciprocate that respect in addressing your issue, assessing changes, and helping you finalize your pull requests.

## Code of Conduct

This project and everyone participating in it is governed by a [Code of Conduct](CODE_OF_CONDUCT.md) (to be created). By participating, you are expected to uphold this code. Please report unacceptable behavior.

## How Can I Contribute?

### Reporting Bugs

This section guides you through submitting a bug report for `kspaceFirstOrder`. Following these guidelines helps maintainers and the community understand your report, reproduce the behavior, and find related reports.

- **Use a clear and descriptive title** for the issue to identify the problem.
- **Describe the exact steps which reproduce the problem** in as much detail as possible.
- **Provide specific examples to demonstrate the steps.** Include links to files or copy/pasteable snippets, which you use in those examples.
- **Explain which behavior you expected to see instead and why.**

### Suggesting Enhancements

This section guides you through submitting an enhancement suggestion for `kspaceFirstOrder`, including completely new features and minor improvements to existing functionality.

- **Use a clear and descriptive title** for the issue to identify the suggestion.
- **Provide a step-by-step description of the suggested enhancement** in as much detail as possible.
- **Explain why this enhancement would be useful** to most `kspaceFirstOrder` users.

## Your First Code Contribution

Unsure where to begin contributing to `kspaceFirstOrder`? You can start by looking through these `good-first-issue` and `help-wanted` issues:
- **Good first issues** - issues which should only require a few lines of code, and a test or two.
- **Help wanted issues** - issues which should be a bit more involved than `good-first-issue` issues.

### Submitting Changes

1.  **Fork the repository** and create a new branch from `main` for your feature or bug fix.
2.  **Make your changes.** Make sure to follow the code style.
3.  **Install pre-commit hooks** to automatically format your code and check for issues before you commit:
    ```bash
    # Install the pre-commit tool (if you haven't already)
    pip install pre-commit

    # Set up the git hook scripts
    pre-commit install
    ```
    Now, `clang-format` and other checks will run automatically on every commit.
4.  **Build and test your changes** locally to ensure everything passes.
5.  **Commit your changes** with a clear and descriptive commit message.
6.  **Push your branch** to your fork.
7.  **Open a pull request** to the `main` branch of the main repository.
8.  **Provide a clear title and description** for your pull request, explaining the "what" and "why" of your changes.
9.  Your pull request will be reviewed. Once approved, it will be merged.

## Development Setup

The `kspaceFirstOrder` project is built using C++11 and relies on CMake for its build process. The core dependencies are HDF5 and FFTW, which are managed automatically by CMake's `FetchContent` command.

### Build Acceleration with a Compiler Cache

To dramatically speed up build times, especially for the third-party dependencies managed by `FetchContent`, we strongly recommend using a compiler cache like `sccache`.

1.  **Install `sccache`:**
    -   **macOS:** `brew install sccache`
    -   **Windows:** `choco install sccache`
    -   **Linux:** Follow the [official installation instructions](https://github.com/mozilla/sccache).

2.  **Configure CMake:**
    The build system will automatically detect and use `sccache` if it is installed on your system.
    ```bash
    cmake .. # Add any other flags like -DBUILD_TESTS=ON
    ```
    The first time you build, it will compile and cache the dependencies. Subsequent builds, even in a clean directory, will be significantly faster.

### Building and Running Tests

To build and run the test suite:

1.  **Configure with tests enabled:**
    ```bash
    mkdir build && cd build
    cmake .. -DBUILD_TESTS=ON
    ```
2.  **Build the project:**
    ```bash
    cmake --build . --parallel
    ```
3.  **Run the tests:**
    ```bash
    ctest -V
    ```

## Code Style

This project uses the **Google C++ Style Guide** for both formatting and static analysis. We use `.clang-format` and `.clang-tidy` to automatically enforce these standards.

Before submitting a pull request, please format your code:

```bash
# From the root of the repository
clang-format -i --style=file $(find src -name "*.cpp" -o -name "*.h" -o -name "*.cu" -o -name "*.cuh")
```

**Note:** Code formatting is automatically checked in CI. Pull requests with formatting issues will fail to pass CI checks.

### Static Analysis

This project uses **Clang-Tidy** for static analysis to catch potential bugs, performance issues, and code quality problems. The analysis follows **Google C++ Style Guide** standards.

Static analysis is run in CI on every push and pull request. The analysis includes:
- **Google style compliance** (google-* checks)
- **Bug detection** (bugprone-* checks)
- **Code quality** (readability-*, misc-* checks)
- **Performance issues** (performance-* checks)
- **Modern C++ best practices** (modernize-* checks)

You can run static analysis locally:

```bash
# Configure with compile_commands.json
mkdir build && cd build
cmake .. -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DUSE_CUDA=OFF -DUSE_OPENMP=ON -DCMAKE_BUILD_TYPE=Debug

# Run clang-tidy on specific files
clang-tidy ../src/some/file.cpp -p .

# Or run on all source files
find ../src -name "*.cpp" -o -name "*.cu" | xargs clang-tidy -p .
```

**Note:** Static analysis results are currently informational in CI. Once a baseline is established, critical issues will become CI failures.

### Pre-Commit Hooks

We use `pre-commit` to run automated checks before each commit. This helps ensure that all code entering the repository adheres to our style and quality standards.

After installing the hooks with `pre-commit install`, the following checks will run on every commit:
-   **`clang-format`**: Automatically formats C++ code.
-   **Markdown Link Check**: Verifies that all links in Markdown files are valid.
-   **Basic file checks**: Fixes trailing whitespace and ensures consistent end-of-file conventions.

## Adding New Backends

When adding a new computational backend (e.g., for a different architecture), please adhere to the following principles:

1.  **Create a new directory** under `src/backends/`.
2.  **Implement the core interfaces** defined in `src/core/`. This ensures that the new backend integrates seamlessly with the existing application logic.
3.  **Add a new CMake configuration option** in the main `CMakeLists.txt` to enable or disable the backend (e.g., `-DUSE_NEW_BACKEND=ON`).
4.  **Update the documentation** with build instructions and any specific requirements for the new backend.
5.  **Add tests** to the `tests/` directory to validate the correctness of the new implementation.
