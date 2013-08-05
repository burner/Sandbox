import sqliteabstraction;

import std.csv;
import std.typecons;
import std.stdio;

alias Tuple!(
	string, "Firstname_Key",
	string, "Lastname_Key",
	string, "Company",
	string, "Address",
	string, "County",
	string, "City",
	string, "State",
	int, 	"Zip",
	string, "PhoneWork",
	string, "PhonePrivat_Key",
	string, "Mail",
	string, "Www") PersonInformation;

//pragma(msg, prepareRemoveStatement!Person);

struct Person {
	mixin(genProperties!PersonInformation);
}

void main() {
	Sqlite db = Sqlite("testtable.db");
	Person toDel;
	auto f = File("50000.csv", "r");
	db.beginTransaction();
	foreach(l; f.byLine()) {
		foreach(person; csvReader!(Tuple!(string,string,string,string,
							string,string,string,int,string,
							string,string,string,string))(l)) {
			/*writefln("%s %s %s %s %s %s %s %s %s %s %s %s", person[0],
					person[1], person[2], person[3], person[4], person[5],
					person[6], person[7], person[8], person[9], person[10],
					person[11], person[12]);
			*/

			Person p;
			p.Firstname = person[0];
			p.Lastname = person[1];
			p.Company = person[2];
			p.Address = person[3];
			p.County = person[4];
			p.City = person[5];
			p.State = person[6];
			p.Zip = person[7];
			p.PhoneWork = person[8];
			p.PhonePrivat = person[9];
			p.Mail = person[10];
			p.Www = person[11];

			toDel = p;
			assert(p.Firstname == person[0]);
			assert(p.Lastname == person[1]);
			assert(p.Company == person[2]);
			assert(p.Address == person[3]);
			assert(p.County == person[4]);
			assert(p.City == person[5]);
			assert(p.State == person[6]);
			assert(p.Zip == person[7]);
			assert(p.PhoneWork == person[8]);
			assert(p.PhonePrivat == person[9]);
			assert(p.Mail == person[10]);
			assert(p.Www == person[11]);
			db.insertBlank(p);
		}
	}
	db.endTransaction();
	db.remove(toDel);
	writeln(toDel);

	auto range = db.select!Person();
	foreach(it; range) {
		writeln(it);
	}
}
