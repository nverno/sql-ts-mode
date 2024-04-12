INSERT INTO my_table
VALUES('foo','bar', 3);

INSERT INTO my_table AS x
VALUES('foo','bar', 3);

REPLACE INTO my_table (name, id, year)
VALUES ('foo', 123, '2020');

INSERT INTO my_table (a, b, c)
SELECT a, b, c
FROM my_other_table;

INSERT INTO my_table
VALUES('foo','bar', 3)
  RETURNING *;

INSERT INTO my_table
VALUES('foo','bar', 3)
  RETURNING id;

INSERT INTO my_table
VALUES('foo','bar', 3)
  RETURNING id, val1, val2;

INSERT INTO some_table
  (field)
VALUES
  ("String value"),
  ("String value");

INSERT INTO some_table
  SET field = "String does not get highlight in INSERT SET syntax";

INSERT INTO my_table
VALUES('foo','bar', 3)
ON CONFLICT DO NOTHING;

INSERT INTO my_table
VALUES('foo','bar', 3)
ON CONFLICT DO UPDATE SET dname = EXCLUDED.dname;

INSERT LOW_PRIORITY my_table
VALUES('foo','bar', 3);

INSERT DELAYED my_table
VALUES('foo','bar', 3);

INSERT HIGH_PRIORITY my_table
VALUES('foo','bar', 3);

INSERT IGNORE my_table
VALUES('foo','bar', 3);

INSERT OVERWRITE tab1
SELECT
  col1,
  col2
FROM
  (
    SELECT
      *
    FROM
      tab2
    WHERE
      key1 >= 'val'
  ) a1;

INSERT OVERWRITE tab1
PARTITION (key1 = 'val1', key2 = 'val2')
SELECT
  col1,
  col2
FROM
  (
    SELECT
      *
    FROM
      tab2
    WHERE
      key1 >= 'val'
  ) a1;

INSERT INTO some_table
  (field)
(SELECT "String value"
UNION
 SELECT "String value");
