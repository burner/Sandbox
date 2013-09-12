import std.stdio;
import std.algorithm;
import std.exception;
import std.array;
import std.string;
import std.conv;
import std.traits;

import etc.c.sqlite3;

struct Data {
	@("NotUA") float someother;
	@("UA") int interval;
	@("UA", "foo") int bar;
	@("UA", "wingdings", "Primary_Key") int key;
	@("UA", "Primary_Key") int zzz;
}

@("UA", "SomeOtherTableName") struct Datas {
	@("NotUA") float someother;
	@("UA") int interval;
	@("UA", "foo") int bar;
	@("UA", "wingdings", "Primary_Key") int key;
	@("UA", "Primary_Key") int zzz;
}

/// Get Primary Key of Aggregation

string[] extractPrimaryKeyNames(T)() {
	string[] ret;
	foreach(it;__traits(allMembers, T)) {
		string[] tmp = extractPrimaryKeyNamesImpl!(T,it)().split(" ");
		foreach(jt; tmp) {
			jt.strip();
		}
		foreach(jt; tmp) {
			if(jt == "Primary_Key") {
				ret ~= it;
				break;
			}
		}
	}
	return ret;
}

string extractPrimaryKeyNamesImpl(T,string m)() {
	string ret;
	foreach(it; __traits(getAttributes, mixin(T.stringof ~ "." ~ m))) {
		ret ~= it ~ " ";
	}
	return ret;
}

unittest {
	static assert(extractPrimaryKeyNames!Data() == ["key", "zzz"]);
}

/// Get Tabelname the Aggregation maps

string getTableNameOfAggregation(T)() {
	string ret;
	foreach(it; __traits(getAttributes, T)) {
		ret ~= it ~ " ";
	}
	string[] tmp = ret.split(" ");
	foreach(it; tmp) {
		it.strip();
	}

	if(tmp.length == 3 && tmp[0] == "UA") {
		return tmp[1];
	} else {
		return T.stringof;
	}
}

unittest {
	static assert(getTableNameOfAggregation!Data() == "Data");
	static assert(getTableNameOfAggregation!Datas() == "SomeOtherTableName");
}

/// Get names of column the data member map

string[2][] extractMemberNames(T)() {
	string[2][] ret;
	foreach(it;__traits(allMembers, T)) {
		string[] tmp = extractMemberNamesImpl!(T,it)().split(" ");
		foreach(jt; tmp) {
			jt.strip();
		}
		if(tmp.length == 4 && tmp[0] == "UA" && tmp[1] != "Primary_Key") {
			ret ~= [tmp[1], it];
		} else if(tmp.length == 3 && tmp[0] == "UA" && tmp[1] != "Primary_Key") {
			ret ~= [tmp[1], it];
		} else if(tmp.length == 3 && tmp[0] == "UA" && tmp[1] == "Primary_Key") {
			ret ~= [it, it];
		} else if(tmp.length == 2 && tmp[0] == "UA") {
			ret ~= [it, it];
		}
	}
	return ret;
}

string extractMemberNamesImpl(T,string m)() {
	string ret;
	foreach(it; __traits(getAttributes, mixin(T.stringof ~ "." ~ m))) {
		ret ~= it ~ " ";
	}
	return ret;
}

unittest {
	static assert(extractMemberNames!Data() == 
		[["interval", "interval"], ["foo", "bar"], ["wingdings", "key"],
		["zzz", "zzz"]]
	);
}


/* Sqlite Part */

// insert

private pure string insertDataMember(string a) @safe nothrow {
	return
	"static if(is(typeof(T." ~  a ~ ") == long)) {" ~
		"sqlite3_bind_int64(stmt, i++, t." ~ a ~ ");" ~
	"} else static if(isIntegral!(typeof(T." ~  a ~ "))) {" ~
		"sqlite3_bind_int(stmt, i++, t." ~ a ~ ");" ~
	"} else static if(isFloatingPoint!(typeof(T." ~ a ~ "))) {" ~
		"sqlite3_bind_double(stmt, i++, t." ~ a ~ ");" ~
	"} else static if(isSomeString!(typeof(T." ~ a ~ "))) {" ~
		"sqlite3_bind_text(stmt, i++, toStringz(t." ~ a ~ "), to!int(t." ~ a ~ ".length), SQLITE_STATIC);" ~
	"} else {" ~
		"static assert(false);" ~
	"}";
}

