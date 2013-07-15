module typeconstest;

import std.algorithm;
import std.stdio;
import std.typecons;
import std.traits;
import std.conv;

string genProperties(T)() {
	return "";
}

alias Tuple!(int, "FooBar", float, "Args") T1;
alias Tuple!() T2;

void main() {
	foreach(it; __traits(allMembers, T2)) {
		writeln(it);
	}
	writeln();
	T1 t;
	/*writeln(to!string(t));
	foreach(it; __traits(allMembers, T1)) {
		writeln(it);
	}*/
	//writeln(__traits(allMembers, T1));
	pragma(msg, T1.fieldSpecs);
	pragma(msg, T1.extractName);
	foreach(it; T1.fieldSpecs) {
		/*foreach(jt; it) {
			writeln(jt);
		}*/
		//writeln(it.name);
	}

	/*foreach(it; setDifference(__traits(allMembers, T1), 
				__traits(allMembers, Tuple!())
				)) {
		writeln(it);
	}*/
	foreach(i, name; t.expand) {
		writefln("%s %s", to!string(i), to!string(name));
	}
}
