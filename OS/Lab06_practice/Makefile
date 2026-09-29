CC = gcc
CFLAGS = -g

.PHONY: all demo grade grade-flalloc grade-pool check-examples clean
all: flalloc pool

flalloc: flalloc.c
	$(CC) $(CFLAGS) $< -o $@

pool: pool.c
	$(CC) $(CFLAGS) $< -o $@

demo: flalloc pool
	./flalloc examples/slides.txt
	./pool examples/pool_demo.txt

# Keep going so both tasks are checked even if one fails to build or run.
grade:
	@$(MAKE) --no-print-directory -k grade-flalloc grade-pool

grade-flalloc: check_flalloc.c flalloc.c
	@echo "Task 1: Free-list allocator"
	$(CC) $(CFLAGS) -I. check_flalloc.c -o grader-fl
	timeout 10s ./grader-fl

grade-pool: check_pool.c pool.c
	@echo "Task 2: Pool allocator on sbrk"
	$(CC) $(CFLAGS) -I. check_pool.c -o grader-pool
	timeout 10s ./grader-pool

# Compare your program's output with the saved expected output.
check-examples: flalloc pool
	@for f in slides fits coalesce edges; do \
	  ./flalloc examples/$$f.txt | diff -u examples/$$f.expected - >/dev/null \
	    && echo "PASS: $$f" || echo "FAIL: $$f (diff examples/$$f.expected <(./flalloc examples/$$f.txt))"; done
	@for f in pool_demo pool_full; do \
	  ./pool examples/$$f.txt | diff -u examples/$$f.expected - >/dev/null \
	    && echo "PASS: $$f" || echo "FAIL: $$f (diff examples/$$f.expected <(./pool examples/$$f.txt))"; done

clean:
	rm -f flalloc pool grader-fl grader-pool
