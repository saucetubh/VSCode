# Build the TaskWatch controller and its separate worker executable.
CC = gcc
CFLAGS ?= -std=c11 -Wall -Wextra -Wpedantic

.PHONY: all clean

all: taskwatch worker

taskwatch: taskwatch.o process_manager.o
	$(CC) $(CFLAGS) -o $@ $^

worker: worker.o
	$(CC) $(CFLAGS) -o $@ $^

taskwatch.o: taskwatch.c process_manager.h
process_manager.o: process_manager.c process_manager.h
worker.o: worker.c process_manager.h

clean:
	rm -f taskwatch worker *.o
