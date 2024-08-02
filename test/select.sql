

SELECT 1;



SELECT 1 AS one,
  TRUE AS two,
  NULL AS three;



SELECT * FROM my_table;



SELECT * FROM ONLY my_table;



SELECT my_table.* FROM my_table;



SELECT t.* FROM my_table AS t;



SELECT id, name FROM my_table;



SELECT t.from_where, t.created_at, t.updated_at
FROM join_something_on AS where_this_like_that;



SELECT m.id, m.name
FROM my_table m;



SELECT "My Table".name as "My Name"
FROM my_table "My Table";



SELECT tab."COL" FROM tab;



SELECT id
FROM my_table
WHERE id = 4;



SELECT id
FROM my_table
WHERE id = "abc";



SELECT id
FROM my_table
WHERE id IN(1,2);



SELECT id
FROM my_table
WHERE id NOT IN(1,2);



SELECT id
FROM my_table
WHERE id NOT IN(1,2) AND id NOT IN (SELECT id FROM other_table);



SELECT IF(m.is_published, 'global', 'local') as published_scope
FROM my_table m;



SELECT m.is_published, IF(m.is_published > 4, 'global', 'local') published_scope
FROM my_table m;



SELECT DISTINCT id
FROM my_table;



SELECT COUNT(DISTINCT id) AS count
FROM my_table;



SELECT m.id AS m_id, m.a_id a_id
FROM my_table AS m;



SELECT id
FROM my_table
WHERE id > 4
ORDER BY id DESC;



SELECT id
FROM my_table
LIMIT 5;



SELECT id
FROM my_table
LIMIT 5
OFFSET 40;



SELECT * FROM my_schema.my_table;



SELECT
  my_schema.my_table.*
FROM
  my_schema.my_table;



SELECT
  my_schema.my_table.my_field
FROM
  my_schema.my_table;



SELECT DISTINCT(id)
FROM my_table;



SELECT DISTINCT id
FROM my_table;



SELECT COUNT(DISTINCT(id))
FROM my_table;



SELECT COUNT(*)
FROM my_table;



SELECT COUNT(DISTINCT id)
FROM my_table;



SELECT a.id, b.id
FROM my_table a
JOIN my_other_table b
ON a.id = b.a_id
WHERE b.c_id = 4;



SELECT *
FROM my_table
JOIN my_other_table ON TRUE;



SELECT a.id, b.id
FROM my_table a
JOIN my_other_table b USE INDEX FOR JOIN (idx_a)
ON a.id = b.a_id;



SELECT 1
FROM my_table a
JOIN my_other_table b IGNORE INDEX FOR JOIN (idx_a)
ON a.id = b.a_id;



SELECT a.id, b.id
FROM my_table a
JOIN my_other_table b USING (q, w);



SELECT *
FROM my_table
JOIN (VALUES (1, 2), (3, 4)) AS v (col1, col2) ON TRUE;



SELECT table_a.id
FROM table_a a
LEFT JOIN table_b b
ON a.id = b.a_id
LEFT OUTER JOIN table_c c
ON a.id = c.a_id
RIGHT JOIN table_d d
ON a.id = d.d_id
RIGHT OUTER JOIN table_d d
ON a.id = d.d_id
INNER JOIN table_e e
ON a.id = e.e_id
FULL OUTER JOIN table_f f
ON a.id = f.f_id
FULL JOIN table_g g
ON a.id = g.g_id
NATURAL JOIN table_h h
USING (id);



SELECT a.id, arr.*
FROM my_table a
JOIN LATERAL unnest(a.arr) AS arr ON TRUE;



SELECT a.id, b.*
FROM my_table a
CROSS JOIN LATERAL (SELECT 1) AS b;



SELECT a.id, b.id, c.id
FROM my_table a
JOIN my_other_table b
ON a.id = b.a_id
JOIN table_three c
ON a.id = c.a_id
LEFT JOIN table_four d
JOIN table_five e
ON d.e_id = e.id
ON c.id = d.c_id;



