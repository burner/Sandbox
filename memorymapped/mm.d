import std.mmfile;
import std.stdio;

void main() {
	const size_t K = 1024;
    size_t win = 64*K; // assume the page size is 64K
    MmFile mf = new MmFile("testing.txt",MmFile.Mode.readWriteNew,
            100*K,null,win);
	string str = "Hello World";
	void[] tmp = mf[0..str.length];
	tmp = cast(ubyte[])str;
	writefln("%s", cast(string)mf[0..str.length]);
	assert(str == mf[0..str.length]);
}
