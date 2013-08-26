import lua;
import lauxlib;
import lualib;

import std.string;
import std.conv;

void main() {
	lua_State *lua_state;
	lua_state = luaL_newstate();
	/*luaL_Reg[] lualibs = [
		[ "base", luaopen_base],
        [null, null]
    ];*/

	lua_CFunction b = cast(int function(lua_State*))&luaopen_base;
	auto l = luaL_Reg("base", cast(int function(lua_State*))b);
	l.func(lua_state);
	lua_settop(lua_state, 0);
	luaL_dofile(lua_state, toStringz("hellolua.lua"));
	lua_close(lua_state);
}
