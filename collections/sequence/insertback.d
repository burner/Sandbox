module sequence.insertback;

import std.range;
import std.traits;

interface InsertBack(E) {
	auto insertBack(V, this R)(V v) if(isForwardRange!V && ElementType!V == E) {
		foreach(it; v) {
			insertBackImpl(it);
		}
		return returnThis();
	}

	auto insertBack(V)(V v, this R) if(!isForwardRange!V && isImplicitlyConvertible!(V, E)) {
		insertBackImpl(v);
		return returnThis();
	}

	auto returnThis();

	void insertBackImpl(E e);
}
