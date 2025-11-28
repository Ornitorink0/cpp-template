# ---------------------------------------------------------
#  Project Settings
# ---------------------------------------------------------
APP_NAME = app
BUILD_DIR = build
NPROC = $(shell nproc)
CMAKE_FLAGS = -DCMAKE_CXX_STANDARD=20 -DCMAKE_EXPORT_COMPILE_COMMANDS=ON

.PHONY: first-build build run debug release install format clean watch add-module fetch-modules test

# ---------------------------------------------------------
#  Configure
# ---------------------------------------------------------
configure:
	@mkdir -p $(BUILD_DIR)
	@echo "> Running CMake configure (cmake -S . -B build -G Ninja)"
	cd $(BUILD_DIR) && cmake -G Ninja $(CMAKE_FLAGS) .. && ninja -j$(NPROC)

# ---------------------------------------------------------
#  Incremental Build
# ---------------------------------------------------------
build:
	@mkdir -p $(BUILD_DIR)
	# Configure if the build files are missing
	@if [ ! -f "$(BUILD_DIR)/build.ninja" ]; then \
		cd $(BUILD_DIR) && cmake -G Ninja $(CMAKE_FLAGS) ..; \
	fi
	cd $(BUILD_DIR) && ninja -j$(NPROC)

# ---------------------------------------------------------
#  Run
# ---------------------------------------------------------
run: build
	@echo "> Running $(APP_NAME)"
	@./$(BUILD_DIR)/$(APP_NAME)

# ---------------------------------------------------------
#  Debug Mode
# ---------------------------------------------------------
debug:
	@mkdir -p $(BUILD_DIR)
	cd $(BUILD_DIR) && cmake -G Ninja $(CMAKE_FLAGS) -DCMAKE_BUILD_TYPE=Debug .. && ninja -j$(NPROC)
	./$(BUILD_DIR)/$(APP_NAME)

# ---------------------------------------------------------
#  Release Mode
# ---------------------------------------------------------
release:
	@mkdir -p $(BUILD_DIR)
	cd $(BUILD_DIR) && cmake -G Ninja $(CMAKE_FLAGS) -DCMAKE_BUILD_TYPE=Release .. && ninja -j$(NPROC)

# ---------------------------------------------------------
#  Install System-wide
# ---------------------------------------------------------
install: release
	@echo "> Installing to /usr/local/bin"
	@cp $(BUILD_DIR)/$(APP_NAME) /usr/local/bin/$(APP_NAME)

# ---------------------------------------------------------
#  Code Formatting
# ---------------------------------------------------------
format:
	@find src include \( \
		-name '*.c' -o -name '*.cc' -o -name '*.cpp' -o -name '*.cxx' -o -name '*.c++' -o -name '*.cp' -o \
		-name '*.h' -o -name '*.hh' -o -name '*.hpp' -o -name '*.hxx' -o -name '*.h++' -o -name '*.hp' \
	\) | xargs clang-format -i
	@echo "> Formatting complete"

# ---------------------------------------------------------
#  Clean Build Directory
# ---------------------------------------------------------
clean:
	rm -rf $(BUILD_DIR)

# ---------------------------------------------------------
#  Auto Build & Run on File Change
# ---------------------------------------------------------
watch: first-build
	@if command -v fswatch >/dev/null 2>&1; then \
		fswatch -o src include | while read _; do \
			ninja -C $(PWD)/$(BUILD_DIR) -j$(NPROC); \
			$(PWD)/$(BUILD_DIR)/$(APP_NAME); \
		done; \
	elif command -v entr >/dev/null 2>&1; then \
		find src include -type f | entr -r sh -c "ninja -C $(PWD)/$(BUILD_DIR) -j$(NPROC) && $(PWD)/$(BUILD_DIR)/$(APP_NAME)"; \
	else \
		echo "Error: Install 'fswatch' or 'entr' to use watch mode."; \
		exit 1; \
	fi

# ---------------------------------------------------------
#  Git Submodule Utility
# ---------------------------------------------------------
add-module:
	@if [ -z "$(LIB_URL)" ]; then \
		echo "Error: Provide LIB_URL=<git repo> to add as submodule."; \
		exit 1; \
	fi
	@mkdir -p lib/external
	@git submodule add $(LIB_URL) lib/external/$(notdir $(LIB_URL))
	@echo "> Module added in lib/external/"

fetch-modules:
	@git submodule update --init --recursive
	@echo "> All modules updated."

# ---------------------------------------------------------
#  Tests Placeholder
# ---------------------------------------------------------
test:
	@echo "> No tests yet"
