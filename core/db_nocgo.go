//go:build !cgo

package core

import (
	"os"

	"github.com/pocketbase/dbx"
	_ "github.com/tursodatabase/libsql-client-go/libsql"
	_ "modernc.org/sqlite"
)

func connectDB(dbPath string) (*dbx.DB, error) {
	if os.Getenv("TURSO_DATABASE_URL") != "" {
		libsqlUrl := os.Getenv("TURSO_DATABASE_URL")
		token := os.Getenv("TURSO_AUTH_TOKEN")

		// log.Println(libsqlUrl + "?authToken=" + token)

		db, err := dbx.Open("libsql", libsqlUrl+"?authToken="+token)
		if err != nil {
			return nil, err
		}

		return db, nil
	} else {
		// Note: the busy_timeout pragma must be first because
		// the connection needs to be set to block on busy before WAL mode
		// is set in case it hasn't been already set by another connection.
		pragmas := "?_pragma=busy_timeout(10000)&_pragma=journal_mode(WAL)&_pragma=journal_size_limit(200000000)&_pragma=synchronous(NORMAL)&_pragma=foreign_keys(ON)&_pragma=temp_store(MEMORY)&_pragma=cache_size(-16000)"

		db, err := dbx.Open("sqlite", dbPath+pragmas)
		if err != nil {
			return nil, err
		}

		return db, nil
	}

}
