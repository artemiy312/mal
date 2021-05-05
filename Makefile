
CC=clang
CFLAGS=-I/usr/local/opt/lua/include/lua5.4 -shared
LDFLAGS=-L/usr/local/opt/lua/lib
LDLIBS=-llua -lreadline

STEPS=$(wildcard step*.lua)
TESTS=$(wildcard test_*.lua)
DEPS=lpeg.so readline.so

$(STEPS): $(DEPS)
$(TESTS): luaunit.lua $(DEPS)

readline.so: lua_readline.c
	$(CC) $(CFLAGS) $(LDFLAGS) $(LDLIBS) $< -o $@

lpeg.so:
	luarocks install --tree ./ lpeg
	ln -sf $$(find . -name $@) $@

luaunit.lua:
	luarocks install --tree ./ luaunit
	ln -sf $$(find . -name $@) $@

.PHONY: clean test
clean:
	-rm ./*.so luaunit.lua
	-rm -r share lib lua_modules

test: $(TESTS)
	lua $<

