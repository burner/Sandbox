module sqliteabstraction;

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
	static assert(makeName!(T1, "Args")() == 
		"Tuple!(int, \"FooBar\", float, \"Args\").Args");
}

string genProImpl(T)(string a) {
	if(!isToExclude(a)) {
		return format("public @property auto %s() { \n\treturn " ~
				"__someNameYouWontGuess.%s; \n}\n\n", removeKeyPostFix(a), a)
			~ format("public @property void %s(typeof(%s.%s) n) {\n" ~
				"__someNameYouWontGuess.%s = n;\n}\n\n", removeKeyPostFix(a),
			   	T.stringof, a, a);
	}
	return "";
}

string genProImpl(T, B...)(string a, B b) {
	return genProImpl!(T)(a) ~ genProImpl!(T)(b);
}

string genProperties(T)() {
	return T.stringof ~ " __someNameYouWontGuess;\n"
		~ genProImpl!(T)(__traits(allMembers, T)) ~ "\n" ~
		"immutable(string) __keyFieldNames = " ~ 
		'\"' ~ genKeyNames!(T)(__traits(allMembers, T)) ~ "\";\n";
}

pure string genKeyNamesImpl(T)(string a) {
	int idx = findKeyPostFix(a);
	if(!isToExclude(a) && idx != -1) {
		return removeKeyPostFix(a);
	}
	return "";
}

pure string genKeyNamesImpl(T, B...)(string a, B b) {
	int idx = findKeyPostFix(a);
	if(!isToExclude(a) && idx != -1) {
		return "," ~ removeKeyPostFix(a) ~ genKeyNamesImpl!(T)(b);
	}
	return "" ~ genKeyNamesImpl!(T)(b);
}

