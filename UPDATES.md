added libsql
check to see if turso url has been added
url works ith both cgo and non-cgo
added "IF NOT EXISTS" to specific migrations (cannot fix migrations at the moment)
need to run "turso db create [db_name] --from-file ./pb_data/data.db (blank db with migrations applied)
still, one table is created and removed, so manually had to run
```sql

CREATE TABLE _requests (
	id        TEXT PRIMARY KEY NOT NULL,
	url       TEXT DEFAULT "" NOT NULL,
	method    TEXT DEFAULT "get" NOT NULL,
	status    INTEGER DEFAULT 200 NOT NULL,
	auth      TEXT DEFAULT "guest" NOT NULL,
	ip        TEXT DEFAULT "127.0.0.1" NOT NULL,
	referer   TEXT DEFAULT "" NOT NULL,
	userAgent TEXT DEFAULT "" NOT NULL,
	meta      JSON DEFAULT "{}" NOT NULL,
	created   TEXT DEFAULT (strftime('%Y-%m-%d %H:%M:%fZ')) NOT NULL,
	updated   TEXT DEFAULT (strftime('%Y-%m-%d %H:%M:%fZ')) NOT NULL
);
```
created sql file for all migrations
