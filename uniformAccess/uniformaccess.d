module uniformaccess;
import std.stdio;
import std.string;
import std.array;
import std.typecons;
import std.traits;
import std.conv;
import std.csv;

struct Uni(T,immutable string n) {
	T value;
	string name = n;

	alias value this;
	void opAssign(T rhs) {
		this.value = rhs;
	}
}

unittest {
	Uni!(int,"intVar") i;
	i = 1337;
	assert(i == 1337);
	assert(i.name == "intVar");
}

struct FooBar {
	string name;
	float height;
	int age;

	immutable(string[][]) uniformMappings = [
		["name", "name"],
		["Age", "age"],
		["Tall", "height"]
	];
}

string genAssign(T,A...)(A a) {
	//assert(__ctfe);
	alias RepresentationTypeTuple!T R;
	auto ret = appender!string();
	ret.put("\tswitch(name) {\n");
	
	foreach(immutable(string[]) it; uniformMapping) {
		assert(!it.empty);
		ret.put("\tcase \"");
		ret.put(it[0]);
		ret.put("\":\n");
		//string theName = it[1];
		/*static if(it.length == 2) {	
			theName = it[1];
		} else {
			theName = it[0];
		}*/
		ret.put("\t\ttmp.");
		ret.put(it[1]);
		if(isIntegral!(R[__traits(getMember, T, it[1])])) {
			ret.put(" = sqlite3_column_int(stmt,i); break;\n");
		}
	}

	ret.put("\tdefault: break;\n");
	ret.put("\t}\n");
	return ret.data();
}
unittest {
	string[][] uniformMappings = [
		["name"],
		["Age", "age"],
		["Tall", "height"]
	];
	FooBar tmp;
	immutable int assign = 1337;
	//enum s = genAssign!FooBar;
	//string name = "Age";
	pragma(msg,genAssign!(FooBar)("name", "name", "Age", "age", "Tall", "height"));

	/*UniAccess!(FooBar) ua = new UniAccess!(FooBar)();

	mixin(genAssign!FooBar());
	assert(tmp.age == assign);*/
}

struct SqlUniform {
/*void buildObj() {
	int cc = sqlite3_column_count(stmt);
	auto tab = T::table();
	for(int i = 0; i < cc; ++i) {
		string name = sqlite3_column_name(stmt, i);
		mixin(genAssign!FooBar());
		for(auto cm : tab.column) {
			if(cn == cm.attrName) {
				switch(cm.attr->type) {
				case SQLITE_INTEGER: {
					long Integer = sqlite3_column_int(stmt,i);
					cm.attr->setInt(it, Integer);
					break;
				}
				case SQLITE_FLOAT: {
					double Float = sqlite3_column_double(stmt,i);
					cm.attr->setFloat(it, Float);
					break;
				}
				case SQLITE_BLOB: {
					const void* Void = sqlite3_column_blob(stmt,i);
					size_t len = sqlite3_column_bytes(stmt,i);
					cm.attr->setBlob(it, Void, len);
					break;
				}
				case SQLITE_TEXT: {
					const std::string& str = 
						reinterpret_cast<const char*>(
							sqlite3_column_text(stmt,i)
					);
					cm.attr->setString(it, str);
					break;
				}
				default: {
					std::stringstream typeStr;
					typeStr<<"No case for "<<cm.attr->type;
					throw std::logic_error(typeStr.str());
				}}
				break;
			}
		}
	}*/
}
