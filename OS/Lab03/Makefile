CC      := gcc
CFLAGS  := -Wall -Wextra -g

MAIN_SRC := main.c
OUT      := out
BIN_DIR  := $(OUT)/lab_bin

PROGRAMS      := programs
PROGRAMS_FAULT := programs_fault
TESTS         := tests

.PHONY: test clean

test: $(OUT)/orchestrator $(BIN_DIR)/.stamp
	python3 grade.py \
		--orchestrator $(OUT)/orchestrator \
		--programs-dir $(BIN_DIR) \
		--tests-dir $(TESTS)

$(OUT)/orchestrator: $(MAIN_SRC)
	mkdir -p $(OUT)
	$(CC) $(CFLAGS) -o $@ $(MAIN_SRC)

$(BIN_DIR)/.stamp: $(wildcard $(PROGRAMS)/*.c) $(wildcard $(PROGRAMS_FAULT)/*.c)
	mkdir -p $(BIN_DIR)
	for f in $(PROGRAMS)/*.c $(PROGRAMS_FAULT)/*.c; do \
		$(CC) $(CFLAGS) -o $(BIN_DIR)/$$(basename $$f .c) $$f; \
	done
	touch $@

clean:
	rm -rf $(OUT)