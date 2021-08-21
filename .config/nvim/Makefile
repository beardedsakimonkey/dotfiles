.PHONY: compile
.SILENT: compile

SRC_FILES := $(basename $(shell find fnl -type f -name "*.fnl" | cut -d'/' -f2-))

compile:
	rm -rf lua
	for f in $(SRC_FILES); do \
		mkdir -p lua/$$(dirname $$f); \
		fennel --no-compiler-sandbox --compile fnl/$$f.fnl > lua/$$f.lua; \
	done
