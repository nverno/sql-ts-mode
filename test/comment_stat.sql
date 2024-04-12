COMMENT ON TABLE my_schema.my_table IS "this table is a test";

COMMENT ON COLUMN my_schema.my_table.my_column IS NULL;

COMMENT ON CAST (varchar AS text) IS "convert varchar to text";

COMMENT ON MATERIALIZED VIEW matview IS "this view is materialized";

COMMENT ON TRIGGER on_insert ON users IS "new user has been added";

COMMENT ON FUNCTION schema_test.do_somthing(arg1 text) IS 'Do something';

COMMENT ON EXTENSION ext_test IS 'A testing extension';

COMMENT ON FUNCTION schema_test.do_somthing(OUT arg1 text) IS 'Do something';
