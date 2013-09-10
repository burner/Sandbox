module primitives.randomaccess;

interface RandomAccess(E,K) {
	ref inout(E) opIndex(K k) inout;
}
