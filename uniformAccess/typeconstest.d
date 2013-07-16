module typeconstest;

import std.array;
import std.algorithm;
import std.stdio;
import std.typecons;
import std.traits;
import std.conv;
import std.string;

pure bool isToExclude(string it) {
	auto exclude = [ "parseSpecs", "FieldSpec", "fieldSpecs", "extractType",
		"extractName", "injectNamedFields", "sliceSpecs", "expandSpec",
		"isCompatibleTuples", "Types", "expand", "field", "at", "__ctor", 
		"opEquals", "opCmp", "opAssign", "_workaround4424", "slice",
		"length", "toString"];

	foreach(jt; exclude) {
		if(it == jt || it[0] == '_') {
			return true;
		}
	}
	return false;
}

unittest {
	static assert(isToExclude("parseSpecs"));
}

string makeName(T, string n)() {
	return format("%s.%s", T.stringof, n);
}

unittest {
	static assert(makeName!(T1, "Args")() == "Tuple!(int, \"FooBar\", float, \"Args\").Args");
}

string genProImpl(T)(string a) {
	if(!isToExclude(a)) {
		return format("public @property auto %s() { \n\treturn " ~
				"__someNameYouWontGuess.%s; \n}\n\n", a, a)
			~ format("public @property void %s(typeof(%s.%s) n) {\n" ~
				"__someNameYouWontGuess.%s = n;\n}\n\n", a, T.stringof, a, a, a
				);
	}
	return "";
}

string genProImpl(T, B...)(string a, B b) {
	if(!isToExclude(a)) {
		return format("public @property auto %s() { \n\treturn " ~
				"__someNameYouWontGuess.%s; \n}\n\n", a, a)
			~ format("public @property void %s(typeof(%s.%s) n) {\n" ~
				"\t__someNameYouWontGuess.%s = n;\n}\n\n", a, T.stringof, a, a) 
				~ genProImpl!(T)(b);
	}

	return genProImpl!(T)(b);
}

string genProperties(T)() {
	return T.stringof ~ " __someNameYouWontGuess;\n"
		~ genProImpl!(T)(__traits(allMembers, T));
}

struct MyStruct {
	mixin(genProperties!T1);
}

unittest {
	MyStruct ms;
	ms.FooBar = 1337;
	assert(ms.FooBar == 1337);
}

alias Tuple!(int, "FooBar", float, "Args") T1;
alias Tuple!() T2;

void main() {
	T1 t;
}
