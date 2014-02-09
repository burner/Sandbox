import std.traits;
import std.conv;
import std.functional : binaryFun;
import std.math : abs;
import std.stdio;

public bool isSafeOp(S,R, string op)(S s, R r) @safe pure nothrow {
	enum unsigned = isUnsigned!S;

	static if(op == "+") {
		static if(unsigned) {
		} else {
		}
	} else static if(op == "-") {
	} else static if(op == "/" || op == "%") {
		return r != 0;
	} else static if(op == "*") {
		return s > S.max / r;
	} else {
		return false;
	}
	assert(false);
}

public bool divIsSafe(T,S)(T t, S s) @safe pure nothrow {
	return s != 0;
}

alias divIsSafe modIsSafe;

unittest {
	assert(!divIsSafe!(int,long)(1,0));
	assert(divIsSafe!(int,long)(0,1));

	assert(!modIsSafe!(int,long)(1,0));
	assert(modIsSafe!(int,long)(0,1));
}

public bool mulIsSafe(T,S)(T t, S s) @safe pure nothrow {
	return s < T.max / t;
}

unittest {
	assert(mulIsSafe!(char,char)(1,127));
	assert(!mulIsSafe!(char,char)(2,127));
	assert(!mulIsSafe!(char,char)(2,68));
	assert(!mulIsSafe!(char,char)(4,127));
}

public bool addIsSafe(T,S)(T t, S s) @safe pure nothrow {
	enum tUnsigned = isUnsigned!T;
	enum sUnsigned = isUnsigned!S;

	static if(tUnsigned) {
		static if(sUnsigned) { // unsigned unsigned
			return (T.max - t) >= s;
		} else { // unsigned signed
			if(s <= 0) {
				return t < abs(s);
			} else {
				return (T.max - t) >= s;
			}
		}
	} else {
		static if(sUnsigned) { // signed unsigned
			return (T.max - t) >= s;
		} else { // signed signed
			if(t >= 0) { 
				if(s >= 0) { // positiv positiv 
					return (T.max - t) >= s;
				} else { // positiv negativ
					return true;
				}
			} else {
				if(s >= 0) { // negativ positiv
					return true;
				} else { // negativ negativ
					return T.min - t > s;
				}
			}
		}
	}
	assert(false);
}

struct Safe(T) {
	// Construction
	static opCall(S)(S value) @safe pure {
		Safe!T ret;
		ret.value = to!T(value);
		static if(isUnsigned!T) {
			if(ret.value == T.max) {
				throw new Exception("passed Safe.NaN as value");
			}
		} else if(isSigned!T) {
			if(ret.value == 0) {
			} else if(ret.value == -0) {
				throw new Exception("passed Safe.NaN as value");
			}
		}

		return ret;
	}

	static opCall() @safe pure nothrow {
		Safe!T ret;
		static if(isUnsigned!T) {
			ret.value = T.max;
		} else {
			ret.value = -0;
		}
		
		return ret;
	}

	// value and init
	static if(isUnsigned!T) {
		T value = T.max;
	} else {
		T value = -0;
	}

	alias value this;

	@property bool isNaN() const @safe pure nothrow {
		static if(isUnsigned!T) {
			return this.value == T.max;
		} else {
			return this.value == -0;
		}
	}

	Safe!T opAssign(S)(const S t) @safe pure nothrow if(!is(S : Safe!Z, Z)) {
		try {
			this.value = to!T(t);
		} catch(Exception) {
			static if(isUnsigned!T) {
				this.value = T.max;
			} else {
				this.value = -0;
			}
		}

		return this;
	}

	Safe!T opAssign(S)(const S t) @safe pure nothrow if(is(S : Safe!Z, Z)) {
		if(t.isNaN) {
			static if(isUnsigned!T) {
				this.value = T.max;
			} else {
				this.value = -0;
			}
		} else {
			try {
				this.value = to!T(t.value);
			} catch(Exception) {
				static if(isUnsigned!T) {
					this.value = T.max;
				} else {
					this.value = -0;
				}
			}
		}

		return this;
	}

	Safe!T opBinary(string op, S)(const S s) @safe pure nothrow 
			if(is(S : Safe!Z, Z)) {
		if(this.isNaN || s.isNaN) {
			return Safe!T();
		} else {
			alias binaryFun!("a"~op~"b") Operation;
			T retValue = Operation(this.value, s.value);

			return Safe!T(retValue);
		}
	}
}

unittest {
	auto i = Safe!short();
	assert(i.isNaN);

	i = 1337;
	assert(!i.isNaN);
	assert(i == 1337);
}

unittest {
	Safe!ulong ul;
	assert(ul.isNaN);
	Safe!long l;
	assert(l.isNaN);
}

unittest {
	auto i = Safe!int(5);
	i = Safe!int(0);
}
