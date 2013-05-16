module std.testing;

import core.exception;
import std.string;
import std.range;
import std.conv;
import std.traits;

void assertEquals(T,S, string f = __FILE__, int l = __LINE__)
		(T t, S s, string msg = "") {
	assertEqualImpl!(T,S,f,l)(t,s,msg);
}

void assertEquals(T,S, string f = __FILE__, int l = __LINE__,A...)
		(T t, S s, string msg, A a) {
	assertEqualImpl!(T,S,f,l)(t,s,msg);
}

void assertEqualImpl(T,S, string f = __FILE__, int l = __LINE__,A...)
		(T t, S s, string msg, A a) {
	static if(isInputRange!(T) && isInputRange!(S)) {
		size_t idx = 0;
		for(; !t.empty && !s.empty;) {
			auto tf = t.front;
			auto sf = s.front;
			t.popFront;
			s.popFront;

			if(tf != sf) {
				string nMsg = xformat(
					"at idx %u range values unequal first %s second %s" ~ msg,
					idx, tf, sf, a
				);
				version(unittest) {
					throw new Exception(nMsg, f, l);
				} else {
					throw new AssertError(nMsg, f, l);
				}
			}
			++idx;
		}
		if(t.empty != s.empty) {
			const string firstEmpty = t.empty ? "first" : "second";
			const string secondEmpty = !t.empty ? "first" : "second";
			string nMsg = xformat(
				"\"%s\" range was empty while \"%s\" range still had elements" ~ msg,
				firstEmpty, secondEmpty, a
			);
			version(unittest) {
				throw new Exception(nMsg, f, l);
			} else {
				throw new AssertError(nMsg, f, l);
			}
		}
	} else static if(isImplicitlyConvertible!(T,S)) {
		if(t != s) {
			string nMsg = xformat("%s != %s: " ~ msg, 
				to!string(t), to!string(s), a
			);
			version(unittest) {
				throw new Exception(nMsg, f, l);
			} else {
				throw new AssertError(nMsg, f, l);
			}
		}
	} else {
		const string error = xformat(
			"first type %s and second type %s were not comparable" ~ msg,
			to!string(T), to!string(S), a);
		static assert(false);
	}
}

unittest {
	bool hasThrown = false;
	try {
		assertEquals([10,3,2], [10,3]);
	} catch(Exception e) {
		hasThrown = true;
	}
	assert(hasThrown);
}

void main() {

}
