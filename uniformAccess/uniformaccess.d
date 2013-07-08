module uniformaccess;

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
