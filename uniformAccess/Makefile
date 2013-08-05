all: sqliteabstraction.d sqlitetest.d
	rm testtable.db
	./makedb.sh
	dmd sqliteabstraction.d sqlitetest.d -unittest -debug -ofsqlitetest -L/usr/lib/libsqlite3.so -g
#dmd sqliteabstraction.d sqlitetest.d -ofsqlitetest -L/usr/lib/libsqlite3.so -O -release
	./sqlitetest
