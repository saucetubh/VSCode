CC = gcc
CFLAGS = -Wall -Wextra -std=c99 -g

OBJS = sim_framework.o paging.o

.PHONY: all test clean

all: $(OBJS)

%.o: %.c paging_sim.h
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(OBJS)
	rm -rf .build

test:
	python3 grader.py test --suite public --n "$(N)"
