import std.stdio;
import std.array;
import std.string;
import std.conv;

struct Data {
	@("NotUA") float someother;
	@("UA") int interval;
	@("UA", "foo") int bar;
	@("UA", "wingdings", "Primary_Key") int key;
	@("UA", "Primary_Key") int zzz;
}

string[] extractPrimaryKeyNames(T)() {
	string[] ret;
	foreach(it;__traits(allMembers, Data)) {
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

string[2][] extractMemberNames(T)() {
	string[2][] ret;
	foreach(it;__traits(allMembers, Data)) {
		string[] tmp = extractMemberNamesImpl!(T,it)().split(" ");
		foreach(jt; tmp) {
			jt.strip();
		}
		if(tmp.length == 4 && tmp[0] == "UA" && tmp[1] != "Primary_Key") {
			ret ~= [tmp[1], it];
		}
		if(tmp.length == 3 && tmp[0] == "UA" && tmp[1] != "Primary_Key") {
			ret ~= [tmp[1], it];
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

pragma(msg, extractMemberNames!Data());

unittest {
	static assert(extractMemberNames!Data() == 
		[["interval", "interval"], ["foo", "bar"], ["wingdings", "key"]]
	);
}

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

struct Sqlite {

}

void main() {
}
