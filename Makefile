
CC=clang
CFLAGS=-I/usr/local/opt/lua/include/lua5.4 -shared
LDFLAGS=-L/usr/local/opt/lua/lib
LDLIBS=-llua -lreadline

STEPS=step1_read_print.lua, step0_repl.lua
STEPS=$(wildcard step*.lua)

$(STEPS): readline.so
step0_repl.lua: readline.so
readline.so: lua_readline.c
	$(CC) $(CFLAGS) $(LDFLAGS) $(LDLIBS) $< -o $@


.PHONY: clean
clean:
	-rm ./*.so

