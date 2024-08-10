

CREATE INDEX ON tab(col);



CREATE UNIQUE INDEX CONCURRENTLY
  IF NOT EXISTS idx1
  ON tab
  USING HASH(col ASC)
  WHERE tab.col > 10;



CREATE UNIQUE INDEX foo_index ON foo (
  md5(COALESCE(cat, '')) COLLATE some_collation ASC NULLS LAST,
  dog some_operator_class(1),
  (cow / 2)
);
