

CREATE TABLE my_schema.my_table (id BIGINT NOT NULL PRIMARY KEY);



CREATE TABLE my_table (
  id BIGINT NOT NULL PRIMARY KEY,
  date DATE DEFAULT NULL ASC,
  date2 DATE DEFAULT NULL UNIQUE ASC
);



CREATE TEMP TABLE my_table (id BIGINT NOT NULL PRIMARY KEY);



CREATE TABLE my_table (
  host CHAR(50) NOT NULL,
  created_date DATE NOT NULL,
  CONSTRAINT pk PRIMARY KEY (host ASC, created_date DESC)
);



CREATE TABLE my_table (
  host CHAR(50) NOT NULL,
  created_date DATE NOT NULL,
  random FLOAT DEFAULT RAND(),
  random TEXT DEFAULT 'test',
  with_comment TEXT COMMENT 'this column has a comment',
  with_comment_and_constraint TEXT DEFAULT 'test' COMMENT 'this column also has a comment',
  KEY `idx` (`host`, `created_date`),
  UNIQUE KEY `unique_idx` (`host`,`with_comment`)
);



CREATE TABLE products (
  product_no integer,
  name text,
  price numeric CHECK (price > 0),
  discounted_price numeric CHECK (discounted_price > 0),
  CHECK (price > discounted_price)
);



CREATE TABLE IF NOT EXISTS `addresses` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT
);



CREATE TABLE `addresses` (
  `id` bigint(20) UNSIGNED ZEROFILL,
  `id2` int4(20) ZEROFILL,
  `id3` UNSIGNED tinyint(20),
  `id4` mediumint(20) UNSIGNED,
  `id5` float(20, 3) UNSIGNED,
  `id6` double(20,3) UNSIGNED
);



