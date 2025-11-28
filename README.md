# C++ Template · CMake + Ninja

Starter for C++20 apps with a sample `main`. Reusable code goes in `lib/` (compiled as a library and automatically linked).

## Requirements

- CMake ≥ 3.10
- Ninja (Makefile aborts if missing)
- C++20 compiler (ccache used if present)

## Quick Usage

1. `make configure` — configures (CMake) and compiles in `build/`.
2. `make run` — runs the binary (after build).
3. `make watch` – auto-build & run on source change (requires `fswatch` or `entr`).

## Makefile Targets

- `make run` — compiles if needed and runs.
- `make build` — recompiles using the existing configuration.
- `make debug` / `make release` — build profiles (Debug adds `-Werror`, Release uses `-O2`).
- `make install` — installs to `/usr/local/bin/app` (often requires `sudo`).
- `make watch` — recompiles/runs on changes (requires `fswatch` or `entr`).
- `make format` — runs `clang-format` on sources/headers (requires clang-format in PATH).
- `make add-module LIB_URL=<git repo>` — adds a git submodule under `lib/external/`.
- `make fetch-modules` – fetch all git submodules under `lib/external/`.
- `make clean` — deletes `build/`.

## Structure

- `src/main.cpp` — example entrypoint.
- `lib/` — shared code; if the directory is empty, the library is not built.
- `include/` — public headers (`version.hpp` includes the example version).
- `CMakelists.txt` — project configuration: warnings, standard C++20, `compile_commands.json` enabled.
- `Makefile` — Ninja build shortcuts; check for Ninja before starting.

## Helpful Notes

- You can delete the example files (`lib/`, `src/main.cpp`, `include/version.hpp`, ect.) and CMake will continue configuring itself: the library is created only if `lib/` has sources.
- `.gitmodules` tracks external libraries added with `make add-module`; a default example (`lib/external/json.git`) is included. Run `git submodule update --init --recursive` after cloning to fetch them.
 
### CI and pre-commit

- A GitHub Actions workflow (.github/workflows/ci.yml) runs `make first-build` and `make build` on clean runners (Linux and macOS) to ensure `make first-build` works on new machines and PRs.
- A `.pre-commit-config.yaml` is included to help keep the codebase tidy — install pre-commit locally and register hooks with:

```bash
pip install pre-commit
pre-commit install
pre-commit run --all-files
```

Add a `.clang-format` file if you want a stable formatting policy used by pre-commit's clang-format hook.
- Add `.vscode/` to `.gitignore` if you want to ignore IDE files.

### Adding Dependencies (General Approach)

This repository is a *template* — `lib/external/json.git` is just an example. Here you'll find general guidelines and options for adding libraries to your project in a clean and repeatable way.

1) Vendoring / Submodule (Simple, Reproducible)
- Add the library into `lib/external/<name>` (e.g., with `make add-module`, which creates a git submodule).
- If the library contains a `CMakeLists.txt`, add its target to `add_subdirectory(lib/external/<name>)`.
- **Pros**: Reproducibility, offline work, dependency version control.
- **Cons**: Multiple files in the repo, manual updates.

2) FetchContent (downloads at configure time)
- CMake downloads the dependency if it's not vendored.
- Example:

```cmake
include(FetchContent)
FetchContent_Declare(
    foo
    GIT_REPOSITORY https://github.com/someone/foo.git
    GIT_TAG v1.2.3
)
FetchContent_MakeAvailable(foo)
# then link: target_link_libraries(my_target PUBLIC foo::foo)
```

3) add_subdirectory (if the library is present locally)
- When the library is included in the repo (submodule or subfolder), use `add_subdirectory(lib/external/<name>)` and link its target.
- This is the default behavior of the template when it finds a submodule with CMake.

4) find_package (search for packages installed on the system or managed via the package manager)
- If the library exposes a package config (e.g., `fooConfig.cmake`), use `find_package(foo REQUIRED)` and then `target_link_libraries(my_target PRIVATE foo::foo)`.

5) Package manager (conan / vcpkg)
- For real-world projects, use conan or vcpkg for centralized dependency management.
- Integrate with CMake via toolchain or `find_package` and configure CI to use the same technique.
---

Personalize as you want, and enjoy programming!

Made with love by Ornitorink0 ☕️❤️
