module lauxlib;

import std.conv;
import std.string;
import core.stdc.stdio;

alias BUFSIZ LUAL_BUFFERSIZE;
/*
** $Id: lauxlib.h,v 1.120 2011/11/29 15:55:08 roberto Exp $
** Auxiliary functions for building Lua libraries
** See Copyright Notice in lua.h
*/


//#ifndef lauxlib_h
//#define lauxlib_h
//
//
//#include <stddef.h>
//#include <stdio.h>

//#include "lua.h"
import lua;

/* extra error code for `luaL_load' */
//#define LUA_ERRFILE     (LUA_ERRERR+1)


struct luaL_Reg {
  const(char) *name;
  lua_CFunction func;

  this(string n, lua_CFunction f) {
	  name = toStringz(n);
	  func = f;
  }
}


//void luaL_checkversion_(lua_State *L, lua_Number ver);
//##define luaL_checkversion(L)	luaL_checkversion_(L, LUA_VERSION_NUM)


extern(C) {
int luaL_getmetafield(lua_State *L, int obj, const(char) *e);
int luaL_callmeta(lua_State *L, int obj, const(char) *e);
const(char) * luaL_tolstring(lua_State *L, int idx, size_t *len);
int luaL_argerror(lua_State *L, int numarg, const(char) *extramsg);
const(char) * luaL_checklstring(lua_State *L, int numArg,
                                                size_t *l);
const(char) * luaL_optlstring(lua_State *L, int numArg,
                                const(char) *def, size_t *l);
lua_Number luaL_checknumber(lua_State *L, int numArg);
lua_Number luaL_optnumber(lua_State *L, int nArg, lua_Number def);

lua_Integer luaL_checkinteger(lua_State *L, int numArg);
lua_Integer luaL_optinteger(lua_State *L, int nArg, lua_Integer def);
lua_Unsigned luaL_checkunsigned(lua_State *L, int numArg);
lua_Unsigned luaL_optunsigned(lua_State *L, int numArg, lua_Unsigned def);

void luaL_checkstack(lua_State *L, int sz, const(char) *msg);
void luaL_checktype(lua_State *L, int narg, int t);
void luaL_checkany(lua_State *L, int narg);

int    luaL_newmetatable(lua_State *L, const(char) *tname);
void   luaL_setmetatable(lua_State *L, const(char) *tname);
void * luaL_testudata(lua_State *L, int ud, const(char) *tname);
void * luaL_checkudata(lua_State *L, int ud, const(char) *tname);

void luaL_where(lua_State *L, int lvl);
int luaL_error(lua_State *L, const(char) *fmt, ...);

int luaL_checkoption(lua_State *L, int narg, const(char) *def,
                                   const(char)** lst);

int luaL_fileresult(lua_State *L, int stat, const(char) *fname);
int luaL_execresult(lua_State *L, int stat);
}

/* pre-defined references */
//#define LUA_NOREF       (-2)
const LUA_NOREF = -2;
//#define LUA_REFNIL      (-1)
const LUA_REFNIL = -1;

extern(C) {
int luaL_ref(lua_State *L, int t);
void luaL_unref(lua_State *L, int t, int re);

int luaL_loadfilex(lua_State *L, const(char) *filename, const(char) *mode);
}

//#define luaL_loadfile(L,f)	luaL_loadfilex(L,f,NULL)
int luaL_loadfile(lua_State *L, const(char)* filename) {
	return luaL_loadfilex(L, filename, null);
}

extern(C) {
int luaL_loadbufferx(lua_State *L, const(char) *buff, size_t sz,
                                   const(char) *name, const(char) *mode);
int luaL_loadstring(lua_State *L, const(char) *s);

lua_State * luaL_newstate();

int luaL_len(lua_State *L, int idx);

const(char) * luaL_gsub(lua_State *L, const(char) *s, const(char) *p, const(char) *r);

void luaL_setfuncs(lua_State *L, const luaL_Reg *l, int nup);

int luaL_getsubtable(lua_State *L, int idx, const(char) *fname);

void luaL_traceback(lua_State *L, lua_State *L1, const(char) *msg, int level);

void luaL_requiref(lua_State *L, const(char) *modname, lua_CFunction openf, int glb);

/*
** ===============================================================
** some useful macros
** ===============================================================


#define luaL_newlibtable(L,l)	\
  lua_createtable(L, 0, sizeof(l)/sizeof((l)[0]) - 1)
*/

void   lua_libtable(lua_State *L, int narr, int nrec);
}

