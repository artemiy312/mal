#include <stdlib.h>
#include <readline/readline.h>
#include <readline/history.h>
#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

static int l_readline(lua_State *L)
{
    const char *prompt = luaL_checkstring(L, 1);
    char *input = readline(prompt);
    if (!input) {
        lua_pushnil(L);
    } else {
        lua_pushstring(L, input);
        if (input[0]) {
            add_history(input);
        }
        free(input);
    }

    return 1;
};

static const luaL_Reg fns[] = {
    {"readline", l_readline},
    {NULL, NULL}  /* sentinel */
};

int luaopen_readline(lua_State *L)
{
    luaL_newlib(L, fns);
    return 1;
};

