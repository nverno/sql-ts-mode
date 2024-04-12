-- hello
SELECT 1;

-- hello
SELECT 1; --hi
--hi

-- hello
SELECT 1; --hi
-- hi again
SELECT 2;

/* application=super-app */
SELECT id /* MAX_EXECUTION_TIME(500) */
 FROM my_table;

DELETE /* MAX_EXECUTION_TIME(500) */
 FROM my_table;

/*
This is a query
With a multiline comment
*/
SELECT id
  /*
  SELECT id FROM my_table;
  */
 FROM my_table;

/*
*/
SELECT id
  /*
  
  */
 FROM my_table;

/**
* Javadoc style
* -- with an inline comment
*/
SELECT id
  /******/
 FROM my_table;

SELECT '-- foo' FROM bar;

SELECT '/* foo */' FROM bar;

--
SELECT 1;
