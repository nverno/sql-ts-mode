

SELECT
  x,
  y,
  z,
  AVG(x) OVER (PARTITION BY y)
 FROM tab1;



SELECT
  x,
  y,
  z,
  AVG(x) OVER (ORDER BY y DESC NULLS LAST)
 FROM tab1;



SELECT
  x,
  y,
  z,
  AVG(x) OVER (PARTITION BY z ORDER BY y DESC NULLS FIRST)
 FROM tab1;



SELECT
  a,
  SUM(b) OVER () AS empty_sum
 FROM tab1;



SELECT
  a,
  SUM(b) OVER (PARTITION BY c) AS w1,
  AVG(b) OVER (ORDER BY d) AS w2,
  FROM tab1;



SELECT
  x,
  y,
  MAX(x) OVER window_def
 FROM tab1
 WINDOW window_def AS (PARTITION BY y);



SELECT
  a,
  SUM(b) OVER (PARTITION BY c) AS w1,
  AVG(b) OVER win AS w2
 FROM tab1
 WINDOW win AS (ORDER BY d)
;



SELECT
  a,
  c,
  MAX(c) OVER (
    PARTITION BY a
    ORDER BY a
    RANGE BETWEEN UNBOUNDED PRECEDING
        AND UNBOUNDED FOLLOWING
  ),
  MAX(c) OVER (
    PARTITION BY a
    RANGE a + 1 PRECEDING
  )
 FROM
   tab;



SELECT
  a,
  c,
  MAX(c) OVER (
    PARTITION BY a,b
    ORDER BY a ASC NULLS FIRST
    ROWS BETWEEN 3 PRECEDING
        AND 3 FOLLOWING EXCLUDE CURRENT ROW
  )
 FROM
   tab;



SELECT
  a,
  c,
  MAX(c) OVER (
    PARTITION BY
      1,
      a,
      $1,
      CASE WHEN a > 100 THEN TRUE ELSE FALSE END,
      CAST(a AS DATE),
      a::DATE,
      (SELECT a FROM b),
      date_trunc(a),
      a * b
    ORDER BY
      1,
      a,
      $1,
      CASE WHEN a > $2 THEN TRUE ELSE FALSE END,
      CAST(a AS DATE),
      a::DATE,
      (SELECT a FROM b),
      date_trunc(a),
      a * b
  )
 FROM
   tab;



SELECT
  count(*) OVER (PARTITION BY c) AS w1
 FROM tab1
;
