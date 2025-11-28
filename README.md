# C++ Template · CMake + Ninja

Starter for C++20 apps with a sample `main`. Reusable code goes in `lib/` (compiled as a library and automatically linked).

## Requirements

- CMake ≥ 3.10
- Ninja (Makefile aborts if missing)
- C++20 compiler (ccache used if present)

## Quick Usage

1. `make first-build` — configures and compiles in `build/`.
2. `make run` — runs the binary (just for testing binaries).
3. `make watch` – have fun programming while watching the changes in real time!

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

- You can delete the example files (`lib/`, `src/main.cpp`, `include/version.hpp`) and CMake will continue configuring itself: the library is created only if `lib/` has sources.
- `.gitmodules` tracks external libraries added with `make add-module`; a default example (`lib/external/json.git`) is included. Run `git submodule update --init --recursive` after cloning to fetch them.
- Add `.vscode/` to `.gitignore` if you want to ignore IDE files.

---

Personalize as you want, and enjoy programming!

Made with love by Ornitorink0 ☕️❤️
