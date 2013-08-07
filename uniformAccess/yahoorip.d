import std.stdio;
import std.string;
import std.conv;
import std.net.curl;
import std.csv;
import std.typecons;
import std.datetime;
import std.concurrency;

import core.thread;
import core.memory;
import core.sync.semaphore;

import sqliteabstraction;

alias Tuple!(
	string, "Symbol_Key",
	real, 	"Ask",
	real, 	"Bid",
	string, "LastTradeDay",
	string, "LastTradeTime",
	int, 	"Year_Key",
	int, 	"Month_Key",
	int, 	"Day_Key",
	int, 	"Hour_Key",
	int, 	"Min_Key",
	int, 	"Second_Key") EntryTuple;

alias Tuple!(
	string, "Symbol",
	string,	"Ask",
	string,	"Bid",
	string, "LastTradeDay",
	string, "LastTradeTime") EntryTupleSlice;

struct Entry {
	mixin(genProperties!EntryTuple);
}

real toFloat(string s) {
	if(s == "N/A") {
		return real.init;
	} else {
		return to!real(s);
	}
}

/*__gshared Semaphore mu;
__gshared Sqlite db;

shared static this() {
	mu = new Semaphore(1);
	db = Sqlite("yahoo.db");
}*/

char[] getEntries(string names) {
	string url = "http://finance.yahoo.com/d/quotes.csv?s=%s&f=sb2b3d1t1";
	string rUrl = url.format(names);
	try {
		auto y = get(rUrl);
		return y;
	} catch(Exception e) {
		return new char[0];
	}
}

void run(string names, int id) {
	immutable entrySize = 2000;
	Entry[] entries = new Entry[entrySize];
	size_t idx = 0;
	for(size_t i = 0; i < 100; ++i) {
		auto input = getEntries(names);
		if(input.length == 0) continue;
		//writeln(input);
		auto currentTime = Clock.currTime();

		foreach(it; csvReader!(EntryTupleSlice)(input)) {
			entries[idx].Symbol = it.Symbol;
			entries[idx].Ask = toFloat(it.Ask);
			entries[idx].Bid = toFloat(it.Bid);
			entries[idx].LastTradeDay = it.LastTradeDay;
			entries[idx].LastTradeTime = it.LastTradeTime;
			entries[idx].Year = currentTime.year();
			entries[idx].Month = currentTime.month();
			entries[idx].Day = currentTime.day();
			entries[idx].Hour = currentTime.hour();
			entries[idx].Min = currentTime.minute();
			entries[idx].Second = currentTime.second();
			++idx;
			if(idx == entrySize) {
				auto db = Sqlite("yahoo" ~ to!string(id) ~ ".db");
				writeln(id, " ", i);
				db.insert(entries[0..$]);
				GC.free(entries.ptr);
				GC.collect();
				GC.minimize();
				entries = new Entry[entrySize];
				idx = 0;
			}
		}
	}
	auto db = Sqlite("yahoo" ~ to!string(id) ~ ".db");
	db.insert(entries[0 .. idx]);
}

void main() {
	string[15000] names;
	size_t idx = 0;
	auto f = File("names.csv", "r");
	size_t cnt = 0;
	foreach(l; f.byLine()) {
		//writeln(l);
		foreach(r; csvReader!(
			Tuple!(
				string, // Number
				string, // Symbol
				string,	// Company
				string, // Sector
				string, // Industry
				string, // Country
				string, // Market Cap
				string, // P/E
				string, // Price
				string, // Change
				string 	// Volume
				
			)
				)(l)) {
			//writeln(r);
			names[idx] ~= r[1] ~ "+";
		}
		++cnt;
		if(cnt >= 200) { 
			++idx; 
			cnt = 0;
		}
	}
	foreach(ref name; names[0 .. idx]) {
		name = name[0 .. $-1];
	}

	f.close();

	writeln(names[0]);
	writeln(idx);

	//string url = "http://finviz.com/export.ashx?v=111&&o=ticker";
	//string url = "http://ichart.finance.yahoo.com/table.csv?s=GOOG&a=NaN&b=02&c=pr-2&g=d&ignore=.csv";
	//string url = "http://download.finance.yahoo.com/d/quotes.csv?s=%5EDJI+MSFT&f=sd1t1l1va2abc1ghk3ops7&e=.csv";


	foreach(pro, it; names[0 .. idx]) {
		spawn(&run, it, pro);
		writefln("%d %d", pro, idx);
		//run(it);
	}
}
