import std.traits;
import std.typetuple;

/*template MemberPtr(T, string memberName) if (isInstanceMember!(T, memberName))
{
	enum MemberPtr =
		MemberPtr!(T, typeof(__traits(getMember, T, memberName)))(
			staticIndexOf!(memberName, __traits(allMembers, T)));
}*/

auto make(T,string memberName)() if (isInstanceMember!(T, memberName))
{
	return new MemberPtr!(T, typeof(__traits(getMember, T, memberName)))(
			staticIndexOf!(memberName, __traits(allMembers, T)));
}

class MemberPtr(T, TMember)
{
	size_t index = -1;

	this(size_t i) {
		index = i;
	}

	auto address(ref inout(T) o) inout
	{
		foreach (i, m; __traits(allMembers, T))
		{
			static if (isInstanceMember!(T, m, TMember))
			{
				// 'switch' might be faster
				// but the optimizer can worry about that instead :)
				if (this.index == i)
				{
					return &__traits(getMember, o, m);
				}
			}
		}
		static if (is(typeof(return)) /*has the return type been inferred yet?*/)
		{
			assert(0, "Invalid member pointer!");
		}
		else { return (inout(TMember)*).init; }
	}

	ref auto deref(ref inout(T) o) inout
	{
		static if (isSomeFunction!(ReturnType!(typeof(&this.address))))
		{
			return this.address(o);
		}
		else
		{
			return *this.address(o);
		}
	}

	ref auto get(inout(T) o) inout
	{
		return this.deref(o);
	}
}

private template isStaticFunction(T, string m)
{
	static if (
		__traits(compiles,
			__traits(isStaticFunction, __traits(getMember, T, m))))
	{
		 enum isStaticFunction =
		 	 __traits(isStaticFunction, __traits(getMember, T, m));
	}
	else { enum isStaticFunction = false; }
}

private template isInstanceMember(T, string m, TMember = void)
	if (hasMember!(T, m))
{
	enum isInstanceMember =
		!isStaticFunction!(T, m) &&
		(__traits(compiles, __traits(getMember, T, m).offsetof) ||
			isSomeFunction!(__traits(getMember, T, m))) &&
		(is(TMember == void) ||  /* optional */
			is(typeof(__traits(getMember, T.init, m)) : TMember));

}
unittest
{
	struct S
	{
		int m1;
		void m2() { }
		static __gshared int s1;
		static void s2() { }
	}
	static assert(isInstanceMember!(S, q{m1}));
	static assert(isInstanceMember!(S, q{m2}));
	static assert(!isInstanceMember!(S, q{s1}));
	static assert(!isInstanceMember!(S, q{s2}));
}

struct Foo { int x; }

void main() {
	const a = make!(Foo, q{x});   // shorthand
	pragma(msg, a.get(Foo(1)));  // 1
	
	MemberPtr!(Foo, int) b = make!(Foo, q{x});  // longhand
	auto f = Foo(2);
	b.deref(f) = 3;   // by reference, unlike 'get'
	assert(f.x == 3);
}
