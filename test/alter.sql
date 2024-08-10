

ALTER TABLE my_table
  ADD COLUMN val3 VARCHAR(100) NOT NULL;



ALTER TABLE my_table
  ADD val3 VARCHAR(100) NOT NULL;



ALTER TABLE my_table
  ADD val3 VARCHAR(100) NOT NULL FIRST;



ALTER TABLE my_table
  ADD val3 VARCHAR(100) NOT NULL AFTER val2;



ALTER TABLE my_table
  ALTER COLUMN val3 SET DEFAULT 'hi';



ALTER TABLE my_table
  ALTER COLUMN val3 DROP DEFAULT;



ALTER TABLE my_table
  ALTER COLUMN val3 TYPE VARCHAR(255);



ALTER TABLE my_table
  MODIFY COLUMN IF EXISTS val6 INT UNSIGNED NOT NULL AFTER val3;



ALTER TABLE my_table
  CHANGE COLUMN IF EXISTS val3 val4 INT UNSIGNED NOT NULL;



ALTER TABLE my_table
  ALTER val3 TYPE VARCHAR(255);



ALTER TABLE my_table
  ALTER COLUMN val3 DROP NOT NULL;



ALTER TABLE my_table
  DROP COLUMN val3;



ALTER TABLE my_table
  DROP val3;



ALTER TABLE my_table
  RENAME COLUMN val3 TO valthree;



ALTER TABLE my_table
  RENAME TO my_new_and_improved_table;



ALTER TABLE my_table
  SET SCHEMA new_schema;



ALTER TABLE my_table
  OWNER TO someone_else;



ALTER TABLE IF EXISTS my_table
  ADD COLUMN IF NOT EXISTS val4 DATE,
  ALTER COLUMN val5 DROP NOT NULL, -- comment, ignore me!
  DROP COLUMN IF EXISTS val8;



ALTER VIEW my_view
  OWNER TO someone_else;



ALTER VIEW IF EXISTS my_view
  RENAME TO my_other_view;



ALTER TABLE "Role" ADD CONSTRAINT "pkRole" PRIMARY KEY ("roleId");



ALTER TABLE "AccountRole" ADD CONSTRAINT "fkAccountRoleAccount"
FOREIGN KEY ("accountId") REFERENCES "Account" ("accountId") ON DELETE CASCADE;



RENAME TABLES IF EXISTS old_table NOWAIT TO backup_table,
  new_table TO old_table;



ALTER TABLE tab
  ADD col1 VARCHAR(255) NOT NULL DEFAULT('EMPTY'),
  col2 VARCHAR(255) NOT NULL DEFAULT('EMPTY');



ALTER SCHEMA sales RENAME TO mysales;



ALTER SCHEMA sales OWNER TO CURRENT_USER;



ALTER INDEX IF EXISTS myindex RENAME TO my_index

;



ALTER INDEX distributors SET (fillfactor = 75);
ALTER INDEX distributors SET TABLESPACE fasttablespace;
ALTER INDEX distributors RESET (fillfactor);



ALTER INDEX coord_idx ALTER COLUMN 3 SET STATISTICS 1000;



ALTER INDEX distributors SET (fillfactor = 75);
ALTER INDEX distributors SET TABLESPACE fasttablespace;
ALTER INDEX distributors RESET (fillfactor);



ALTER DATABASE hollywood RENAME TO bollywood;



ALTER DATABASE test SET enable_indexscan TO off;
ALTER DATABASE test SET enable_indexscan TO DEFAULT;
ALTER DATABASE test SET TABLESPACE fasttablespace;



ALTER DATABASE test RESET ALL;
ALTER DATABASE test RESET enable_indexscan;



ALTER DATABASE test OWNER TO me;



ALTER ROLE rapunzel RENAME TO snow_white;



ALTER ROLE chris VALID UNTIL 'May 4 12:00:00 2015 +1';
ALTER ROLE fred VALID UNTIL 'infinity';



ALTER ROLE fred IN DATABASE devel SET client_min_messages = DEBUG;
ALTER ROLE worker_bee SET maintenance_work_mem = 100000;



ALTER ROLE miriam CREATEROLE CREATEDB;
ALTER ROLE rapunzel SUPERUSER NOLOGIN CONNECTION LIMIT 69;



ALTER SEQUENCE serial RESTART WITH 105;



ALTER SEQUENCE IF EXISTS serial RENAME TO cereal;



ALTER SEQUENCE serial SET SCHEMA serious_schema;



ALTER SEQUENCE serial OWNER TO count_von_count;



ALTER SEQUENCE IF EXISTS serial
  AS BIGINT
  INCREMENT BY 2
  MINVALUE 3
  MAXVALUE NO MAXVALUE
  START WITH 11
  RESTART WITH 1111
  CACHE 100
  OWNED BY numbers.number_sequences
;



ALTER TABLE "AccountRole"
  ADD CONSTRAINT "fkAccountRoleAccount"
  FOREIGN KEY ("accountId")
    REFERENCES "Account" ("accountId")
    ON DELETE SET NULL
    ON UPDATE SET DEFAULT;



ALTER TABLE table_name
  ADD CONSTRAINT constraint_name UNIQUE (col1, col2, col3);



ALTER TABLE table_name
  ALTER COLUMN col1 SET STORAGE PLAIN;
ALTER TABLE table_name
  ALTER COLUMN col1 SET STORAGE EXTERNAL;
ALTER TABLE table_name
  ALTER COLUMN col1 SET STORAGE EXTENDED;
ALTER TABLE table_name
  ALTER COLUMN col1 SET STORAGE MAIN;
ALTER TABLE table_name
  ALTER COLUMN col1 SET STORAGE DEFAULT;



ALTER TABLE table_name
  ALTER COLUMN col1
    SET COMPRESSION lz4;



ALTER TABLE table_name
  ALTER COLUMN col1 SET STATISTICS 100;
