CREATE EXTENSION postgis;
Create table geometries ( name varchar, geom geometry );
SELECT * FROM geometries
-- id to integer name to varchar a geoemtry to typ geometry 
-- po zadaniu trzecim mamy tabele do której robimy inserty obiekto w
-- i dobojetne nazwa ze zdjecia a geometry to współrzedne i opus obiektu 

CREATE TABLE buildings (id integer, geometry geometry, name varchar );
CREATE TABLE roads (id integer, geometry geometry, name varchar );
CREATE TABLE poi (id integer, geometry geometry, name varchar );

INSERT INTO buildings (id, geometry, name) VALUES
  ('3', 'POLYGON((3 6, 5 6, 5 8, 3 8, 3 6))', 'BuildingC'),
  ('2', 'POLYGON((4 5, 6 5, 6 7, 4 7, 4 5))', 'BuildingB' ),
  ('5', 'POLYGON((1 1, 2 1, 2 2, 1 2, 1 1))', 'BuildingF'),
  ('1', 'POLYGON((8 1.5, 10.5 1.5, 10.5 4, 8 4, 8 1.5))', 'BuildingA'),
  ('4', 'POLYGON((9 8, 10 8, 10 9, 9 9, 9 8))', 'BuildingD' )
  
INSERT INTO poi (id, geometry, name) VALUES
  ('1', 'POINT(1 3.5)', 'G'),
  ('2', 'POINT(5.5 1.5)', 'H'),
  ('3', 'POINT(9.5 6)', 'I'),
  ('4', 'POINT(6.5 6)', 'J'),
  ('5', 'POINT(6 9.5)', 'K')
  
INSERT INTO roads (id, geometry, name) VALUES
  ('1', 'LINESTRING(0 4.5, 12 4.5)', 'RoadX'),
  ('2', 'LINESTRING(7.5 0, 7.5 10.5)', 'RoadY')
  
  
-- a

  SELECT SUM(ST_Length(geometry)) AS total_road_length
FROM roads;

-- b

SELECT
  ST_AsText(geometry) AS building_geometry,
  ST_Area(geometry) AS building_area,
  ST_Perimeter(geometry) AS building_perimeter
FROM buildings
WHERE name = 'BuildingA';

-- c

SELECT name, ST_Area(geometry) AS building_area
FROM buildings
ORDER BY name;

-- d

SELECT name, ST_Perimeter(geometry) AS building_perimeter
FROM buildings
ORDER BY ST_Area(geometry) DESC
LIMIT 2;

-- e

SELECT ST_Distance(
  (SELECT geometry FROM buildings WHERE name = 'BuildingC'),
  (SELECT geometry FROM poi WHERE name = 'K')
) AS shortest_distance;

-- f

SELECT ST_Area(ST_Intersection(
  (SELECT geometry FROM buildings WHERE name = 'BuildingC'),
  ST_Buffer((SELECT geometry FROM buildings WHERE name = 'BuildingB'), 0.5)
)) AS area_within_distance;

-- g

SELECT name
FROM buildings
WHERE ST_Y(ST_Centroid(geometry)) > (SELECT ST_Y(ST_Centroid(geometry)) FROM roads WHERE name = 'RoadX');




-- h

SELECT
  ST_Area(ST_Difference(
    (SELECT geometry FROM buildings WHERE name = 'BuildingC'),
    ST_GeomFromText('POLYGON((4 7, 6 7, 6 8, 4 8, 4 7))')
  )) AS area_difference;
















  

