
UPDATE my_table
SET for = foo + 1;


UPDATE ONLY my_table
SET for = foo + 1;


UPDATE my_table
SET for = foo + 1,
    col2 = col1;


UPDATE items,
       month
SET items.price=month.price
WHERE items.id=month.item_id;


UPDATE my_table
SET ts = now();


UPDATE table_a a
INNER JOIN table_b b ON b.a = a.uid
INNER JOIN table_c c ON c.b = b.uid
SET a.d = 5;


UPDATE table_a as a
SET d = 5
WHERE b.a = a.uid;


UPDATE table_a as a
SET d = 5
FROM table_b b
  INNER JOIN table_c c ON c.b = b.uid
WHERE b.a = a.uid;