//#define luaL_newlib(L,l)	(luaL_newlibtable(L,l), luaL_setfuncs(L,l,0))

/*
#define luaL_argcheck(L, cond,numarg,extramsg)	\
		((void)((cond) || luaL_argerror(L, (numarg), (extramsg))))
#define luaL_checkstring(L,n)	(luaL_checklstring(L, (n), NULL))
#define luaL_optstring(L,n,d)	(luaL_optlstring(L, (n), (d), NULL))
#define luaL_checkint(L,n)	((int)luaL_checkinteger(L, (n)))
#define luaL_optint(L,n,d)	((int)luaL_optinteger(L, (n), (d)))
#define luaL_checklong(L,n)	((long)luaL_checkinteger(L, (n)))
#define luaL_optlong(L,n,d)	((long)luaL_optinteger(L, (n), (d)))

#define luaL_typename(L,i)	lua_typename(L, lua_type(L,(i)))

#define luaL_dofile(L, fn) \
	(luaL_loadfile(L, fn) || lua_pcall(L, 0, LUA_MULTRET, 0))

#define luaL_dostring(L, s) \
	(luaL_loadstring(L, s) || lua_pcall(L, 0, LUA_MULTRET, 0))

#define luaL_getmetatable(L,n)	(lua_getfield(L, LUA_REGISTRYINDEX, (n)))

#define luaL_opt(L,f,n,d)	(lua_isnoneornil(L,(n)) ? (d) : f(L,(n)))

#define luaL_loadbuffer(L,s,sz,n)	luaL_loadbufferx(L,s,sz,n,NULL)
*/

//C	 #define luaL_argcheck(L, cond,numarg,extramsg)			((void)((cond) || luaL_argerror(L, (numarg), (extramsg))))
void luaL_argcheck(lua_State* L, int cond, int numarg, const(char)* extramsg) { if (!cond) luaL_argerror(L, numarg, extramsg); }
//C	 #define luaL_checkstring(L,n)	(luaL_checklstring(L, (n), NULL))
const(char)* luaL_checkstring(lua_State* L, int n) { return luaL_checklstring(L, n, null); }
//C	 #define luaL_optstring(L,n,d)	(luaL_optlstring(L, (n), (d), NULL))
const(char)* luaL_optstring(lua_State* L, int n, const(char)* d) { return luaL_optlstring(L, n, d, null); }
//C	 #define luaL_checkint(L,n)	((int)luaL_checkinteger(L, (n)))
int luaL_checkint(lua_State* L, int n) { return cast(int) luaL_checkinteger(L, n); }
//C	 #define luaL_optint(L,n,d)	((int)luaL_optinteger(L, (n), (d)))
int luaL_optint (lua_State* L, int n, int d) { return cast(int) luaL_optinteger(L, n, d); }
//C	 #define luaL_checklong(L,n)	((long)luaL_checkinteger(L, (n)))
long luaL_checklong(lua_State* L, int n) { return cast(long)luaL_checkinteger(L, n); }
//C	 #define luaL_optlong(L,n,d)	((long)luaL_optinteger(L, (n), (d)))
long luaL_optlong(lua_State* L, int n, int d) { return cast(long)luaL_optinteger(L, n, d); }

//C	 #define luaL_typename(L,i)	lua_typename(L, lua_type(L,(i)))
const(char)* luaL_typename(lua_State* L, int i) { return lua_typename(L, lua_type(L, i)); }

