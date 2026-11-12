CC = gcc
CFLAGS = -Wall -Wextra -g

OBJS = .build/sim_framework.o .build/paging.o

.PHONY: all run test list clean

all: $(OBJS)

.build:
	mkdir -p $@

.build/%.o: %.c paging_sim.h | .build
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

.build/paging_lab: $(OBJS) .build/paging_test_driver.o
	$(CC) $(CFLAGS) $^ -o $@

run: export LAB08_RUN_INPUT = $(INPUT)
run: export LAB08_RUN_NUMBER = $(N)
run: .build/paging_lab
	@if [ -n "$$LAB08_RUN_INPUT" ] && [ -n "$$LAB08_RUN_NUMBER" ]; then \
		echo "Choose either INPUT=commands.txt or N=<test number>." >&2; exit 1; \
	elif [ -n "$$LAB08_RUN_INPUT" ]; then \
		./.build/paging_lab "$$LAB08_RUN_INPUT"; \
	elif [ -n "$$LAB08_RUN_NUMBER" ]; then \
		set -- public/tests/*.txt; \
		case "$$LAB08_RUN_NUMBER" in *[!0-9]*) \
			echo "N must be one test number." >&2; exit 1;; esac; \
		if [ "$$LAB08_RUN_NUMBER" -lt 1 ] || [ "$$LAB08_RUN_NUMBER" -gt "$$#" ]; then \
			echo "N must be between 1 and $$#." >&2; exit 1; \
		fi; \
		shift "$$((LAB08_RUN_NUMBER - 1))"; \
		./.build/paging_lab "$$1"; \
	else \
		echo "Usage: make run INPUT=commands.txt or make run N=1" >&2; exit 1; \
	fi

test:
	python3 grader.py test --suite public --n "$(N)"

list:
	python3 grader.py list

clean:
	rm -rf .build