pure string genKeyNames(T,B...)(B b) {
	string ret = genKeyNamesImpl!(T)(b);
	if(!ret.empty) {
		return ret[1 .. $];
	} else {
		return ret;
	}
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

pure int findKeyPostFix(string str) {
	immutable string key = "_Key";
	return cast(int)(str.length < 4 ? 
		- 1 : (str[$-4 .. $] == key) ? str.length -4 : -1);
}

alias Tuple!(string,string) RemoveStatement;

pure string genRemoveCodeImpl(T)(string a) {
	int idx = findKeyPostFix(a);
	string aK = removeKeyPostFix(a);
	if(!isToExclude(aK) && idx != -1) {
		return "\t\tstatic if(isIntegral!(typeof(T" ~ 
			".__someNameYouWontGuess." ~ a ~ "))) {\n" ~
		"\t\t\tsqlite3_bind_int(stmt, i++, t." ~ aK ~ ");\n" ~
		"\t\t} else static if(isFloatingPoint!(typeof(T" ~ 
			".__someNameYouWontGuess." ~ a ~ "))) {\n" ~
		"\t\t\tsqlite3_bind_double(stmt, i++, t." ~ aK ~ ");\n" ~
		"\t\t} else static if(isSomeString!(typeof(T" ~ 
			".__someNameYouWontGuess." ~ a ~ "))) {\n" ~
		"\t\t\tsqlite3_bind_text(stmt, i++, toStringz(t." ~ aK ~ "), to!int(t." ~ 
			 aK ~ ".length), SQLITE_STATIC);\n" ~
		"\t\t} else {\n"
		"\t\t\tstatic assert(false);\n\t\t}\n";
	}
	return "";
}

pure string genRemoveCodeImpl(T, B...)(string a, B b) {
	return genRemoveCodeImpl!(T)(a) ~ genRemoveCodeImpl!(T)(b);
}

pure string genRemoveCode(T)() {
	return genRemoveCodeImpl!(T)(
		__traits(allMembers, typeof(T.__someNameYouWontGuess))
	);
}

pure string removeKeyPostFix(string str) {
	immutable string key = "_Key";
	int idx = findKeyPostFix(str);
	if(idx != -1 && idx != 0) {
		return str[0 .. idx];	
	}
	return str;
}

unittest {
	immutable string foo = "Firstname_Key";
	static assert(removeKeyPostFix(foo) == "Firstname", removeKeyPostFix(foo));

	immutable string bar = "Key";
	assert(removeKeyPostFix(bar) == "Key", removeKeyPostFix(bar));
}

alias Tuple!(int, "FooBar", float, "Args") T1;
alias Tuple!(int, "FooBar", float, "Args", string, "Fun", string, "Bar") T2;

string genRangeItemFillImpl(T)(string a) {
	if(!isToExclude(a)) {
		return 
			"\t\tcase \"" ~ removeKeyPostFix(a) ~ "\":\n" ~
			"\t\t\tstatic if(isIntegral!(typeof(T" ~ 
				".__someNameYouWontGuess." ~ a ~ "))) {\n" ~
			"\t\t\t\tif(sqlite3_column_type(stmt, i) == SQLITE_INTEGER) {\n" ~
			"\t\t\t\t\tret." ~ removeKeyPostFix(a) ~ " = sqlite3_column_int(stmt, i);\n" ~
			"\t\t\t\t}\n" ~
			"\t\t\t} else static if(isFloatingPoint!(typeof(T" ~ 
				".__someNameYouWontGuess." ~ a ~ "))) {\n" ~
			"\t\t\t\tif(sqlite3_column_type(stmt, i) == SQLITE_FLOAT) {\n" ~
			"\t\t\t\t\tret." ~ removeKeyPostFix(a) ~ " = sqlite3_column_double(stmt, i);\n" ~
			"\t\t\t\t}\n" ~
			"\t\t\t} else static if(isSomeString!(typeof(T" ~ 
				".__someNameYouWontGuess." ~ a ~ "))) {\n" ~
			"\t\t\t\tif(sqlite3_column_type(stmt, i) == SQLITE3_TEXT) {\n" ~
			"\t\t\t\t\tret." ~ removeKeyPostFix(a) ~ 
				" = to!string(sqlite3_column_text(stmt, i));\n" ~
			"\t\t\t\t}\n\t\t\t\tbreak;\n" ~
			"\t\t\t}\n";
	}
	return "";
}

string genRangeItemFillImpl(T, B...)(string a, B b) {
	return genRangeItemFillImpl!(T)(a) ~ genRangeItemFillImpl!(T)(b);
}

string genRangeItemFill(T)() {
	return "T buildItem(T)() {\n" ~
		"\tT ret" 
			~ (is(T : Object) ? " = new T();\n" : ";\n") ~
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

pure string prepareInsertStatmentImpl(T)(ref size_t cnt, string a) {
	a = removeKeyPostFix(a);
	if(!isToExclude(a)) {
		++cnt;
		return a ~ ", ";
	}
	return "";
}

pure string prepareInsertStatmentImpl(T, B...)(ref size_t cnt, string a, B b) {
	a = removeKeyPostFix(a);
	if(!isToExclude(a)) {
		++cnt;
		return a ~ ", " ~ prepareInsertStatmentImpl!(T)(cnt, b);	
	}
	return prepareInsertStatmentImpl!(T)(cnt, b);
}

pure string prepareAddParameterImpl(T)(string a) {
	string aK = removeKeyPostFix(a);
	if(!isToExclude(a)) {
		return "\t\tstatic if(isIntegral!(typeof(T" ~ 
			".__someNameYouWontGuess." ~ a ~ "))) {\n" ~
		"\t\t\tsqlite3_bind_int(stmt, i++, t." ~ aK ~ ");\n" ~
		"\t\t} else static if(isFloatingPoint!(typeof(T" ~ 
			".__someNameYouWontGuess." ~ a ~ "))) {\n" ~
		"\t\t\tsqlite3_bind_double(stmt, i++, t." ~ aK ~ ");\n" ~
		"\t\t} else static if(isSomeString!(typeof(T" ~ 
			".__someNameYouWontGuess." ~ a ~ "))) {\n" ~
		"\t\t\tsqlite3_bind_text(stmt, i++, toStringz(t." ~ aK ~ "), to!int(t." ~ 
			 aK ~ ".length), SQLITE_STATIC);\n" ~
		"\t\t} else {\n"
		"\t\t\tstatic assert(false);\n\t\t}\n";
	}
	return "";
}

pure string prepareAddParameterImpl(T, B...)(string a, B b) {
	return prepareAddParameterImpl!(T)(a) ~ prepareAddParameterImpl!(T)(b);
}

pure string prepareAddParameter(T)() {
	return prepareAddParameterImpl!(T)(
		__traits(allMembers, typeof(T.__someNameYouWontGuess))
	);
}

RemoveStatement prepareRemoveStatement(T)() {
	size_t comma = T.__keyFieldNames.count(',');
	string ret = "DELETE FROM " ~ T.stringof ~ " WHERE ";
	auto sp = T.__keyFieldNames.split(",");
	bool loopRun = false;
	foreach(it; sp) {
		loopRun = true;
		ret ~= it ~ " = ? AND ";
	}
	ret = ret[0 .. loopRun ? $-4 : $] ~ ";";

	return RemoveStatement(ret, genRemoveCode!(T)());
}

//pragma(msg, prepareRemoveStatement!(MyStruct)());

alias Tuple!(size_t,string) InsertStatment;

pure InsertStatment prepareInsertStatment(T)() {
	size_t cnt = 0;
	string ret = "INSERT INTO " ~ T.stringof ~ "(";
	string values = prepareInsertStatmentImpl!(T)(cnt,
		__traits(allMembers, typeof(T.__someNameYouWontGuess))
	);
	ret ~= values[0 .. $-2] ~ ") Values(";
	for(size_t it = 1; it < cnt; ++it) {
		ret ~= "?,";
	}
	ret ~= "?);";
	return InsertStatment(cnt,ret);
}


unittest {
	enum ret = prepareInsertStatment!(MyStruct)();
	assert(ret[0] == 2);
	//writeln(ret[1]);

	enum param = prepareAddParameter!(MyStruct)();
	//writeln(param);
}

struct Sqlite {
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
					buildItem!T();
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
					this.currentItem = buildItem!T();
				}
			} else {
				sqlite3_finalize(stmt);
			}
		}
	
		pragma(msg, genRangeItemFill!T);
		mixin(genRangeItemFill!T);
	}
	private string dbName;
	sqlite3 *db;
	sqlite3_stmt* stmt;

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

	void beginTransaction() {
		char* errorMessage;
		sqlite3_exec(db, "BEGIN TRANSACTION", null, null, &errorMessage);
	}

	void endTransaction() {
		char* errorMessage;
		sqlite3_exec(db, "COMMIT TRANSACTION", null, null, &errorMessage);
		if(sqlite3_finalize(stmt) != SQLITE_OK) {
			throw new Error("failed with error:\"" ~
					to!string(sqlite3_errmsg(db)) ~ "\"");
		}
	}

	void insert(T)(ref T elem) {
		enum insertStatement = prepareInsertStatment!(T)();
		//pragma(msg, insertStatement[1]);
		insertImpl!(T)(insertStatement, elem, stmt);
		step(InsertStatment[1]);
	}

	void insert(R)(R r) if(isForwardRange!R) {
		beginTransaction();
		foreach(it; r) {
			insertBlank(it);
		}
		endTransaction();
	}

	void insertBlank(T)(ref T elem) {
		enum insertStatement = prepareInsertStatment!(T)();
		//pragma(msg, insertStatement[1]);
		insertImpl!(T)(insertStatement, elem, stmt);
		step(insertStatement[1]);
		sqlite3_reset(stmt);
	}

	void insertImpl(T)(InsertStatment insertStatement, ref T t, 
			ref sqlite3_stmt* stmt) {
		sqlite3_prepare_v2(db, toStringz(insertStatement[1]),
			to!int(insertStatement[1].length), &stmt, null
		);
		addParameter!(T)(t, stmt);
	}

	void addParameter(T)(ref T t, sqlite3_stmt* stmt) {
		int i = 0;
		//pragma(msg, prepareAddParameter!(T)());
		mixin(prepareAddParameter!(T)());
	}

	void remove(T)(ref T elem) {
		removeImpl!(T)(elem);
	}

	void removeImpl(T)(ref T t) {
		enum removeStmt = prepareRemoveStatement!(T)();
		int i = 0;
		sqlite3_prepare_v2(db, toStringz(removeStmt[0]),
			to!int(removeStmt[0].length), &stmt, null
		);
		mixin(removeStmt[1]);
		step(removeStmt[0]);
		
	}
	void step(string stmtStr) {
		if(sqlite3_step(stmt) != SQLITE_DONE) {
			throw new Error(stmtStr ~ " " ~
					to!string(sqlite3_errmsg(db)));
		}
	}

	static void checkForDeleteAndInsertDropExpr(string str) {
		if(std.string.indexOf(str, "drop", CaseSensitive.no) == -1 ||
				std.string.indexOf(str, "insert", CaseSensitive.no) == -1 ||
				std.string.indexOf(str, "remove", CaseSensitive.no) == -1) {
			throw new Error("Stmt must not contain non const operation");
		}
	}
}
