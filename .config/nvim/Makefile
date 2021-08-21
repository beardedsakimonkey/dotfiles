.PHONY: compile
.SILENT: compile

SRC_FILES := $(basename $(shell find lua -type f -name "*.fnl" | cut -d'/' -f2-))

compile:
	for f in $(SRC_FILES); do \
		fennel --compile lua/$$f.fnl > lua/$$f.lua; \
	done
