

BEGIN;
 COMMIT;



BEGIN;
  ALTER TABLE my_table
    ADD COLUMN val3 VARCHAR(100) NOT NULL;
  UPDATE my_table SET val3 = 'new';
  COMMIT;



BEGIN;
  ALTER TABLE my_table
    ADD COLUMN val3 VARCHAR(100) NOT NULL;
  ROLLBACK;



BEGIN TRANSACTION;
  ALTER TABLE my_table
    ADD COLUMN val3 VARCHAR(100) NOT NULL;
  ROLLBACK TRANSACTION;
