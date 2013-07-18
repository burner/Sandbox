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

class MyClass {
	mixin(genProperties!T1);
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
			"\t\tcase \"" ~ a ~ "\":\n" ~
			"\t\t\tstatic if(isIntegral!(typeof(" ~ T.stringof ~ 
				".__someNameYouWontGuess." ~ a ~ "))) {\n" ~
			"\t\t\t\tif(sqlite3_column_type(stmt, i) == SQLITE_INTEGER) {\n" ~
			"\t\t\t\t\tret." ~ a ~ " = sqlite3_column_int(stmt, i);\n" ~
			"\t\t\t\t}\n" ~
			"\t\t\t} else static if(isFloatingPoint!(typeof(" ~ T.stringof ~ 
				".__someNameYouWontGuess." ~ a ~ "))) {\n" ~
			"\t\t\t\tif(sqlite3_column_type(stmt, i) == SQLITE_FLOAT) {\n" ~
			"\t\t\t\t\tret." ~ a ~ " = sqlite3_column_double(stmt, i);\n" ~
			"\t\t\t\t}\n" ~
			"\t\t\t} else static if(isSomeString!(typeof(" ~ T.stringof ~ 
				".__someNameYouWontGuess." ~ a ~ "))) {\n" ~
			"\t\t\t\tif(sqlite3_column_type(stmt, i) == SQLITE3_TEXT) {\n" ~
			"\t\t\t\t\tret." ~ a ~ 
				" = to!string(sqlite3_column_text(stmt, i));\n" ~
			"\t\t\t\t}\n\t\t\t\tbreak;\n" ~
			"\t\t\t}\n";
	}
	return "";
}

string genRangeItemFillImpl(T, B...)(string a, B b) {
	if(!isToExclude(a)) {
		return 
			"\t\tcase \"" ~ a ~ "\":\n" ~
			"\t\t\tstatic if(isIntegral!(typeof(" ~ T.stringof ~ 
				".__someNameYouWontGuess." ~ a ~ "))) {\n" ~
			"\t\t\t\tif(sqlite3_column_type(stmt, i) == SQLITE_INTEGER) {\n" ~
			"\t\t\t\t\tret." ~ a ~ " = sqlite3_column_int(stmt, i);\n" ~
			"\t\t\t\t}\n" ~
			"\t\t\t} else static if(isFloatingPoint!(typeof(" ~ T.stringof ~ 
				".__someNameYouWontGuess." ~ a ~ "))) {\n" ~
			"\t\t\t\tif(sqlite3_column_type(stmt, i) == SQLITE_FLOAT) {\n" ~
			"\t\t\t\t\tret." ~ a ~ " = sqlite3_column_double(stmt, i);\n" ~
			"\t\t\t\t}\n" ~
			"\t\t\t} else static if(isSomeString!(typeof(" ~ T.stringof ~ 
				".__someNameYouWontGuess." ~ a ~ "))) {\n" ~
			"\t\t\t\tif(sqlite3_column_type(stmt, i) == SQLITE3_TEXT) {\n" ~
			"\t\t\t\t\tret." ~ a ~ 
				" = to!string(sqlite3_column_text(stmt, i));\n" ~
			"\t\t\t\t}\n" ~
			"\t\t\t}\n\t\t\tbreak;\n" ~ genRangeItemFillImpl!(T)(b);
	}
	return genRangeItemFillImpl!(T)(b);
}

string genRangeItemFill(T)() {
	return T.stringof ~ " buildItem() {\n" ~
		"\t" ~ T.stringof ~ " ret" 
			~ (is(T : Object) ? " = new " ~ T.stringof ~ "();\n" : ";\n") ~
		"\tsize_t cc = sqlite3_column_count(stmt);\n" ~
		"\tfor(int i = 0; i < cc; ++i) {\n" ~
		"\t\tstring cn = to!string(sqlite3_column_name(stmt, i));\n"~
		"\t\tswitch(cn) {\n" ~
		"\t\tdefault: break;\n" ~
		genRangeItemFillImpl!(T)(
			__traits(allMembers, typeof(T.__someNameYouWontGuess))
		) 
		~ "\t\t}\n" ~
		"\t}\n\treturn ret;\n}\n";

}

struct UniRange(T) {
	T currentItem;
	int sqlRsltCode;
	sqlite3_stmt* stmt;

	this(sqlite3_stmt* s, int rsc) {
		this.sqlRsltCode = rsc;
		this.stmt = s;
		if(sqlRsltCode == SQLITE_OK) {
			sqlRsltCode = sqlite3_step(stmt);
			if(sqlRsltCode == SQLITE_ROW) {
				buildItem();
			} else {
				sqlite3_finalize(stmt);
			}
		} else {
			sqlite3_finalize(stmt);
		}
	}

	~this() {
		sqlite3_finalize(stmt);
	}

	mixin(genRangeItemFill!(T));

	@property T front() {
		return this.currentItem;
	}

	@property bool empty() const pure nothrow {
		return sqlRsltCode == SQLITE_ERROR || sqlRsltCode == SQLITE_DONE;
	}

	@property void popFront() { 
		if(sqlRsltCode == SQLITE_ROW) {
			sqlRsltCode = sqlite3_step(stmt);
			if(sqlRsltCode == SQLITE_ROW && sqlRsltCode != SQLITE_ERROR 
					&& sqlRsltCode != SQLITE_DONE) {
				this.currentItem = buildItem();
			}
		} else {
			sqlite3_finalize(stmt);
		}
	}
}

struct Sqlite {
	private string dbName;
	sqlite3 *db;

	this(string dbn) { 
		this.dbName = dbn;
		int rc = sqlite3_open(toStringz(dbName), &db);
		if(rc) {
			throw new Error("Can't open database " 
				~ dbName ~ " because of " ~ to!string(sqlite3_errmsg(db))
			);
		}
	}

	~this() {
		sqlite3_close(db);
	}


	UniRange!(T) select(T,string tn = "")(string where = "") {
		string s = "SELECT * FROM " ~ (tn.empty ? T.stringof : tn) ~ " "
		~ (where.length == 0 ? "" : where) ~ ";";
		return makeIterator!(T)(s);
	}

	UniRange!(T) makeIterator(T)(string stmtStr) {
		sqlite3_stmt* stmt;
 		int rsltCode = sqlite3_prepare(db, toStringz(stmtStr), -1, 
			&stmt, null
		);
		if(rsltCode == SQLITE_ERROR) {
			throw new Exception("Select Statment:\"" ~
					stmtStr ~ "\" failed with error:\"" ~
					to!string(sqlite3_errmsg(db)) ~ "\"");
		}
		return UniRange!(T)(stmt, rsltCode);
	}

}

alias Tuple!(string, "Firstname", string, "Lastname", int, "Zip") PersonData;

struct Person {
	mixin(genProperties!PersonData);
}

void main() {
	T1 t;
	UniRange!MyClass r;

	Sqlite db = Sqlite("testtable.db");
	foreach(it; db.select!(Person)()) {
		writefln("%s %s %d", it.Firstname, it.Lastname, it.Zip);
	}
}
