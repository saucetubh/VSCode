CC = gcc
CFLAGS = -Wall

task_manager: task_manager.c
	$(CC) $(CFLAGS) -o $@ $<

task_manager-sol: task_manager-sol.c
	$(CC) $(CFLAGS) -o $@ $<

clean:
	rm -f task_manager task_manager-sol output.txt

test: task_manager
	@for f in tests/*.txt; do \
		echo "=== $$f ==="; \
		./task_manager --test-mode $$f && cat output.txt; \
		echo; \
	done

test-sol: task_manager-sol
	@for f in tests/*.txt; do \
		echo "=== $$f ==="; \
		./task_manager-sol --test-mode $$f && cat output.txt; \
		echo; \
	done

grade: task_manager
	python3 autograder.py

.PHONY: clean test test-sol grade
