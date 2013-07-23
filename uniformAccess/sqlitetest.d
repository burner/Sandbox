import sqliteabstraction;

import std.csv;
import std.typecons;
import std.stdio;

alias Tuple!(
	string, "Firstname",
	string, "Lastname",
	string, "Company",
	string, "Adress",
	string, "District",
	string, "City",
	string, "State",
	int, 	"Zip",
	string, "Phone",
	string, "Fax",
	string, "Email",
	string, "Www") PersonInformation;

struct Person {
	mixin(genProperties!PersonInformation);
}

void main() {
	Sqlite db = Sqlite("testtable.db");
	auto f = File("50000.csv", "r");
	foreach(l; f.byLine()) {
		foreach(person;
				csvReader!(Tuple!(string,string,string,string,
								string,string,string,int,string,
								string,string,string,string))(l)) {
			writefln("%s %s %s %s %s %s %s %s %s %s %s %s", person[0],
					person[1], person[2], person[3], person[4], person[5],
					person[6], person[7], person[8], person[9], person[10],
					person[11], person[12]);

			Person p;
			p.Firstname = person[0];
			p.Lastname = person[1];
			p.Company = person[2];
			p.Adress = person[3];
			p.District = person[4];
			p.City = person[5];
			p.State = person[6];
			p.Zip = person[7];
			p.Phone = person[8];
			p.Fax = person[9];
			p.Email = person[10];
			p.Www = person[11];

			assert(p.Firstname == person[0]);
			assert(p.Lastname == person[1]);
			assert(p.Company == person[2]);
			assert(p.Adress == person[3]);
			assert(p.District == person[4]);
			assert(p.City == person[5]);
			assert(p.State == person[6]);
			assert(p.Zip == person[7]);
			assert(p.Phone == person[8]);
			assert(p.Fax == person[9]);
			assert(p.Email == person[10]);
			assert(p.Www == person[11]);
			db.insert(p);
		}
	}
}
