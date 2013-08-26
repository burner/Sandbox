module lua;

import core.vararg;
import std.c.string;

alias double LUA_NUMBER;
alias ptrdiff_t LUA_INTEGER;
alias uint LUA_UNSIGNED;
const LUA_IDSIZE = 60;
//alias  LUA_REGISTRYINDEX LUAI_FIRSTPSEUDOIDX;
/*
/*
** $Id: lua.h,v 1.285 2013/03/15 13:04:22 roberto Exp $
** Lua - A Scripting Language
** Lua.org, PUC-Rio, Brazil (http://www.lua.org)
** See Copyright Notice at the end of this file
*/


//#ifndef lua_h
//#define lua_h
//
//#include <stdarg.h>
//#include <stddef.h>
//
//
//#include "luaconf.h"


//#define LUA_VERSION_MAJOR	"5"
//#define LUA_VERSION_MINOR	"2"
//#define LUA_VERSION_NUM		502
//#define LUA_VERSION_RELEASE	"2"
//
//#define LUA_VERSION	"Lua " LUA_VERSION_MAJOR "." LUA_VERSION_MINOR
//#define LUA_RELEASE	LUA_VERSION "." LUA_VERSION_RELEASE
//#define LUA_COPYRIGHT	LUA_RELEASE "  Copyright (C) 1994-2013 Lua.org, PUC-Rio"
//#define LUA_AUTHORS	"R. Ierusalimschy, L. H. de Figueiredo, W. Celes"


/* mark for precompiled code ('<esc>Lua') */
//const LUA_SIGNATURE	"\033Lua";
const char* LUA_SIGNATURE =	"Lua";

/* option for multiple returns in 'lua_pcall' and 'lua_call' */
const int LUA_MULTRET=	-1;


/*
** pseudo-indices
*/
const LUAI_FIRSTPSEUDOIDX = 1000000 - 1000;
alias LUAI_FIRSTPSEUDOIDX LUA_REGISTRYINDEX;
//alias lua_upvalueindex(i)	(LUA_REGISTRYINDEX - (i))
auto lua_upvalueindex(int i) {
	return LUA_REGISTRYINDEX-i;
}


/* thread status */
const LUA_OK=		0;
const LUA_YIELD=	1;
const LUA_ERRRUN=	2;
const LUA_ERRSYNTAX=	3;
const LUA_ERRMEM=	4;
const LUA_ERRGCMM=	5;
const LUA_ERRERR	=6;


struct lua_State {}

alias int function(lua_State *L) lua_CFunction;


/*
** functions that read/write blocks when loading/dumping Lua chunks
*/
alias const char * function(lua_State *L, void *ud, size_t *sz) lua_Reader ;

alias int function(lua_State *L, const void* p, size_t sz, void* ud) lua_Writer;


/*
** prototype for memory-allocation functions
*/
alias void * function(void *ud, void *ptr, size_t osize, size_t nsize) lua_Alloc;


/*
** basic types
*/
const LUA_TNONE	=	-1;

const LUA_TNIL	=	0;
const LUA_TBOOLEAN=		1;
const LUA_TLIGHTUSERDATA=	2;
const LUA_TNUMBER	=	3;
const LUA_TSTRING	=	4;
const LUA_TTABLE	=	5;
const LUA_TFUNCTION	=	6;
const LUA_TUSERDATA	=	7;
const LUA_TTHREAD	=	8;

const LUA_NUMTAGS	=	9;



/* minimum Lua stack available to a C function */
const LUA_MINSTACK=	20;


/* predefined values in the registry */
const LUA_RIDX_MAINTHREAD=	1;
const LUA_RIDX_GLOBALS=	2;
const LUA_RIDX_LAST	= 2;


/* type of numbers in Lua */
alias LUA_NUMBER lua_Number;


/* type for integer functions */
alias LUA_INTEGER lua_Integer;

/* unsigned integer type */
alias LUA_UNSIGNED lua_Unsigned;



