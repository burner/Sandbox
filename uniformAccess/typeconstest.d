module typeconstest;

import std.array;
import std.algorithm;
import std.stdio;
import std.typecons;
import std.traits;
import std.conv;
import std.string;

import etc.c.sqlite3;

pure bool isToExclude(string it) {
	auto exclude = ["parseSpecs", "FieldSpec", "fieldSpecs", "extractType",
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

struct MyStruct2 {
	mixin(genProperties!T2);
}

unittest {
	MyStruct ms;
	ms.FooBar = 1337;
	assert(ms.FooBar == 1337);
}

unittest {
	MyStruct2 ms;
	ms.FooBar = 1337;
	assert(ms.FooBar == 1337);
	ms.Bar = "Bar";
	assert(ms.Bar == "Bar");
}

alias Tuple!(int, "FooBar", float, "Args") T1;
alias Tuple!(int, "FooBar", float, "Args", string, "Fun", string, "Bar") T2;

string genRangeItemFillImpl(T)(string a) {
	if(!isToExclude(a)) {
		return 
			"\t\tcase " ~ a ~ ":\n" ~
			"\t\t\tstatic if(isIntegral!(" ~ T.stringof ~ "." ~ a ~ ")) {\n" ~
			"\t\t\t\tif(sqlite3_column_type(stmt, i) == SQLITE_INTEGER) {\n" ~
			"\t\t\t\t\tret." ~ a ~ " = sqlite3_column_int(stmt, i);\n" ~
			"\t\t\t\t}\n" ~
			"\t\t\t} else static if(isFloatingPoint!(" ~ T.stringof ~ "." ~ a ~ ")) {\n" ~
			"\t\t\t\tif(sqlite3_column_type(stmt, i) == SQLITE_DOUBLE) {\n" ~
			"\t\t\t\t\tret." ~ a ~ " = sqlite3_column_double(stmt, i);\n" ~
			"\t\t\t\t}\n" ~
			"\t\t\t} else static if(isSomeString!(" ~ T.stringof ~ "." ~ a ~ ")) {\n" ~
			"\t\t\t\tif(sqlite3_column_type(stmt, i) == SQLITE_TEXT) {\n" ~
			"\t\t\t\t\tret." ~ a ~ " = to!string(sqlite3_column_text(stmt, i));\n" ~
			"\t\t\t\t}\n" ~
			"\t\t\t}\n";
	}
	return "";
}

string genRangeItemFillImpl(T, B...)(string a, B b) {
	if(!isToExclude(a)) {
		return 
			"\t\tcase " ~ a ~ ":\n" ~
			"\t\t\tstatic if(isIntegral!(" ~ T.stringof ~ "." ~ a ~ ")) {\n" ~
			"\t\t\t\tif(sqlite3_column_type(stmt, i) == SQLITE_INTEGER) {\n" ~
			"\t\t\t\t\tret." ~ a ~ " = sqlite3_column_int(stmt, i);\n" ~
			"\t\t\t\t}\n" ~
			"\t\t\t} else static if(isFloatingPoint!(" ~ T.stringof ~ "." ~ a ~ ")) {\n" ~
			"\t\t\t\tif(sqlite3_column_type(stmt, i) == SQLITE_DOUBLE) {\n" ~
			"\t\t\t\t\tret." ~ a ~ " = sqlite3_column_double(stmt, i);\n" ~
			"\t\t\t\t}\n" ~
			"\t\t\t} else static if(isSomeString!(" ~ T.stringof ~ "." ~ a ~ ")) {\n" ~
			"\t\t\t\tif(sqlite3_column_type(stmt, i) == SQLITE_TEXT) {\n" ~
			"\t\t\t\t\tret." ~ a ~ " = to!string(sqlite3_column_text(stmt, i));\n" ~
			"\t\t\t\t}\n" ~
			"\t\t\t}\n" ~ genRangeItemFillImpl!(T)(b);
	}
	return genRangeItemFillImpl!(T)(b);
}

string genRangeItemFill(T)() {
	return T.stringof ~ " buildItem() {\n" ~
		"\t" ~ T.stringof ~ " ret;\n" ~
		"\tsize_t cc = sqlite3_column_count(stmt);\n" ~
		"\tfor(int i = 0; i < cc; ++i) {\n" ~
		"\t\tstring cn = to!string(sqlite3_column_name(stmt, i));\n"~
		"\t\tswitch(cn) {\n" ~
		genRangeItemFillImpl!(T)(
			__traits(allMembers, typeof(T.__someNameYouWontGuess))
		) ~ "\t\t}\n" ~
		"\t}\n\treturn ret;\n}\n";

}

pragma(msg, genRangeItemFill!(MyStruct)());

void main() {
	T1 t;
}
