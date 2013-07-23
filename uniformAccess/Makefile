all:
#./makedb.sh
	dmd sqliteabstraction.d sqlitetest.d -unittest -debug -ofsqlitetest -L/usr/lib/libsqlite3.so 
	./sqlitetest
