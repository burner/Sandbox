module primitives.emplaceback;

import std.range;
import std.traits;

interface EmplaceBack(E,MySelf) {
	MySelf emplaceBack(V)(V v) if(isForwardRange!V && ElementType!V == E) {
		foreach(it; v) {
			emplaceBackImpl(it);
		}
		return cast(MySelf)this;
	}

	MySelf emplaceBack(V)(V v) if(!isForwardRange!V && isImplicitlyConvertible!(V, E)) {
		emplaceBackImpl(v);
		return cast(MySelf)this;
	}

	void emplaceBackImpl(E e);
}