/*
** generic extra include file
#if defined(LUA_USER_H)
#include LUA_USER_H
#endif
*/


/*
** RCS ident string
*/
//extern const char lua_ident[];


/*
** state manipulation
*/
extern(C) lua_State * lua_newstate (lua_Alloc f, void *ud);
extern(C) void       lua_close (lua_State *L);
extern(C) lua_State * lua_newthread (lua_State *L);
extern(C) 
extern(C) lua_CFunction lua_atpanic (lua_State *L, lua_CFunction panicf);
extern(C) 
extern(C) 
extern(C) const lua_Number * lua_version (lua_State *L);


/*
** basic stack manipulation
*/
extern(C) int   lua_absindex (lua_State *L, int idx);
extern(C) int   lua_gettop(lua_State *L);
extern(C) void  lua_settop(lua_State *L, int idx);
extern(C) void  lua_pushvalue(lua_State *L, int idx);
extern(C) void  lua_remove(lua_State *L, int idx);
extern(C) void  lua_insert(lua_State *L, int idx);
extern(C) void  lua_replace(lua_State *L, int idx);
extern(C) void  lua_copy(lua_State *L, int fromidx, int toidx);
extern(C) int   lua_checkstack(lua_State *L, int sz);
extern(C) 
extern(C) void  lua_xmove(lua_State *from, lua_State *to, int n);


/*
** access functions (stack -> C)
*/

extern(C) int             lua_isnumber(lua_State *L, int idx);
extern(C) int             lua_isstring(lua_State *L, int idx);
extern(C) int             lua_iscfunction(lua_State *L, int idx);
extern(C) int             lua_isuserdata(lua_State *L, int idx);
extern(C) int             lua_type(lua_State *L, int idx);
extern(C) const char     *lua_typename(lua_State *L, int tp);

extern(C) lua_Number      lua_tonumberx(lua_State *L, int idx, int *isnum);
extern(C) lua_Integer     lua_tointegerx(lua_State *L, int idx, int *isnum);
extern(C) lua_Unsigned    lua_tounsignedx(lua_State *L, int idx, int *isnum);
extern(C) int             lua_toboolean(lua_State *L, int idx);
extern(C) const char     *lua_tolstring(lua_State *L, int idx, size_t *len);
extern(C) size_t          lua_rawlen(lua_State *L, int idx);
extern(C) lua_CFunction   lua_tocfunction(lua_State *L, int idx);
extern(C) void	       *lua_touserdata(lua_State *L, int idx);
extern(C) lua_State      *lua_tothread(lua_State *L, int idx);
extern(C) const void     *lua_topointer(lua_State *L, int idx);


/*
** Comparison and arithmetic functions
*/

const LUA_OPADD	= 0;	/* ORDER TM */
const LUA_OPSUB	= 1;
const LUA_OPMUL	= 2;
const LUA_OPDIV	= 3;
const LUA_OPMOD	= 4;
const LUA_OPPOW	= 5;
const LUA_OPUNM	= 6;

extern(C) void  lua_arith(lua_State *L, int op);

const LUA_OPEQ	= 0;
const LUA_OPLT	= 1;
const LUA_OPLE	= 2;

extern(C) int   lua_rawequal(lua_State *L, int idx1, int idx2);
extern(C) int   lua_compare(lua_State *L, int idx1, int idx2, int op);


/*
** push functions (C -> stack)
*/
extern(C) void         lua_pushnil(lua_State *L);
extern(C) void         lua_pushnumber(lua_State *L, lua_Number n);
extern(C) void         lua_pushinteger(lua_State *L, lua_Integer n);
extern(C) void         lua_pushunsigned(lua_State *L, lua_Unsigned n);
extern(C) const char * lua_pushlstring(lua_State *L, const char *s, size_t l);
extern(C) const char * lua_pushstring(lua_State *L, const char *s);
extern(C) const char * lua_pushvfstring(lua_State *L, const char *fmt, va_list
		argp);

