module primitives.insertfront;

import std.range;
import std.traits;

interface InsertFront(E,MySelf) {
	MySelf insertFront(V)(V v) if(isForwardRange!V && ElementType!V == E) {
		foreach(it; v) {
			insertFrontImpl(it);
		}
		return cast(MySelf)this;
	}

	MySelf insertFront(V)(V v) if(!isForwardRange!V && isImplicitlyConvertible!(V, E)) {
		insertFrontImpl(v);
		return cast(MySelf)this;
	}

	void insertFrontImpl(E e);
}