private string genInsertStatement(T)() {
	string[2][] member = extractMemberNames!T();
	string tableName = getTableNameOfAggregation!T();

	string stmtStr = "INSERT INTO "~ tableName ~ "(";
	foreach(it; member) {
		stmtStr ~= it[0] ~ ",";
	}
	stmtStr = stmtStr[0 .. $-1] ~ ") Values(";
	foreach(it; member) {
		stmtStr ~= "?, ";
	}
	stmtStr = stmtStr[0 .. $-2] ~ ");";
	return stmtStr;
}

private string genInsertAddParameterMixinString(T)() {
	string[2][] member = extractMemberNames!T();
	string ret;
	
	foreach(it; member) {
		ret ~= insertDataMember(it[1]);
	}

	return ret;
}

// remove

private string tableNameOfKey(string[2][] hay, string nee) {
	foreach(it; hay) {
		if(it[1] == nee) {
			return it[0];
		}
	}
	assert(false, nee ~ to!string(hay));
}

private string memberNameOfKey(string[2][] hay, string nee) {
	foreach(it; hay) {
		if(it[1] == nee) {
			return it[1];
		}
	}
	assert(false, nee ~ to!string(hay));
}

private string genRemoveStatement(T)() {
	string[2][] member = extractMemberNames!T();
	string[] keys = extractPrimaryKeyNames!T();
	assert(!keys.empty);
	string ret = "DELETE FROM " ~ getTableNameOfAggregation!T() ~ " WHERE ";
	foreach(it; keys) {
		ret ~= tableNameOfKey(member, it) ~ "=? AND ";
	}
	ret = ret[0 .. $-4] ~ ";";
	return ret;
}

private string genRemoveParameterMixinString(T)() {
	string[] keys = extractPrimaryKeyNames!T();
	string ret;
	foreach(it; keys) {
		ret ~= insertDataMember(it);
	}
	return ret;
}

// update

bool isPrimaryKeyElement(string[] keys, string name) {
	foreach(it; keys) {
		if(it == name) {
			return true;
		}
	}
	return false;
}

private string genUpdateStatement(T)() {
	string[2][] member = extractMemberNames!T();
	string[] keys = extractPrimaryKeyNames!T();
	assert(!keys.empty);

	string ret = "UPDATE " ~ getTableNameOfAggregation!T() ~ " SET ";
	foreach(it; member) {
		if(!isPrimaryKeyElement(keys, it[1])) {
			ret~= it[1] ~ "=? ,";
		}
	}
	ret = ret[0 .. (!ret.empty ? $-2 : $)] ~ " Where ";
	foreach(it; keys) {
		ret ~= tableNameOfKey(member, it) ~ "=? AND ";
	}
	ret = ret[0 .. $-4] ~ ";";
	return ret;
}

private string genUpdateParameterMixinString(T)() {
	string[2][] member = extractMemberNames!T();
	string[] keys = extractPrimaryKeyNames!T();
	string ret;
	foreach(it; keys) {
		ret ~= insertDataMember(memberNameOfKey(member, it));
	}
	foreach(it; member) {
		if(!isPrimaryKeyElement(keys, it[1])) {
			ret ~= insertDataMember(it[1]);
		}
	}
	return ret;
}

//pragma(msg, genUpdateStatement!Data());
//pragma(msg, genUpdateParameterMixinString!Data());

// select

private pure string fillDataMember(string a, string dba) @safe nothrow {
	return 
	"case \"" ~ dba ~ "\":\n" ~
	"static if(is(typeof(T." ~ a ~ ") == long)) {" ~
		"if(sqlite3_column_type(stmt, i) == SQLITE_INTEGER) {" ~
			"ret." ~ a ~ " = sqlite3_column_int(stmt, i);" ~ 
		"}" ~
	"} else static if(isIntegral!(typeof(T." ~ a ~ "))) {" ~
		"if(sqlite3_column_type(stmt, i) == SQLITE_INTEGER) {" ~
			"ret." ~ a ~ " = sqlite3_column_int(stmt, i);" ~ 
		"}" ~
	"} else static if(isFloatingPoint!(typeof(T." ~ a ~ "))) {" ~
		"if(sqlite3_column_type(stmt, i) == SQLITE_FLOAT) {" ~
			"ret." ~ a ~ " = sqlite3_column_double(stmt, i);" ~ 
		"}" ~
	"} else static if(isSomeString!(typeof(T." ~ a ~ "))) {" ~
		"if(sqlite3_column_type(stmt, i) == SQLITE3_TEXT) {" ~
			"ret." ~ a ~ " = to!string(sqlite3_column_text(stmt, i));" ~
		"}" ~
	"}" ~
	"break;";
}

