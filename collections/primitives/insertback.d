module primitives.insertback;

import std.range;
import std.traits;

interface InsertBack(E,MySelf) {
	MySelf insertBack(V)(V v) if(isForwardRange!V && ElementType!V == E) {
		foreach(it; v) {
			insertBackImpl(it);
		}
		return cast(MySelf)this;
	}

	MySelf insertBack(V)(V v) if(!isForwardRange!V && isImplicitlyConvertible!(V, E)) {
		insertBackImpl(v);
		return cast(MySelf)this;
	}

	void insertBackImpl(E e);
}
