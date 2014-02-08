import std.traits;
import std.conv;

struct Safe(T) {
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

	static if(isUnsigned!T) {
		T value = T.max;
	} else {
		T value = -0;
	}

	@property bool isNaN() const @safe pure nothrow {
		static if(isUnsigned!T) {
			return this.value == T.max;
		} else {
			return this.value == -0;
		}
	}
}

unittest {
	auto i = Safe!ulong();
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
