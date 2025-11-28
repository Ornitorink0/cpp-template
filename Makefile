APP_NAME = app
BUILD_DIR = build
NPROC = $(shell nproc)
CMAKE_FLAGS = -DCMAKE_CXX_STANDARD=20 -DCMAKE_EXPORT_COMPILE_COMMANDS=ON

.PHONY: build run debug release install format clean watch first-build

first-build:
	@mkdir -p $(BUILD_DIR)
	cd $(BUILD_DIR) && cmake -G Ninja .. && ninja -j$(NPROC)

build:
	cd $(BUILD_DIR) && ninja -j$(NPROC)

run: build
	@echo "Running $(APP_NAME)..."
	@echo "-------------------------"
	@./$(BUILD_DIR)/$(APP_NAME)

debug:
	@mkdir -p $(BUILD_DIR)
	cd $(BUILD_DIR) && cmake -G Ninja $(CMAKE_FLAGS) -DCMAKE_BUILD_TYPE=Debug .. && ninja -j$(NPROC)
	./$(BUILD_DIR)/$(APP_NAME)

release:
	@mkdir -p $(BUILD_DIR)
	cd $(BUILD_DIR) && cmake -G Ninja $(CMAKE_FLAGS) -DCMAKE_BUILD_TYPE=Release .. && ninja -j$(NPROC)

install: release
	@echo "Installing binary to /usr/local/bin"
	@cp $(BUILD_DIR)/$(APP_NAME) /usr/local/bin/$(APP_NAME)

format:
	find src include \( \
		-name '*.cpp' -o \
		-name '*.cxx' -o \
		-name '*.cc' -o \
		-name '*.c++' -o \
		-name '*.cp' -o \
		-name '*.hh' -o \
		-name '*.hpp' -o \
		-name '*.hxx' -o \
		-name '*.h++' -o \
		-name '*.hp' \
	\) | xargs clang-format -i

clean:
	rm -rf $(BUILD_DIR)

watch: first-build
	@if command -v fswatch >/dev/null 2>&1; then \
		fswatch -o src include | while read num; do \
			ninja -C $(PWD)/build -j$(NPROC); \
			$(PWD)/build/$(APP_NAME); \
		done; \
	elif command -v entr >/dev/null 2>&1; then \
		find src include -type f | entr -r sh -c "ninja -C $(PWD)/build -j$(NPROC) && $(PWD)/build/$(APP_NAME)"; \
	else \
		echo "Error: No watcher found (install fswatch or entr)."; \
		exit 1; \
	fi

# ---------------------------- Library Management ---------------------------- #
# Usage:
#   make add-module LIB_URL=https://github.com/user/repo.git
# This will clone the library into the 'lib/external' folder.

add-module:
	@if [ -z "$(LIB_URL)" ]; then \
		echo "Error: Provide LIB_URL=<git repo> to add as submodule."; \
		exit 1; \
	fi
	@mkdir -p lib/external
	@git submodule add $(LIB_URL) lib/external/$(notdir $(LIB_URL))
	@echo "Library added as git submodule in lib/external/"

fetch-modules:
	@git submodule update --init --recursive
	@echo "All submodules have been initialized and updated."

# ---------------------------------- Testing --------------------------------- #
test:
	@echo "No tests yet"
