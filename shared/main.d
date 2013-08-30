import std.stdio;
import std.exception;
import std.string;
import std.conv;

version (Windows) {
    import core.sys.windows.windows;

    alias LoadLibraryW loadLibrary;
    alias FreeLibrary unloadLibrary;
    alias GetProcAddress getProc;
    alias GetLastError lastError;
} else {
    version (Posix) { // Linux, Mac OS etc.
        import core.sys.posix.dlfcn;

        alias dlclose unloadLibrary;
        alias dlsym getProc;
        alias dlerror lastError;

        void * loadLibrary(const char* path, const int mode = RTLD_LAZY) {
            return dlopen(path, mode);
        }
    } else {
        static assert(false, "Unsupported OS version!");
    }
}

alias extern(C) string function() SFunc;
alias extern(C) string function(void*) S2Func;
alias extern(C) int function(int) IFunc;

int fooBar() {
	return 1337;
}

void main() {
	auto l = loadLibrary(toStringz("funcs.so"));
	//writeln(to!string(lastError()));
	//writeln(l);
	auto getSome = cast(SFunc)getProc(l,"getSome".ptr);
	//writeln(__LINE__, &getSome);
	writeln(getSome());
	auto plusFive = cast(IFunc)getProc(l,"addFive".ptr);
	int a = 10;
	writeln(plusFive(a));
	unloadLibrary(l);

	l = loadLibrary(toStringz("funcs2.so"));
	auto getSome2 = cast(S2Func)getProc(l,"getSome2".ptr);
	//writeln(__LINE__, &getSome);
	writeln(getSome2(cast(void*)&fooBar));
	unloadLibrary(l);
}
