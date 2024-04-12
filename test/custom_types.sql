CREATE TYPE sports

CREATE TYPE colors as ENUM (
    'red',
    'green',
    'blue'
);

CREATE TYPE cities AS (
    cityname text,
    population INTEGER
);

CREATE TYPE marathon AS RANGE (
    SUBTYPE = sports
)

CREATE TYPE bigobj (
    INPUT = lo_filein, OUTPUT = lo_fileout,
    INTERNALLENGTH = VARIABLE
);

DROP TYPE IF EXISTS boxes CASCADE;

ALTER TYPE boxes RENAME TO cubes;

ALTER TYPE boxes
RENAME ATTRIBUTE width TO height;

ALTER TYPE boxes
OWNER TO user2

ALTER TYPE boxes
SET SCHEMA new_schema

ALTER TYPE boxes
ADD VALUE  IF NOT EXISTS 'color' AFTER 'weight'

ALTER TYPE boxes
RENAME VALUE 'weight' TO 'mass'

ALTER TYPE boxes
ADD ATTRIBUTE label text

ALTER TYPE boxes DROP ATTRIBUTE IF EXISTS label

ALTER TYPE boxes
ADD ATTRIBUTE label varchar(255)

CREATE TABLE shipments (
shipment boxes
)

INSERT INTO shipments (shipment)
VALUES (ROW(10, 500, 'Box1')),
       (ROW(15, 800, 'Box2')),
       (ROW(12, 600, 'Box3'));

SELECT
    (boxes).height,
    (boxes).mass,
    (boxes).label
FROM shipments
