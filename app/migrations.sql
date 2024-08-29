	---
	FOREIGN KEY (collectionId) REFERENCES _collections (id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE UNIQUE INDEX IF NOT EXISTS _externalAuths_record_provider_idx ON _externalAuths (collectionId, recordId, provider);
CREATE UNIQUE INDEX IF NOT EXISTS _externalAuths_collection_provider_idx ON _externalAuths (collectionId, provider, providerId);

DROP TABLE users;
DROP TABLE _externalAuths;
DROP TABLE _params;
DROP TABLE _collections;
DROP TABLE _admins;

UPDATE _params
SET value = replace(value, '"authentikAuth":', '"oidcAuth":')
WHERE key = 'settings';

UPDATE _params
SET value = replace(value, '"oidcAuth":', '"authentikAuth":')
WHERE key = 'settings';

DELETE FROM _externalAuths
WHERE collectionId NOT IN (SELECT id FROM _collections);

CREATE TABLE IF NOT EXISTS _logs (
	id      TEXT PRIMARY KEY DEFAULT ('r'||lower(hex(randomblob(7)))) NOT NULL,
	level   INTEGER DEFAULT 0 NOT NULL,
	message TEXT DEFAULT "" NOT NULL,
	data    JSON DEFAULT "{}" NOT NULL,
	created TEXT DEFAULT (strftime('%Y-%m-%d %H:%M:%fZ')) NOT NULL,
	updated TEXT DEFAULT (strftime('%Y-%m-%d %H:%M:%fZ')) NOT NULL
);

CREATE INDEX _logs_level_idx ON _logs (level);
CREATE INDEX _logs_message_idx ON _logs (message);
CREATE INDEX _logs_created_hour_idx ON _logs (strftime('%Y-%m-%d %H:00:00', created));

DROP TABLE _logs;

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

CREATE INDEX _request_status_idx ON _requests (status);
CREATE INDEX _request_auth_idx ON _requests (auth);
CREATE INDEX _request_ip_idx ON _requests (ip);
CREATE INDEX _request_created_hour_idx ON _requests (strftime('%Y-%m-%d %H:00:00', created));

DELETE old_table FROM _requests AS old_table INNER JOIN _requests AS new_table ON old_table.id = new_table.id WHERE old_table.rowid > new_table.rowid;

DELETE FROM _requests
WHERE id NOT IN (SELECT id FROM _requests ORDER BY rowid DESC LIMIT 1);

CREATE UNIQUE INDEX IF NOT EXISTS _externalAuths_collection_provider_idx ON _externalAuths (collectionId, provider, providerId);
DROP INDEX IF EXISTS _externalAuths_provider_providerId_idx;

UPDATE _collections SET indexes = json_set(indexes, '$[0]', 'CREATE UNIQUE INDEX "idx_unique_"||T2.id on T1.name (T2.name)') FROM _collections AS T1 INNER JOIN T1.schema AS T2 WHERE json_type(T2.unique) = 'boolean' AND T2.unique = 1;

CREATE TABLE IF NOT EXISTS _logs (
	id      TEXT PRIMARY KEY DEFAULT ('r'||lower(hex(randomblob(7)))) NOT NULL,
	level   INTEGER DEFAULT 0 NOT NULL,
	message TEXT DEFAULT "" NOT NULL,
	data    JSON DEFAULT "{}" NOT NULL,
	created TEXT DEFAULT (strftime('%Y-%m-%d %H:%M:%fZ')) NOT NULL,
	updated TEXT DEFAULT (strftime('%Y-%m-%d %H:%M:%fZ')) NOT NULL
);

CREATE INDEX _logs_level_idx ON _logs (level);
CREATE INDEX _logs_message_idx ON _logs (message);
CREATE INDEX _logs_created_hour_idx ON _logs (strftime('%Y-%m-%d %H:00:00', created));

DROP TABLE _logs;

DROP TABLE _requests;

CREATE TABLE IF NOT EXISTS _logs (
	id      TEXT PRIMARY KEY DEFAULT ('r'||lower(hex(randomblob(7)))) NOT NULL,
	level   INTEGER DEFAULT 0 NOT NULL,
	message TEXT DEFAULT "" NOT NULL,
	data    JSON DEFAULT "{}" NOT NULL,
	created TEXT DEFAULT (strftime('%Y-%m-%d %H:%M:%fZ')) NOT NULL,
	updated TEXT DEFAULT (strftime('%Y-%m-%d %H:%M:%fZ')) NOT NULL
);

CREATE INDEX _logs_level_idx ON _logs (level);
CREATE INDEX _logs_message_idx ON _logs (message);
CREATE INDEX _logs_created_hour_idx ON _logs (strftime('%Y-%m-%d %H:00:00', created));

DROP TABLE _logs;

CREATE TABLE IF NOT EXISTS _requests (
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

CREATE INDEX _request_status_idx ON _requests (status);
CREATE INDEX _request_auth_idx ON _requests (auth);
CREATE INDEX _request_ip_idx ON _requests (ip);
CREATE INDEX _request_created_hour_idx ON _requests (strftime('%Y-%m-%d %H:00:00', created));

DELETE old_table FROM _requests AS old_table INNER JOIN _requests AS new_table ON old_table.id = new_table.id WHERE old_table.rowid > new_table.rowid;

DELETE FROM _requests
WHERE id NOT IN (SELECT id FROM _requests ORDER BY rowid DESC LIMIT 1);

DROP INDEX IF EXISTS _request_ip_idx;

ALTER TABLE _requests RENAME COLUMN ip TO remoteIp;

ALTER TABLE _requests ADD COLUMN userIp TEXT DEFAULT "127.0.0.1" NOT NULL;

CREATE INDEX _request_remote_ip_idx ON _requests (remoteIp);
CREATE INDEX _request_user_ip_idx ON _requests (userIp);

DROP INDEX IF EXISTS _request_remote_ip_idx;
DROP INDEX IF EXISTS _request_user_ip_idx;

ALTER TABLE _requests RENAME COLUMN remoteIp TO ip;

CREATE INDEX _request_ip_idx ON _requests (ip);

UPDATE _requests SET method=UPPER(method);

UPDATE _requests SET method=LOWER(method);

CREATE TABLE IF NOT EXISTS _logs (
	id      TEXT PRIMARY KEY DEFAULT ('r'||lower(hex(randomblob(7)))) NOT NULL,
	level   INTEGER DEFAULT 0 NOT NULL,
	message TEXT DEFAULT "" NOT NULL,
	data    JSON DEFAULT "{}" NOT NULL,
	created TEXT DEFAULT (strftime('%Y-%m-%d %H:%M:%fZ')) NOT NULL,
	updated TEXT DEFAULT (strftime('%Y-%m-%d %H:%M:%fZ')) NOT NULL
);

CREATE INDEX _logs_level_idx ON _logs (level);
CREATE INDEX _logs_message_idx ON _logs (message);
CREATE INDEX _logs_created_hour_idx ON _logs (strftime('%Y-%m-%d %H:00:00', created));

DROP TABLE _logs;

DROP TABLE _requests;

CREATE TABLE IF NOT EXISTS _logs (
	id      TEXT PRIMARY KEY DEFAULT ('r'||lower(hex(randomblob(7)))) NOT NULL,
	level   INTEGER DEFAULT 0 NOT NULL,
	message TEXT DEFAULT "" NOT NULL,
	data    JSON DEFAULT "{}" NOT NULL,
	created TEXT DEFAULT (strftime('%Y-%m-%d %H:%M:%fZ')) NOT NULL,
	updated TEXT DEFAULT (strftime('%Y-%m-%d %H:%M:%fZ')) NOT NULL
);

CREATE INDEX _logs_level_idx ON _logs (level);
CREATE INDEX _logs_message_idx ON _logs (message);
CREATE INDEX _logs_created_hour_idx ON _logs (strftime('%Y-%m-%d %H:00:00', created));

DROP TABLE _logs;

CREATE TABLE IF NOT EXISTS _requests (
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

CREATE INDEX _request_status_idx ON _requests (status);
CREATE INDEX _request_auth_idx ON _requests (auth);
CREATE INDEX _request_ip_idx ON _requests (ip);
CREATE INDEX _request_created_hour_idx ON _requests (strftime('%Y-%m-%d %H:00:00', created));