string genRangeItemFill(T)() {
	string ret = "T buildItem(T)() {" ~
		"T ret" ~ (is(T : Object) ? " = new T();" : ";") ~
		"size_t cc = sqlite3_column_count(stmt);" ~
		"for(int i = 0; i < cc; ++i) {" ~
		"string cn = to!string(sqlite3_column_name(stmt, i));"~
		"switch(cn) {" ~
		"default: break;";
	foreach(string[2] it; extractMemberNames!T()) {
		ret ~= fillDataMember(it[1], it[0]);
	}
	
	ret ~= "}}return ret;}";
	return ret;
}

// Sqlite object

struct Sqlite {
private:
	private string dbName;
	sqlite3 *db;
	bool dbOpen;
public:

	struct UniRange(T) {
	private:
		T currentItem;
		int sqlRsltCode;
		sqlite3_stmt* stmt;
		bool done;

	public:
		this(sqlite3_stmt* s, int rsltCode) {
			sqlRsltCode = rsltCode;
			stmt = s;
			if(sqlRsltCode == SQLITE_OK) {
				sqlRsltCode = sqlite3_step(stmt);
				if(sqlRsltCode == SQLITE_ROW) {
					this.currentItem = buildItem!T();
				} else {
					//writeln(sqlRsltCode);
					done = true;
					sqlite3_finalize(stmt);
				}
			} else {
				//writeln(sqlRsltCode);
				done = true;
				sqlite3_finalize(stmt);
			}
		}
	
		@property bool empty() const pure nothrow {
			return done;
		}

		@property T front() {
			return this.currentItem;
		}

		@property void popFront() { 
			sqlRsltCode = sqlite3_step(stmt);
			if(sqlRsltCode == SQLITE_ROW) {
				this.currentItem = buildItem!T();
			} else {
				done = true;
				sqlite3_finalize(stmt);
			}
		}

		mixin(genRangeItemFill!T());
	}

	this(string dbn) { 
		this.dbName = dbn;
		int errCode = sqlite3_open_v2(toStringz(dbName), &db, 
			SQLITE_OPEN_READWRITE, null
		);
		if(errCode != SQLITE_OK) {
			auto errmsg = sqlite3_errmsg(db);
			auto err = new Exception("Can't open database " 
				~ dbName ~ " because of " ~ to!string(errmsg)
			);
			throw err;
		}
		dbOpen = true;
	}

	~this() {
		if(dbOpen) {
			sqlite3_close(db);
		}
	}

	unittest {
		auto db1 = Sqlite("googleTable2.db");
		assertThrown(Sqlite("tableThatDoesNotExist.db"));
	}

	// Select

	UniRange!(T) select(T)(string where = "") {
		string tn = getTableNameOfAggregation!T();
		string s = "SELECT * FROM " ~ tn ~ 
			(where.length == 0 ? "" : " WHERE " ~
			 checkForDeleteAndInsertDropExpr(where)) ~ ";";
		//writeln(s);
		return makeIterator!(T)(s);
	}

	UniRange!(T) makeIterator(T)(string stmtStr) {
		sqlite3_stmt* stmt;
 		int rsltCode = sqlite3_prepare(db, toStringz(stmtStr), -1, 
			&stmt, null
		);
		if(rsltCode == SQLITE_ERROR) {
			throw new Exception("Select Statement:\"" ~
					stmtStr ~ "\" failed with error:\"" ~
					to!string(sqlite3_errmsg(db)) ~ "\"");
		} else if(rsltCode == SQLITE_OK) {
			return UniRange!(T)(stmt, rsltCode);
		} else {
			assert(false, to!string(sqlite3_errmsg(db)));
		}
	}

	// Insert

	void insert(T)(ref T t) {
		sqlite3_stmt* stmt;
		enum insertStmt = genInsertStatement!T();
		int errCode = sqlite3_prepare_v2(db, toStringz(insertStmt),
			to!int(insertStmt.length), &stmt, null
		);
		if(errCode != SQLITE_OK) {
			scope(exit) sqlite3_finalize(stmt);
			throw new Exception(insertStmt ~ " FAILED " ~
				to!string(sqlite3_errmsg(db))
			);
		}

		int i = 0;	
		mixin(genInsertAddParameterMixinString!T());
		if(sqlite3_step(stmt) != SQLITE_DONE) {
			scope(exit) sqlite3_finalize(stmt);
			throw new Exception(to!string(sqlite3_errmsg(db)) ~ " " ~
				insertStmt ~ " " ~ to!string(t)
			);
		}
		sqlite3_finalize(stmt);
	}

