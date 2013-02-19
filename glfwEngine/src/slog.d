module slog;

import std.string;
import std.stdio;

@trusted:
string cropFileName(string s) {
	auto idx = lastIndexOf(s, '/');
	if(idx != -1) {
		return s[idx+1 .. $];
	} else {
		return s;
	}
}

unittest {
	assert("crop" == cropFileName("hello/crop"), cropFileName("hello/crop"));
	assert("" == cropFileName("hello/"), cropFileName("hello/"));
}

version(NOLOG) {
	public void log(string File = __FILE__, int Line = __LINE__)(bool need) {
		return;
	}

	public void log(string File = __FILE__, int Line = __LINE__,T...)(bool need,
			string format, T t) {
		return;
	}

	public void log(string File = __FILE__, int Line = __LINE__)() {
		return;
	}

	public void log(string File = __FILE__, int Line = __LINE__, T...)
			(string format, T t) {
		return;
	}
} else {
	public void log(string File = __FILE__, int Line = __LINE__)(bool need) {
		if(!need) {
			return;
		}
		writefln("%s:%d ", cropFileName(File), Line);
	}
	
	public void log(string File = __FILE__, int Line = __LINE__,T...)
			(bool need, string format, T t) {
		if(!need) {
			return;
		}
		writefln("%s:%d ", cropFileName(File), Line);
		writefln(format, t);
	}

	public void log(string File = __FILE__, int Line = __LINE__)() {
		writefln("%s:%d ", cropFileName(File), Line);
	}
	
	public void log(string File = __FILE__, int Line = __LINE__, T...)
			(string format, T t) {
		writef("%s:%d ", cropFileName(File), Line);
		writefln(format, t);
	}
}

/*version(NOWARN) {
	public void warn(string File = __FILE__, int Line = __LINE__)(bool need) {
		return;
	}

	public void warn(string File = __FILE__, int Line = __LINE__)
			(bool need, string format, lazy ...) {
		return;
	}

	public void warn(string File = __FILE__, int Line = __LINE__)() {
		return;
	}

	public void warn(string File = __FILE__, int Line = __LINE__)
			(string format, ...) {
		return;
	}
} else {
	public void warn(string File = __FILE__, int Line = __LINE__)(bool need) {
		if(!need) {
			return;
		}
		writefln("%s:%d WARNING", cropFileName(File), Line);
	}

	public void warn(string File = __FILE__, int Line = __LINE__)
			(bool need, string format, lazy ...) {
		if(!need) {
			return;
		}
		writef("%s:%d WARN ", cropFileName(File), Line);
		writefln(format, _arguments, _argptr);
	}

	public void warn(string File = __FILE__, int Line = __LINE__)() {
		writefln("%s:%d WARN", cropFileName(File), Line);
	}

	public void warn(string File = __FILE__, int Line = __LINE__)
			(string format, ...) {
		writef("%s:%d WARN ", cropFileName(File), Line);
		writefln(format, _arguments, _argptr);
	}
}*/