extern(C) const char * lua_pushfstring(lua_State *L, const char *fmt, ...);
extern(C) void  lua_pushcclosure(lua_State *L, lua_CFunction fn, int n);
extern(C) void  lua_pushboolean(lua_State *L, int b);
extern(C) void  lua_pushlightuserdata(lua_State *L, void *p);
extern(C) int   lua_pushthread(lua_State *L);


/*
** get functions (Lua -> stack)
*/
extern(C) void   lua_getglobal(lua_State *L, const char *var);
extern(C) void   lua_gettable(lua_State *L, int idx);
extern(C) void   lua_getfield(lua_State *L, int idx, const char *k);
extern(C) void   lua_rawget(lua_State *L, int idx);
extern(C) void   lua_rawgeti(lua_State *L, int idx, int n);
extern(C) void   lua_rawgetp(lua_State *L, int idx, const void *p);
extern(C) void   lua_createtable(lua_State *L, int narr, int nrec);
extern(C) void * lua_newuserdata(lua_State *L, size_t sz);
extern(C) int    lua_getmetatable(lua_State *L, int objindex);
extern(C) void   lua_getuservalue(lua_State *L, int idx);


/*
** set functions (stack -> Lua)
*/
extern(C) void  lua_setglobal(lua_State *L, const char *var);
extern(C) void  lua_settable(lua_State *L, int idx);
extern(C) void  lua_setfield(lua_State *L, int idx, const char *k);
extern(C) void  lua_rawset(lua_State *L, int idx);
extern(C) void  lua_rawseti(lua_State *L, int idx, int n);
extern(C) void  lua_rawsetp(lua_State *L, int idx, const void *p);
extern(C) int   lua_setmetatable(lua_State *L, int objindex);
extern(C) void  lua_setuservalue(lua_State *L, int idx);


/*
** 'load' and 'call' functions (load and run Lua code)
*/
extern(C) void  lua_callk(lua_State *L, int nargs, int nresults, int ctx,
                           lua_CFunction k);
//#define lua_call(L,n,r)		lua_callk(L, (n), (r), 0, NULL)
void lua_call(lua_State *L, int nargs, int nresults) {
	lua_callk(L, nargs, nresults, 0, null);
}

extern(C) int   lua_getctx(lua_State *L, int *ctx);

extern(C) int   lua_pcallk(lua_State *L, int nargs, int nresults, int errfunc,
                            int ctx, lua_CFunction k);

//#define lua_pcall(L,n,r,f)	lua_pcallk(L, (n), (r), (f), 0, NULL)
void lua_pcall(lua_State *L, int nargs, int nresults, int errfunc) {
	lua_pcallk(L, nargs, nresults, errfunc, 0, null);
}

extern(C) int   lua_load(lua_State *L, lua_Reader reader, void *dt,
                                        const char *chunkname,
                                        const char *mode);

extern(C) int lua_dump(lua_State *L, lua_Writer writer, void *data);


/*
** coroutine functions
*/
extern(C) int  lua_yieldk(lua_State *L, int nresults, int ctx,
                           lua_CFunction k);
//#define lua_yield(L,n)		lua_yieldk(L, (n), 0, NULL)
void lua_yield(lua_State *L, int nargs) {
	lua_yieldk(L, nargs, 0, null);
}
extern(C) int  lua_resume(lua_State *L, lua_State *from, int narg);
extern(C) int  lua_status(lua_State *L);

/*
** garbage-collection function and options
*/

const LUA_GCSTOP	=	0;
const LUA_GCRESTART	=	1;
const LUA_GCCOLLECT	=	2;
const LUA_GCCOUNT	=	3;
const LUA_GCCOUNTB	=	4;
const LUA_GCSTEP	=	5;
const LUA_GCSETPAUSE	=	6;
const LUA_GCSETSTEPMUL=	7;
const LUA_GCSETMAJORINC=	8;
const LUA_GCISRUNNING=		9;
const LUA_GCGEN	=	10;
const LUA_GCINC	=	11;

