import std.stdio;
import std.string;
import std.conv;
import std.net.curl;
import std.csv;
import std.typecons;
import std.datetime;

import core.thread;

import sqliteabstraction;

alias Tuple!(
	string, "Symbol",
	real, 	"Ask",
	real, 	"Bid",
	string, "LastTradeDay",
	string, "LastTradeTime",
	int, 	"Year",
	int, 	"Month",
	int, 	"Day",
	int, 	"Hour",
	int, 	"Min",
	int, 	"Second") EntryTuple;

struct Entry {
	mixin(genProperties!EntryTuple);
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
				string, 		// Number
				string, 	// Symbol
				string,	// Company
				string, 	// Sector
				string, 	// Industry
				string, 	// Country
				string, 		// Market Cap
				string, 		// P/E
				string, 		// Price
				string, 		// Change
				string 		// Volume
				
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

	writeln(names[0]);
	writeln(idx);

	auto db = Sqlite("yahoo.db");

	//string url = "http://finviz.com/export.ashx?v=111&&o=ticker";
	//string url = "http://ichart.finance.yahoo.com/table.csv?s=GOOG&a=NaN&b=02&c=pr-2&g=d&ignore=.csv";
	//string url = "http://download.finance.yahoo.com/d/quotes.csv?s=%5EDJI+MSFT&f=sd1t1l1va2abc1ghk3ops7&e=.csv";
	while(true) {
		auto currentTime = Clock.currTime();
		writeln(currentTime);

		foreach(it; names[0 .. idx]) {
			writeln(it);
			string url = "http://finance.yahoo.com/d/quotes.csv?s="~it~"&f=sb2b3d1t1";
			auto y = get(url);
			writeln(y);
		}
		Thread.sleep(dur!"seconds"(1));
	}
}
