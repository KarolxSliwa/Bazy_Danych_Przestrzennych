CREATE EXTENSION postgis; 

CREATE TABLE tb1 (
    id SERIAL PRIMARY KEY,
	Nazwa varchar,
    geom GEOMETRY
);

INSERT INTO tb1 VALUES (
    DEFAULT,
    'obiekt1',
    ST_Collect(
        ARRAY[
            ST_GeomFromText('LINESTRING(0 1, 1 1)'),
            ST_GeomFromText('CIRCULARSTRING(1 1, 2 0, 3 1)'),
            ST_GeomFromText('CIRCULARSTRING(3 1, 4 2, 5 1)'),
            ST_GeomFromText('LINESTRING(5 1, 6 1)')
        ]
    )
)

INSERT INTO tb1 VALUES (
    DEFAULT,
    'obiekt3',
    ST_Collect(
        ARRAY[
            ST_GeomFromText('LINESTRING(7 15, 10 17)'),
            ST_GeomFromText('LINESTRING(10 17, 12 13)'),
			ST_GeomFromText('LINESTRING(12 13, 7 15)')
        ]
    )
)

INSERT INTO tb1 (nazwa, geom) VALUES (
    'obiekt2',
    ST_Collect(
        ARRAY[
            ST_GeomFromText('LINESTRING(10 6, 14 6)'),
            ST_GeomFromText('CIRCULARSTRING(14 6, 16 4, 14 2)'),
            ST_GeomFromText('CIRCULARSTRING(14 2, 12 0, 10 2)'),
            ST_GeomFromText('LINESTRING(10 2, 10 6)'),
            ST_GeomFromText('CIRCULARSTRING(11 2, 12 3, 13 2, 12 1, 11 2)')
        ]
    )
)

INSERT INTO tb1 (nazwa, geom) VALUES (
    'obiekt4',
    ST_Collect(
        ARRAY[
            ST_GeomFromText('LINESTRING(20 20, 25 25)'),
			ST_GeomFromText('LINESTRING(25 25, 27 24)'),
			ST_GeomFromText('LINESTRING(27 24, 25 22)'),
			ST_GeomFromText('LINESTRING(25 22, 26 21)'),
			ST_GeomFromText('LINESTRING(26 21, 22 19)'),
			ST_GeomFromText('LINESTRING(22 19, 20.5 19.5)')
        ]
    )
)

INSERT INTO tb1 (nazwa, geom) VALUES (
    'obiekt5',
    ST_Collect(
        ARRAY[
            ST_GeomFromText('POINT(38 32 234, 38 32 234)'),
			ST_GeomFromText('POINT(30 30 59, 30 30 59)')
        ]
    )
)

INSERT INTO tb1 (nazwa, geom) VALUES (
    'obiekt6',
    ST_Collect(
        ARRAY[
            ST_GeomFromText('LINESTRING(1 1, 3 2)'),
			ST_GeomFromText('POINT(4 2)')
        ]
    )
)


--zad2

WITH shortest_line AS (
    SELECT ST_ShortestLine(t1.geom, t2.geom) AS shortest_line
    FROM tb1 t1, tb1 t2
    WHERE t1.nazwa = 'obiekt3' AND t2.nazwa = 'obiekt4'
)
SELECT ST_Area(ST_Buffer(shortest_line, 5)) AS area
FROM shortest_line


--zad3

-- Dodawanie punktu początkowego na końcu linii obiekt4, to jest potrzebne
UPDATE tb1
SET geom = ST_MakePolygon(geom)
WHERE nazwa = 'obiekt4' AND ST_StartPoint(geom) = ST_EndPoint(geom);


-- zad4

INSERT INTO tb1 (nazwa, geom)
SELECT
    'obiekt7',
    ST_Collect(ARRAY[o3.geom, o4.geom])
FROM
    tb1 o3
CROSS JOIN
    tb1 o4
WHERE
    o3.nazwa = 'Obiekt3' AND o4.nazwa = 'Obiekt4'
	
-- zad 5

WITH shortest_lines AS (
    SELECT ST_ShortestLine(t1.geom, t2.geom) AS shortest_line
    FROM tb1 t1, tb1 t2
    WHERE t1.nazwa <> t2.nazwa 
)
SELECT ST_Area(ST_Buffer(shortest_line, 5)) AS area
FROM shortest_lines
WHERE NOT ST_HasArc(ST_GeometryN(shortest_line, 1))










