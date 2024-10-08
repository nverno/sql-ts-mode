

EXPLAIN SELECT * FROM tab

;



EXPLAIN ANALYZE VERBOSE SELECT * FROM tab

;



COMPUTE STATS my_table (col1);



COMPUTE INCREMENTAL STATS my_table
  PARTITION (partition_col=col1);



ANALYZE TABLE mytable
  PARTITION (partcol1=col1,
             partcol2=col2)
  COMPUTE STATISTICS
  FOR COLUMNS
  CACHE METADATA
  NOSCAN

;



OPTIMIZE mytable REWRITE DATA USING BIN_PACK
                                     WHERE col1 is not null

;



VACUUM my_table;



VACUUM FULL true my_table (col1, col2);



OPTIMIZE LOCAL TABLE my_table1, my_table2

;
