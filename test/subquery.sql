

SELECT id
FROM foo
WHERE id < (
  SELECT id
  FROM bar
  LIMIT 1);
