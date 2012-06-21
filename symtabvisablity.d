import std.stdio;

int func() {
	int gunc(int z) {
		return z-2;
	}
	int g = 44;

	return gunc(g);

}

interface foo {
	bool topScope() const;
}

class bar : foo {
	bool topScope() const {
		return true;
	}
}

void main() {
	bar zz = new bar();
	writeln(zz.topScope());
	writeln(func());
}
