module uniformaccess;
import std.stdio;
import std.string;
import std.array;
import std.traits;
import std.conv;

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

class UniAccess {
	T getValue(T)() if(isIntegral!T) {
		return to!T(1337);
	}

	T getValue(T)() if(isFloatingPoint!T) {
		return to!T(1337.0);
	}

	T getValue(T)() if(isSomeString!T) {
		return to!T(1337.0);
	}
}

struct FooBar {
	string name;
	int age;
	float height;

	immutable(string[][]) uniformMappings = [
		["name"],
		["Age", "age"],
		["Tall", "height"]
	];
}

string genAssign(T)() {
	//assert(__ctfe);
	auto ret = appender!string();
	ret.put("\tswitch(name) {\n");
	foreach(it; T.uniformMappings) {
		assert(!it.empty);
		ret.put("\tcase \"");
		ret.put(it[0]);
		ret.put("\":\n");
		string theName = it.length == 2 ? it[1] : it[0];
		ret.put("\t\ttmp.");
		ret.put(theName);
		ret.put(
			format(" = ua.getValue!(typeof(%s.%s))(); break;\n",
				T.stringof, theName
			)
		);
	}

	ret.put("\tdefault: break;\n");
	ret.put("\t}\n");
	return ret.data();
}

unittest {
	FooBar tmp;
	immutable int assign = 1337;
	enum s = genAssign!FooBar;
	string name = "Age";

	UniAccess ua = new UniAccess();

	//pragma(msg,genAssign!FooBar());
	mixin(genAssign!FooBar());
	assert(tmp.age == assign);
}