CREATE TABLE IF NOT EXISTS `addresses` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`),
  KEY `addresses_s_id_index` (`s_id`)
);



CREATE TABLE IF NOT EXISTS `addresses` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `s_id` bigint(20) DEFAULT NULL,
  `first_name` varchar(255) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `addresses_s_id_index` (`s_id`),
  KEY `index_addresses_on_updated_at` (`updated_at`),
  KEY `index_addresses_on_s_id_and_id` (`s_id`, `id`)
);



CREATE TABLE IF NOT EXISTS `addresses` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `s_id` bigint(20) DEFAULT NULL,
  `first_name` varchar(255) DEFAULT NULL
);



CREATE TABLE my_table (
  id BIGINT(20) NOT NULL,
  date DATE DEFAULT NULL ASC
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;



CREATE VIEW my_view AS
  SELECT * FROM my_table;



CREATE OR REPLACE VIEW my_view AS
  SELECT * FROM my_table;



CREATE TEMPORARY VIEW foo AS SELECT 1;
CREATE TEMP VIEW foo AS SELECT 1;



CREATE VIEW foo(a, b) AS SELECT 1 a, 2 b;



CREATE VIEW foo AS SELECT 1 WITH CHECK OPTION;
CREATE VIEW foo AS SELECT 1 WITH LOCAL CHECK OPTION;
CREATE VIEW foo AS SELECT 1 WITH CASCADED CHECK OPTION;



CREATE MATERIALIZED VIEW my_view AS
  SELECT * FROM my_table
  WITH NO DATA;



CREATE MATERIALIZED VIEW my_view AS
  SELECT * FROM my_table
  WITH NO DATA

;



CREATE TABLE type_test (
  a_bool BOOLEAN,
  a_bit BIT,
  a_bit2 BIT(2),
  a_bit3 BIT VARYING(2),
  a_binary BINARY,
  a_varbinary VARBINARY,
  a_image IMAGE,
  a_smallser SMALLSERIAL,
  a_serial SERIAL,
  a_bigser BIGSERIAL,
  an_int INT,
  an_integer INTEGER,
  a_bigint BIGINT,
  a_decimal DECIMAL,
  a_sized_decimal DECIMAL (8),
  a_sized_decimal_with_scale DECIMAL (8, 4),
  a_numeric NUMERIC,
  a_sized_numeric NUMERIC (8),
  a_sized_numeric_with_scale NUMERIC (8, 4),
  a_real REAL,
  a_double_precision DOUBLE PRECISION,
  a_money MONEY,
  a_smallmoney SMALLMONEY,
  a_char CHAR,
  a_nchar NCHAR,
  a_nchar_precision NCHAR(8),
  a_character CHARACTER,
  a_sized_char CHAR (10),
  a_varchar VARCHAR (10),
  a_nvarchar NVARCHAR,
  a_nvarchar_precision NVARCHAR (10),
  a_character_varying CHARACTER VARYING (10),
  a_text TEXT,
  a_json JSON,
  a_jsonb JSONB,
  an_xml XML,
  a_bytea BYTEA,
  a_enum ENUM('one','two','three'),
  a_date DATE,
  a_datetime DATETIME,
  a_datetime2 DATETIME2,
  a_datetimeoffset DATETIMEOFFSET,
  a_smalldatetime SMALLDATETIME,
  a_time TIME,
  a_timestamp TIMESTAMP,
  a_verbose_timestamp TIMESTAMP WITHOUT TIME ZONE,
  a_tstz TIMESTAMPTZ,
  a_date_with_default_ts DATETIME DEFAULT CURRENT_TIMESTAMP,
  a_verbose_tstz TIMESTAMP WITH TIME ZONE,
  a_geometry GEOMETRY,
  a_geography GEOGRAPHY,
  a_box2d BOX2D,
  a_box3d BOX3D,
  a_uuid UUID
);



CREATE TABLE tableName (
  id NUMERIC NULL,
  name VARCHAR NULL
);



CREATE UNLOGGED TABLE tableName (
  id NUMERIC
);



CREATE TABLE some_table(
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `s_id` bigint(20) DEFAULT NULL,
  INDEX `parent`(pid),
  INDEX `range`(publication, published_at)
) DEFAULT CHARACTER SET utf8mb4 COLLATE `utf8mb4_unicode_ci` ENGINE = InnoDB;



CREATE UNIQUE INDEX "akRoleName" ON "Role" ("name");



CREATE TABLE tableName AS SELECT * FROM otherTable;



CREATE TABLE tableName AS WITH _cte AS (
  SELECT a FROM b
)
 SELECT * FROM _cte

;



CREATE TABLE tb AS
  (
   SELECT 1 as col
  )
  UNION ALL
  (
   SELECT 2 as col
  );



CREATE VIEW tableName AS WITH _cte AS (
  SELECT a FROM b
)
 SELECT * FROM _cte

;



CREATE MATERIALIZED VIEW tableName AS WITH _cte AS (
  SELECT a FROM b
)
 SELECT * FROM _cte

;



CREATE EXTERNAL TABLE tab
  (col int, col2 string, col3 binary)
  PARTITIONED BY (col int)
  SORT BY (col)
  ROW FORMAT DELIMITED FIELDS TERMINATED BY ';' ESCAPED BY '"'
    LINES TERMINATED BY '\n'
  STORED AS PARQUET
  LOCATION '/path/data'
    CACHED IN 'pool1' WITH REPLICATION = 2

;



CREATE TABLE tab
  PARTITIONED BY (col1, col2)
  STORED AS PARQUET
  AS
  SELECT
    col1,
    col2,
    col3
   FROM tab2

;



CREATE TABLE "Role" (
  id BIGINT NOT NULL
);



CREATE TABLE "Role" (
  "roleId" bigint generated always as identity,
  "name" varchar NOT NULL,
  height_in numeric GENERATED ALWAYS AS (height_cm / 2.54) STORED,
  item_type_name TEXT GENERATED ALWAYS AS (
    CASE item_type
      WHEN 1 THEN 'foo'
      WHEN 2 THEN 'bar'
      ELSE 'UNKNOWN'
    END
  ) VIRTUAL
);



CREATE TABLE "Session" (
  "ip" inet NOT NULL
);



CREATE TABLE tab (
  name   text,
  array2 integer[3],
  matrix text[][],
  square integer[3][3],
  array4 integer ARRAY[4],
  array_ integer ARRAY,
  multid integer[3][3][3][3]
);



CREATE SCHEMA myschema;



CREATE SCHEMA IF NOT EXISTS test AUTHORIZATION joe;



CREATE SCHEMA hollywood
  CREATE TABLE films (title text, release date, awards text[])
  CREATE VIEW winners AS
    SELECT title, release FROM films WHERE awards IS NOT NULL;



CREATE DATABASE hollywood

;



CREATE DATABASE IF NOT EXISTS hollywood

;



CREATE DATABASE sales OWNER operations_dept;



CREATE ROLE rapunzel
  WITH ROLE hansel, gretel
  IN GROUP fairy, tale
  ADMIN grandma
  PASSWORD 'secret'
  VALID UNTIL '2022-01-01'
  CONNECTION LIMIT 42
  NOLOGIN
  INHERIT;



CREATE TEMP SEQUENCE IF NOT EXISTS serial
  AS BIGINT
  INCREMENT BY 3
  MINVALUE 10
  MAXVALUE 9999
  START 101 CACHE 1000 NO CYCLE
  OWNED BY numbers.number_sequences;



CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA public;



CREATE EXTENSION pg_stat_statements VERSION '12' CASCADE;



create view toto as select '123'::timestamp with check option;



CREATE TRIGGER update_at BEFORE DELETE ON public.table_A FOR EACH ROW EXECUTE FUNCTION public.update_timestamp();



CREATE TRIGGER update_at_user AFTER UPDATE OF name ON public."user" EXECUTE FUNCTION public.update_timestamp();



CREATE TABLE foo (
  bar int NOT NULL
    REFERENCES bar(foo)
    ON DELETE CASCADE
);
