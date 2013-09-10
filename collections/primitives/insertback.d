module primitives.insertback;

import std.range;
import std.traits;

interface InsertBack(E,MySelf) {
	MySelf insertBack(V)(V v) if(isForwardRange!V && ElementType!V == E) {
		foreach(it; v) {
			insertBackImpl(it);
		}
		return returnThis();
	}

	MySelf insertBack(V)(V v) if(!isForwardRange!V && isImplicitlyConvertible!(V, E)) {
		insertBackImpl(v);
		return returnThis();
	}

	void insertBackImpl(E e);
}