	// Remove
	void remove(T)(ref T t) {
		sqlite3_stmt* stmt;
		enum removeStmt = genRemoveStatement!T();
		int errCode = sqlite3_prepare_v2(db, toStringz(removeStmt),
			to!int(removeStmt.length), &stmt, null
		);
		if(errCode != SQLITE_OK) {
			scope(exit) sqlite3_finalize(stmt);
			throw new Exception(removeStmt ~ " FAILED " ~
				to!string(sqlite3_errmsg(db))
			);
		}
		int i = 0;
		mixin(genRemoveParameterMixinString!T());

		if(sqlite3_step(stmt) != SQLITE_DONE) {
			scope(exit) sqlite3_finalize(stmt);
			throw new Exception(to!string(sqlite3_errmsg(db)) ~ " " ~
				removeStmt ~ " " ~ to!string(t)
			);
		}
		sqlite3_finalize(stmt);
	}

	// Update
	void update(T)(ref T t) {
		sqlite3_stmt* stmt;
		enum updateStmt = genUpdateStatement!T();
		int errCode = sqlite3_prepare_v2(db, toStringz(updateStmt),
			to!int(updateStmt.length), &stmt, null
		);
		if(errCode != SQLITE_OK) {
			scope(exit) sqlite3_finalize(stmt);
			throw new Exception(updateStmt ~ " FAILED " ~
				to!string(sqlite3_errmsg(db))
			);
		}
		int i = 0;
		mixin(genUpdateParameterMixinString!T());

		if(sqlite3_step(stmt) != SQLITE_DONE) {
			scope(exit) sqlite3_finalize(stmt);
			throw new Exception(to!string(sqlite3_errmsg(db)) ~ " " ~
				updateStmt ~ " " ~ to!string(t)
			);
		}
		sqlite3_finalize(stmt);
	}

	// Helper

	void step(sqlite3_stmt* stmt) {
		if(sqlite3_step(stmt) != SQLITE_DONE) {
			scope(exit) sqlite3_finalize(stmt);
			throw new Exception(to!string(sqlite3_errmsg(db)));
		}
	}

	void beginTransaction() {
		char* errorMessage;
		if(sqlite3_exec(db, "BEGIN TRANSACTION", null, null, &errorMessage) 
				!= SQLITE_OK) {
			scope(exit) sqlite3_free(errorMessage);
			throw new Exception("Begin Transaction failed with error " ~ 
				to!string(errorMessage));
		}
	}

	void endTransaction() {
		char* errorMessage;
		if(sqlite3_exec(db, "COMMIT TRANSACTION", null, null, &errorMessage)
				!= SQLITE_OK) {
			scope(exit) sqlite3_free(errorMessage);
			throw new Exception("Begin Transaction failed with error " ~ 
				to!string(errorMessage));
		}
	}

	static string checkForDeleteAndInsertDropExpr(string str) {
		if(std.string.indexOf(str, "drop", CaseSensitive.no) != -1 ||
				std.string.indexOf(str, "insert", CaseSensitive.no) != -1 ||
				std.string.indexOf(str, "remove", CaseSensitive.no) != -1) {
			throw new Error("Stmt must not contain non const operation");
		}
		return str;
	}
}

@("UA", "stocks") struct StockEntry {
	@("UA", "Symbol", "Primary_Key") 	string sym;
	@("UA", "Date", "Primary_Key") 		long date;
	@("UA", "Open") 					real open;
	@("UA", "Close") 					real close;
	@("UA", "High") 					real high;
	@("UA", "Low") 						real low;
	@("UA", "Volume") 					long volume;
}

void main() {
	auto db = Sqlite("googleTable2.db");
	//auto ran = db.select!StockEntry("Symbol = \"AAPL\"");
	auto ran = db.select!StockEntry();
	/*foreach(it; filter!(a => a.date > 1377892860 && a.open > 511.0)(ran)) {
		writeln(it);
	}*/
	StockEntry se;
	se.sym ="AAPL";
	se.date = 1377892880;
	se.open = 512.0;
	se.close = 514.0;
	se.high = 516.0;
	se.low = 518.0;
	se.volume = 1337;
	db.remove(se);
}
