

SELECT other_id, COUNT(name)
 FROM my_table
 GROUP BY other_id
   HAVING other_id > 10;



SELECT other_id, COUNT(name)
 FROM my_table
 GROUP BY 1
   HAVING other_id > 10;



SELECT other_id, other_col, COUNT(name)
 FROM my_table
 GROUP BY 1, other_col
   HAVING other_id > 10;



SELECT other_id, COUNT(name)
 FROM my_table
 GROUP BY other_id
   HAVING COUNT(*) = 2;
