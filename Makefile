PREFIX ?= /usr/local
DESTDIR ?=

.PHONY: install uninstall test

install:
	@PREFIX=$(PREFIX) DESTDIR=$(DESTDIR) ./install.sh

uninstall:
	@PREFIX=$(PREFIX) DESTDIR=$(DESTDIR) ./uninstall.sh

test:
	@tests/run_tests.sh
