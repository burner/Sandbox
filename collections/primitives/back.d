module primitives.back;

interface Back(E) {
	ref inout(E) back() inout;
}
