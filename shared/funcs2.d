module funcs2;

import std.stdio;
import std.string;
import std.conv;

alias extern(C) int function() FooBar;

extern(C) string getSome2(FooBar fooBar) {
	int a = fooBar();
	assert(a == 1337);
	writeln(a);
	//return "GotSome2 " + to!string(a);
	return format("GotSome2 %d Args", a);
}

extern(C) string getSome() {
//	writeln(fooBar());
	return "GotSome2";
}

extern(C) int addFive(int z) {
	return z + 6;
}
