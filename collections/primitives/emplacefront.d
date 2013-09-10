module primitives.emplacefront;

import std.range;
import std.traits;

interface EmplaceFront(E,MySelf) {
	MySelf emplaceFront(V)(V v) if(isForwardRange!V && ElementType!V == E) {
		foreach(it; v) {
			emplaceFrontImpl(it);
		}
		return cast(MySelf)this;
	}

	MySelf emplaceFront(V)(V v) if(!isForwardRange!V && isImplicitlyConvertible!(V, E)) {
		emplaceFrontImpl(v);
		return cast(MySelf)this;
	}

	void emplaceFrontImpl(E e);
}
