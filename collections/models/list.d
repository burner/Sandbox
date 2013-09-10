module models.list;

import primitives.front;
import primitives.back;
import primitives.insertfront;
import primitives.insertback;
import primitives.emplacefront;
import primitives.emplaceback;
import primitives.removefront;
import primitives.removeback;
import primitives.size;

interface List(E,MyType) :
	Size,
	Front!E, 				Back!E,
	InsertFront!(E,MyType),	InsertBack!(E,MyType),
	EmplaceFront!(E,MyType),EmplaceBack!(E,MyType),
	RemoveFront!(E,MyType), RemoveBack!(E,MyType) {
}
