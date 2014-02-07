import std.traits;
import std.conv;

struct Safe(T) {
	static opCall(S)(S value) {
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

	static opCall() {
		Safe!T ret;
		static if(isUnsigned!T) {
			ret.value = T.max;
		} else {
			ret.value = -0;
		}
		
		return ret;
	}

	T value;
}

unittest {
	auto i = Safe!ulong();
}

unittest {
	auto i = Safe!int(5);
	i = Safe!int(0);
}