extern(C) int lua_gc(lua_State *L, int what, int data);


/*
** miscellaneous functions
*/

extern(C) int   lua_error(lua_State *L);

extern(C) int   lua_next(lua_State *L, int idx);

extern(C) void  lua_concat(lua_State *L, int n);
extern(C) void  lua_len   (lua_State *L, int idx);

extern(C) lua_Alloc lua_getallocf(lua_State *L, void **ud);
extern(C) void      lua_setallocf(lua_State *L, lua_Alloc f, void *ud);



/*
** ===============================================================
** some useful macros
** ===============================================================
*/

//#define lua_tonumber(L,i)	lua_tonumberx(L,i,NULL)
lua_Number lua_tonumber(lua_State *L, int idx) { 
	return lua_tonumberx(L, idx, null);
}

//#define lua_tointeger(L,i)	lua_tointegerx(L,i,NULL)
lua_Integer lua_tointeger(lua_State *L, int idx, int *isnum) {
	return lua_tointegerx(L, idx, null);
}

//#define lua_tounsigned(L,i)	lua_tounsignedx(L,i,NULL)
lua_Unsigned lua_tounsigned(lua_State *L, int idx, int *isnum) {
	return lua_tounsignedx(L, idx, null);
}

//#define lua_pop(L,n)		lua_settop(L, -(n)-1)
void  lua_pop(lua_State *L, int idx) {
	lua_settop(L, -(idx)-1);
}

//#define lua_newtable(L)		lua_createtable(L, 0, 0)
void lua_newtable(lua_State *L) {
	lua_createtable(L, 0, 0);
}

//#define lua_register(L,n,f) (lua_pushcfunction(L, (f)), lua_setglobal(L, (n)))
void lua_register(lua_State *L, lua_CFunction f, const char *var) {
	lua_pushcfunction(L, f);
	lua_setglobal(L, var);
}

//#define lua_pushcfunction(L,f)	lua_pushcclosure(L, (f), 0)
void lua_pushcfunction(lua_State *L, lua_CFunction f) {
	lua_pushcclosure(L, f, 0);
}

//#define lua_isfunction(L,n)	(lua_type(L, (n)) == LUA_TFUNCTION)
bool lua_isfunction(lua_State *L, int idx) {
	return lua_type(L, idx) == LUA_TFUNCTION;
}

//#define lua_istable(L,n)	(lua_type(L, (n)) == LUA_TTABLE)
bool lua_istable(lua_State *L, int idx) {
	return lua_type(L, idx) == LUA_TTABLE;
}
//#define lua_islightuserdata(L,n)	(lua_type(L, (n)) == LUA_TLIGHTUSERDATA)
bool lua_islightuserdata(lua_State *L, int idx) {
	return lua_type(L, idx) == LUA_TLIGHTUSERDATA;
}
//#define lua_isnil(L,n)		(lua_type(L, (n)) == LUA_TNIL)
bool lua_isnil(lua_State *L, int idx) {
	return lua_type(L, idx) == LUA_TNIL;
}
//#define lua_isboolean(L,n)	(lua_type(L, (n)) == LUA_TBOOLEAN)
bool lua_isboolean(lua_State *L, int idx) {
	return lua_type(L, idx) == LUA_TBOOLEAN;
}
//#define lua_isthread(L,n)	(lua_type(L, (n)) == LUA_TTHREAD)
bool lua_isthread(lua_State *L, int idx) {
	return lua_type(L, idx) == LUA_TTHREAD;
}
//#define lua_isnone(L,n)		(lua_type(L, (n)) == LUA_TNONE)
bool lua_isnone(lua_State *L, int idx) {
	return lua_type(L, idx) == LUA_TNONE;
}
//#define lua_isnoneornil(L, n)	(lua_type(L, (n)) <= 0)
bool lua_isnoneornul(lua_State *L, int idx) {
	return lua_type(L, idx) <= 0;
}