//C	 #define luaL_dofile(L, fn) 	(luaL_loadfile(L, fn) || lua_pcall(L, 0, LUA_MULTRET, 0))
int luaL_dofile(lua_State* L, const(char)* fn) { return luaL_loadfile(L, fn) || lua_pcall(L, 0, LUA_MULTRET, 0); }

//C	 #define luaL_dostring(L, s) 	(luaL_loadstring(L, s) || lua_pcall(L, 0, LUA_MULTRET, 0))
int luaL_dostring(lua_State*L, const(char)* s) { return luaL_loadstring(L, s) || lua_pcall(L, 0, LUA_MULTRET, 0); }

//C	 #define luaL_getmetatable(L,n)	(lua_getfield(L, LUA_REGISTRYINDEX, (n)))
void luaL_getmetatable(lua_State* L, const(char)* s) { lua_getfield(L, LUA_REGISTRYINDEX, s); }

//C	 #define luaL_opt(L,f,n,d)	(lua_isnoneornil(L,(n)) ? (d) : f(L,(n)))
bool luaL_opt(lua_State* L, int function(lua_State*, int) f, int n, int d) { return luaL_opt(L, f, n, d); }


/*
** {======================================================
** Generic Buffer manipulation
** =======================================================
*/

struct luaL_Buffer {
  char *p;  /* buffer address */
  size_t size;  /* buffer size */
  size_t n;  /* number of characters in buffer */
  lua_State *L;
  char[LUAL_BUFFERSIZE] initb;  /* initial buffer */
}


/*
#define luaL_addchar(B,c) \
  ((void)((B)->n < (B)->size || luaL_prepbuffsize((B), 1)), \
   ((B)->b[(B)->n++] = (c)))*/
void luaL_addchar(luaL_Buffer* B, char c)
{
	if (B.p < B.initb.ptr + LUAL_BUFFERSIZE || (luaL_prepbuffer(B)))
	{
		*B.p = c;
		B.p++;
	}
}

char * luaL_prepbuffer(luaL_Buffer *B) {
	return luaL_prepbuffsize(B, LUAL_BUFFERSIZE);
}

extern(C) {
//#define luaL_addsize(B,s)	((B)->n += (s))
void luaL_addsize(luaL_Buffer* B, int n) { B.p += n; }

void luaL_buffinit(lua_State *L, luaL_Buffer *B);
char * luaL_prepbuffsize(luaL_Buffer *B, size_t sz);
void luaL_addlstring(luaL_Buffer *B, const(char) *s, size_t l);
void luaL_addstring(luaL_Buffer *B, const(char) *s);
void luaL_addvalue(luaL_Buffer *B);
void luaL_pushresult(luaL_Buffer *B);
void luaL_pushresultsize(luaL_Buffer *B, size_t sz);
char * luaL_buffinitsize(lua_State *L, luaL_Buffer *B, size_t sz);

//#define luaL_prepbuffer(B)	luaL_prepbuffsize(B, LUAL_BUFFERSIZE)

/* }====================================================== */



/*
** {======================================================
** File handles for IO library
** =======================================================
*/

/*
** A file handle is a userdata with metatable 'LUA_FILEHANDLE' and
** initial structure 'luaL_Stream' (it may contain other fields
** after that initial structure).
*/

//#define LUA_FILEHANDLE          "FILE*"


/+
struct luaL_Stream {
  FILE *f;  /* stream (NULL for incompletely created streams) */
  lua_CFunction closef;  /* to close stream (NULL for closed streams) */
}
+/

/* }====================================================== */



/* compatibility with old module system */
//#if defined(LUA_COMPAT_MODULE)

void luaL_pushmodule(lua_State *L, const(char)* modname,
                                   int sizehint);
void luaL_openlib(lua_State *L, const(char) *libname,
                                const luaL_Reg* l, int nup);
}

//#define luaL_register(L,n,l)	(luaL_openlib(L,(n),(l),0))
void luaL_register(lua_State* L, const(char)* n, const luaL_Reg* l) {
	luaL_openlib(L, n, l, 0);
}

//#endif


//#endif


