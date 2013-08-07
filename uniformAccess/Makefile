all: sqliteabstraction.d sqlitetest.d
	./makeyahoo.sh
	#dmd sqliteabstraction.d sqlitetest.d -unittest -debug -ofsqlitetest -L/usr/lib/libsqlite3.so -g -w
	#dmd sqliteabstraction.d sqlitetest.d -ofsqlitetest -L/usr/lib/libsqlite3.so -O -release -noboundscheck -w
	dmd sqliteabstraction.d yahoorip.d -unittest -debug -ofyahoorip -L/usr/lib/libsqlite3.so -g -w -L/usr/lib/libcurl.so
	#dmd sqliteabstraction.d yahoorip.d -ofyahoorip -L/usr/lib/libsqlite3.so -w -L/usr/lib/libcurl.so -O -release -noboundscheck
	#./yahoorip