//#define lua_pushliteral(L, s)	\
//	lua_pushlstring(L, "" s, (sizeof(s)/sizeof(char))-1)
const char* lua_pushliteral(lua_State *L, const char* s) {
	return lua_pushlstring(L, s, strlen(s));
}

//#define lua_pushglobaltable(L)  \
	//lua_rawgeti(L, LUA_REGISTRYINDEX, LUA_RIDX_GLOBALS)
void lua_pushglobaltable(lua_State *L) {
	lua_rawgeti(L, LUA_REGISTRYINDEX, LUA_RIDX_GLOBALS);
}

//#define lua_tostring(L,i)	lua_tolstring(L, (i), NULL)
const char* lua_tostring(lua_State *L, int idx) {
	return lua_tolstring(L, idx, null);
}


/*
** {======================================================================
** Debug API
** =======================================================================
*/


/*
** Event codes
*/
const LUA_HOOKCALL=	0;
const LUA_HOOKRET=	1;
const LUA_HOOKLINE=	2;
const LUA_HOOKCOUNT=	3;
const LUA_HOOKTAILCALL =4;


/*
** Event masks
*/
const LUA_MASKCALL	= (1 << LUA_HOOKCALL);
const LUA_MASKRET	= (1 << LUA_HOOKRET);
const LUA_MASKLINE	= (1 << LUA_HOOKLINE);
const LUA_MASKCOUNT	= (1 << LUA_HOOKCOUNT);

//struct lua_Debug{}  /* activation record */


/* Functions to be called by the debugger in specific events */
alias void function(lua_State *L, lua_Debug *ar) lua_Hook;


extern(C) int lua_getstack(lua_State *L, int level, lua_Debug *ar);
extern(C) int lua_getinfo(lua_State *L, const char *what, lua_Debug *ar);
extern(C) const char * lua_getlocal(lua_State *L, const lua_Debug *ar, int n);
extern(C) const char * lua_setlocal(lua_State *L, const lua_Debug *ar, int n);
extern(C) const char * lua_getupvalue(lua_State *L, int funcindex, int n);
extern(C) const char * lua_setupvalue(lua_State *L, int funcindex, int n);

extern(C) void * lua_upvalueid(lua_State *L, int fidx, int n);
extern(C) void  lua_upvaluejoin(lua_State *L, int fidx1, int n1, int fidx2,
		int n2);

extern(C) int lua_sethook(lua_State *L, lua_Hook func, int mask, int count);
extern(C) lua_Hook lua_gethook(lua_State *L);
extern(C) int lua_gethookmask(lua_State *L);
extern(C) int lua_gethookcount(lua_State *L);


struct lua_Debug {
  int event;
  const char *name;	/* (n) */
  const char *namewhat;	/* (n) 'global', 'local', 'field', 'method' */
  const char *what;	/* (S) 'Lua', 'C', 'main', 'tail' */
  const char *source;	/* (S) */
  int currentline;	/* (l) */
  int linedefined;	/* (S) */
  int lastlinedefined;	/* (S) */
  ubyte nups;	/* (u) number of upvalues */
  ubyte nparams;/* (u) number of parameters */
  char isvararg;        /* (u) */
  char istailcall;	/* (t) */
  char short_src[LUA_IDSIZE]; /* (S) */
  /* private part */
  void *i_ci;  /* active function */
}

/* }====================================================================== */


/******************************************************************************
* Copyright (C) 1994-2013 Lua.org, PUC-Rio.
*
* Permission is hereby granted, free of charge, to any person obtaining
* a copy of this software and associated documentation files (the
* "Software"), to deal in the Software without restriction, including
* without limitation the rights to use, copy, modify, merge, publish,
* distribute, sublicense, and/or sell copies of the Software, and to
* permit persons to whom the Software is furnished to do so, subject to
* the following conditions:
*
* The above copyright notice and this permission notice shall be
* included in all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
* MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
* IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
* CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
* TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
* SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
******************************************************************************/


//#endif
