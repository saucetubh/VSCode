CC     = gcc
CFLAGS = -Wall -g

all: rr priority tab

rr: rr.c
	$(CC) $(CFLAGS) -o rr rr.c

priority: priority.c
	$(CC) $(CFLAGS) -o priority priority.c

tab: tab.c
	$(CC) $(CFLAGS) -o tab tab.c -pthread

check: 
	sh check.sh

clean:
	rm -f rr priority tab
