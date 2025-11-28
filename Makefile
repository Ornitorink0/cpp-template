APP_NAME = app
BUILD_DIR = build
NPROC = $(shell nproc)

first-build:
	@mkdir -p $(BUILD_DIR)
	cd $(BUILD_DIR) && cmake -G Ninja .. && ninja -j$(NPROC)

build:
	cd $(BUILD_DIR) && ninja -j$(NPROC)

run: build
	./$(BUILD_DIR)/$(APP_NAME)

debug:
	@mkdir -p $(BUILD_DIR)
	cd $(BUILD_DIR) && cmake -G Ninja -DCMAKE_BUILD_TYPE=Debug .. && ninja -j$(NPROC)
	./$(BUILD_DIR)/$(APP_NAME)

release:
	@mkdir -p $(BUILD_DIR)
	cd $(BUILD_DIR) && cmake -G Ninja -DCMAKE_BUILD_TYPE=Release .. && ninja -j$(NPROC)

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