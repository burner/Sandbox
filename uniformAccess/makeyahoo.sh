#!/bin/sh

for i in {0..40}
do
	rm yahoo${i}.db
done

for i in {0..40}
do
	echo 'sqlite3 yahoo${i}.db "CREATE TABLE Entry(Symbol varchar, Ask float, Bid float, LastTradeDay varchar, LastTradeTime varchar, Year integer, Month integer, Day integer, Hour integer, Min integer, Second integer, PRIMARY KEY(Symbol, Year, Month, Day, Hour, Min, Second));"'
	sqlite3 yahoo${i}.db "CREATE TABLE Entry(Symbol varchar, Ask float, Bid float, LastTradeDay varchar, LastTradeTime varchar, Year integer, Month integer, Day integer, Hour integer, Min integer, Second integer, PRIMARY KEY(Symbol, Year, Month, Day, Hour, Min, Second));"
done
