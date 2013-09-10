module primitives.front;

interface Front(E) {
	ref inout(E) front() inout;
}
