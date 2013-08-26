module lualib;

import lua;

/*
** $Id: lualib.h,v 1.43 2011/12/08 12:11:37 roberto Exp $
** Lua standard libraries
** See Copyright Notice in lua.h


#ifndef lualib_h
#define lualib_h

#include "lua.h"


*/
extern(C) {
int luaopen_base(lua_State *L);

const char[] LUA_COLIBNAME=	"coroutine";
int luaopen_coroutine(lua_State *L);

const char[] LUA_TABLIBNAME=	"table";
int luaopen_table(lua_State *L);

const char[] LUA_IOLIBNAME	= "io";
int luaopen_io(lua_State *L);

const char[] LUA_OSLIBNAME	= "os";
int luaopen_os(lua_State *L);

const char[] LUA_STRLIBNAME	= "string";
int luaopen_string(lua_State *L);

const char[] LUA_BITLIBNAME	= "bit32";
int luaopen_bit32(lua_State *L);

const char[] LUA_MATHLIBNAME= 	"math";
int luaopen_math(lua_State *L);

const char[] LUA_DBLIBNAME	= "debug";
int luaopen_debug(lua_State *L);

//#define LUA_LOADLIBNAME	"package"
const char[] LUA_LOADLIBNAME=	"package";
int luaopen_package(lua_State *L);


/* open all previous libraries */
void luaL_openlibs(lua_State *L);
}
/*
#if !defined(lua_assert)
#define lua_assert(x)	((void)0)
#endif


#endif
*/