SELECT title, id
FROM my_table m
WHERE m.id > 4 AND id < 3
ORDER BY m.title, id ASC;



SELECT id
FROM my_table
WHERE id > 4
ORDER BY id DESC NULLS LAST, val USING < NULLS FIRST;



SELECT id
FROM my_table FORCE INDEX (long_index_identifier)
LIMIT 1;



SELECT id
FROM my_table USE INDEX (long_index_identifier)
LIMIT 1;



SELECT 1 UNION ALL SELECT 2;



(SELECT * FROM tb2)
UNION
(SELECT * FROM tb2)

;



(
 (SELECT * FROM tb2)
 UNION
 (SELECT * FROM tb2)
)

;



SELECT a FROM one
INTERSECT
SELECT b FROM two;



SELECT a, CASE b WHEN 1 THEN 'yes' ELSE 'no' END AS is_b
FROM my_table;



SELECT
    a,
    CASE
        WHEN b BETWEEN 0 AND 1 THEN 'small'
        WHEN (b < 100) THEN 'lower_hundered'
        WHEN ((b < 1000) and (b>300)) THEN 'middle'
        WHEN b > 1 THEN 'yes'
        ELSE 'no'
    END AS is_b
FROM my_table;



SELECT a, CASE
  WHEN b = 1 THEN 'yes'
  WHEN b = 2 THEN 'maybe'
  ELSE 'no'
END AS is_b,
       CASE b
         WHEN 1 THEN 'yes'
         WHEN 2 THEN 'maybe'
       END is_b_really
 FROM my_table;



SELECT id || '-' || name FROM my_table;



SELECT c._id, c.p_id
  FROM c_table c
FORCE INDEX (idx_c_on_s_id_and_p_id_and_c_id)
JOIN cp_table cp
  ON cp.c_id = c.id
  AND cp.s_id = c.s_id
JOIN my_table USE INDEX FOR JOIN (idx_my_table_on_s_id_and_id)
  ON c.c_id = my_table.id
  AND c.s_id = my_table.s_id
WHERE c.s_id = 1239
  AND c.p_id in (1)
  AND cp.ch_id = 6
  AND cp.is_published = TRUE
ORDER BY my_table.title, my_table.id;



SELECT *
FROM
    Table1 a,
    Table2 b,
    Table3 c,
    TableN z;



SELECT *
FROM x
WHERE id = ?;



SELECT *
FROM x
WHERE id = $12;



SELECT a
FROM
  (SELECT * FROM tab2) AS tab;



SELECT
    *
FROM
    (VALUES (1, 2), (3, 4)) AS V (col1, col2);



WITH test_data AS (
SELECT
    *
FROM
    (VALUES
        (true))
    AS t (a)
)
SELECT
    CASE WHEN a THEN 'A' END AS A
FROM test_data;



SELECT *
FROM some_table s

;



SELECT
  s.id,
  at.code AS codes,
  -- comment
  s.another_table_id
FROM some_table s
  LEFT JOIN another_table at
    ON s.another_table_id = at.id
WHERE
  s.is_not_deleted = 1

;



SELECT array[1, 2, 3 + 4, '5'::int, int_please()];



SELECT ARRAY(SELECT col FROM tab)

;



SELECT a + 3 from b where a >= -14

;



SELECT a + 3.1415 from b where a >= -3.14

;



SELECT interval '1m'

;



SELECT 'foo''bar';



SELECT '''foo''';



SELECT 'foo''''''bar';



select
    a
from b
where a between '2022-01-01' and '2023-01-01'

;



select
    a
from b
where a not between 1 and 3

;



SELECT 1
FROM foo
WHERE (foo OR bar) AND baz

;



(SELECT 1)

;



SELECT
    count(*) FILTER (WHERE i < 5) AS filtered
FROM tab

;



SELECT
a1.*
FROM (
  SELECT * FROM tb01
  UNION ALL
  SELECT * FROM tb01
) a1;
