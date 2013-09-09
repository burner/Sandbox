module sequence.insertfront;

import std.range;
import std.traits;

interface InsertFront(E) {
	InsertFront(E) insertFront(V)(V v) if(isForwardRange!V && ElementType!V == E) {
		foreach(it; v) {
			insertFrontImpl(it);
		}
		return cast(R)this;
	}

	R insertFront(V)(V v) if(!isForwardRange!V && isImplicitlyConvertible!(V, E)) {
		insertFrontImpl(v);
		return cast(R)this;
	}

	void insertFrontImpl(E e);
}
