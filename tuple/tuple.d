import std.stdio;

void func(T...)(T t) {
	static if(t.length > 0) {
		writeln(t.length, t);
		foreach(it; T)
			write(typeid(it));

		writeln();
		func(t[0 .. t.length-1]);
	}
}

void main() {
	func("hello", 99, "world", true, 3.1415);
}
