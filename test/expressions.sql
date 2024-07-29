

SELECT *
 FROM my_table m
 WHERE m.is_not_deleted;



SELECT *
 FROM my_table m
 WHERE m.is_not_deleted AND m.is_visible;



SELECT *
 FROM my_table m
 WHERE NOT m.is_not_deleted;



SELECT *
 FROM my_table m
 WHERE NOT m.is_not_deleted
   AND NOT m.is_visible;



SELECT *
 FROM my_table m
 WHERE m.status = "success"
   AND m.name = "foobar"
   AND m.id = 5
   AND m.is_not_deleted

;



SELECT *
 FROM my_table m
 WHERE m.status = "success"
   AND m.name = "foobar"
   OR m.id = 5
     AND m.is_not_deleted

;



SELECT *
 FROM my_table m
 WHERE NOT m.is_deleted;



SELECT *
 FROM my_table m
 WHERE !m.is_deleted;



SELECT *
 FROM my_table m
 WHERE NOT m.is_deleted
   AND NOT m.is_invisible;



SELECT *
 FROM my_table
 WHERE col IS DISTINCT FROM NULL;



SELECT *
 FROM my_table
 WHERE col IS NOT DISTINCT FROM NULL;



SELECT *
 FROM my_table
 WHERE id IS NOT NULL
   AND name IS NULL;



SELECT id
 FROM my_table m
 WHERE m.id > 4 AND id < 3;



SELECT
  *
 FROM
   a
 WHERE
   a LIKE '%a'
     AND a NOT LIKE '%a'
     AND a SIMILAR TO '%a'
     AND a NOT SIMILAR TO '%a';



SELECT
  *
 FROM
   a
 WHERE
   a <> '%a'

;



SELECT 'abc' ^@ 'a' || 'z';



SELECT 'fat cats ate rats' @@ !! ('cat' <-> 'rat'::tsquery);



SELECT
  (ARRAY[1, 4, 9])[1+1],
  (ARRAY[1, 4, 9])[1:3 - 1],
  (ARRAY[1, 4, 9])[1:2][3];
