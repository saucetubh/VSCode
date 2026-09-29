CC = gcc
CFLAGS = -g

.PHONY: all demo demo-rw grade grade-buddy grade-rw clean
all: buddy rw

buddy: buddy.c
	$(CC) $(CFLAGS) $< -o $@

demo: buddy
	./buddy examples/demo.txt

rw: rw.c
	$(CC) $(CFLAGS) $< -o $@ -pthread

# Runs writer and reader concurrently so shared-memory updates are visible
# live instead of only after the writer exits. Try it yourself across two
# terminals: `RW_DEMO_STAGGER_MS=300 ./rw write` in one, `./rw read` in the
# other (start the writer first).
demo-rw: rw
	RW_DEMO_STAGGER_MS=300 ./rw write & \
	writer_pid=$$!; \
	sleep 0.1; \
	timeout 10s ./rw read; \
	reader_status=$$?; \
	wait $$writer_pid; \
	writer_status=$$?; \
	test $$reader_status -eq 0 && test $$writer_status -eq 0

# Keep going so both tasks are checked even if one fails to build or run.
grade:
	@$(MAKE) --no-print-directory -k grade-buddy grade-rw

grade-buddy: check_buddy.c buddy.c
	@echo "Task 1: Buddy allocator"
	$(CC) $(CFLAGS) -I. check_buddy.c -o grader
	timeout 10s ./grader

grade-rw: check-rw.c rw.c
	@echo "Task 2: Shared memory"
	$(CC) $(CFLAGS) -I. check-rw.c -o grader-rw -pthread
	timeout 10s ./grader-rw

clean:
	rm -f buddy rw grader grader-rw shared.bin
