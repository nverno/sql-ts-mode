WITH my_cte AS
  (SELECT one,
          two
   FROM my_table)
 SELECT *
 FROM my_cte;

WITH first AS
  (INSERT INTO my_table (one, two)
   VALUES (1, 2) RETURNING *
), second AS
  (SELECT one,
          two
   FROM my_table)
 SELECT *
 FROM second;

WITH first AS NOT MATERIALIZED
  (SELECT a
   FROM b),
  second AS MATERIALIZED
    (SELECT one, two
     FROM my_table)
 SELECT *
 FROM second;


(WITH data AS
  (SELECT 1 AS col) SELECT *
 FROM data) ;

WITH top_cte AS
  (WITH nested_cte AS
    (SELECT 1 as one,
            2 as two) SELECT one,
                             two
   FROM nested_cte)
 SELECT *
 FROM top_cte;

WITH top_cte AS
  (WITH nested_cte AS
    (WITH nested_further AS
      (SELECT 1 as one,
              2 as two)
     SELECT *
     FROM nested_further) SELECT one,
                                 two
   FROM nested_cte)
 SELECT *
 FROM top_cte;

with tb2 as
  (SELECT *
   FROM tb1) (
  (SELECT *
   FROM tb2)
  UNION
  (SELECT *
   FROM tb2)) ;

with tb2 as
  (SELECT *
   FROM tb1)
  (SELECT *
   FROM tb2)
  UNION
  (SELECT *
   FROM tb2) ;

(with x as
  (select *
   from ints))
  (select *
 from x);

((with x AS
  (SELECT *
   from ints))
  (SELECT *
 FROM x));

WITH RECURSIVE included_parts(sub_part, part, quantity) AS
  (SELECT sub_part,
          part,
          quantity
   FROM parts
   WHERE part = 'our_product'
   UNION ALL SELECT p.sub_part,
                    p.part,
                    p.quantity * pr.quantity
   FROM included_parts pr,
     parts p
   WHERE p.part = pr.sub_part )
 SELECT sub_part,
        SUM(quantity) as total_quantity
 FROM included_parts ;
