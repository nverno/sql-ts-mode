

DELETE FROM my_table;



DELETE FROM ONLY my_table;



DELETE FROM my_table
LIMIT 4;



DELETE FROM my_table
ORDER BY id DESC
LIMIT 4;


DELETE FROM my_table
WHERE id = 9;



TRUNCATE TABLE employees CASCADE;
