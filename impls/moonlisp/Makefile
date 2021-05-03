
CC=clang
CFLAGS=-I/usr/local/opt/lua/include/lua5.4 -L/usr/local/opt/lua/lib -shared
DEPS=-llua -lreadline

all: 
	$(CC) lua_readline.c -o readline.so $(CFLAGS) $(DEPS)

clean:
	rm ./*.so

