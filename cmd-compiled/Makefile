CFLAGS = -Wall -Wextra -O3

.PHONY: all

all: subimage-search

clean:
	rm -f subimage-search

subimage-search: subimage-search.cpp
	g++ ${CFLAGS} `pkg-config --libs --cflags opencv` -o $@ $^
