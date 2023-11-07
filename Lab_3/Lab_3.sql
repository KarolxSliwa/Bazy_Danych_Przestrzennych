CREATE EXTENSION postgis;

-- zad 1
SELECT polygon_id, geom into res
FROM t2019_kar_buildings
WHERE polygon_id NOT IN (SELECT polygon_id FROM t2018_kar_buildings)
   OR geom IS DISTINCT FROM (SELECT geom 
							 FROM t2018_kar_buildings 
							 WHERE t2018_kar_buildings.polygon_id = t2019_kar_buildings.polygon_id)
							 
-- zad 2

SELECT * INTO poi_19 FROM t2019_kar_poi_table 
SELECT * INTO poi_18 FROM t2018_kar_poi_table


SELECT poi_19.poi_id, poi_19.geom , poi_19.type as res2
FROM poi_19
LEFT JOIN poi_18 ON poi_19.poi_id = poi_18.poi_id
WHERE poi_18.poi_id IS NULL;

SELECT
    res.polygon_id,
    COUNT(poi.poi_id) AS liczba_nowych_poi,
    poi.type AS kategoria
FROM res
CROSS JOIN poi_19 AS poi
WHERE ST_DWithin(res.geom, poi.geom, 500.0)
GROUP BY res.polygon_id, poi.type
ORDER BY res.polygon_id, poi.type;

-- zad3

UPDATE t2019_kar_streets
SET geom = ST_SetSRID(geom, 2964);

CREATE TABLE streets_reprojected AS
SELECT
    link_id,
    ST_Transform(geom, 31466) AS geom
FROM t2019_kar_streets

select * from streets_reprojected

-- zad 4

CREATE TABLE input_points (
    id serial PRIMARY KEY,
    geom geometry(Point, 4326),
    nazwa text
)


INSERT INTO input_points (geom, nazwa) VALUES
  (ST_GeomFromEWKT('SRID=4326;POINT(8.36093 49.03174)'), 'punkt1'),
  (ST_GeomFromEWKT('SRID=4326;POINT(8.39876 49.00644)'), 'punkt2');
  
-- zad 5

UPDATE input_points
SET geom = ST_Transform(geom, 31466);


-- zad 6 

CREATE TEMPORARY TABLE input_points_reprojected AS
SELECT ST_Transform(geom, 31466) AS geom
FROM input_points;

select * from input_points_reprojected


CREATE TEMPORARY TABLE input_points_line AS
SELECT ST_MakeLine(geom) AS geom
FROM input_points_reprojected;

select * from input_points_line

SELECT DISTINCT t2019_kar_street_node.*
FROM t2019_kar_street_node 
JOIN input_points_line l ON ST_DWithin(t2019_kar_street_node.geom, ST_Buffer(l.geom, 200), 0);

UPDATE t2019_kar_street_node
SET geom = ST_SetSRID(geom, 31466);

SELECT DISTINCT n.*
FROM t2019_kar_street_node  n
JOIN input_points_line l ON ST_Contains(ST_Buffer(n.geom, 200), l.geom);

-- zad 7
select * from t2018_kar_poi_table

select * from t2019_kar_land_use_a

CREATE TEMPORARY TABLE parks_buffer AS
SELECT ST_Buffer(geom, 300) AS geom
FROM t2019_kar_land_use_a
WHERE type = 'Park (City/County)';


SELECT COUNT(*) AS liczba_sporting_goods_stores
FROM t2018_kar_poi_table poi
WHERE poi.type = 'Sporting Goods Store'
AND EXISTS (
    SELECT 1
    FROM parks_buffer p
    WHERE ST_Contains(p.geom, poi.geom)
);


-- zad 8 

select * from t2019_kar_railways

select * from t2019_kar_water_lines


CREATE TABLE T2019_KAR_BRIDGES (
    id serial PRIMARY KEY,
    geom geometry(Point)
);

INSERT INTO T2019_KAR_BRIDGES (geom)
SELECT (ST_Dump(ST_Intersection(r.geom, w.geom))).geom
FROM t2019_kar_railways r
CROSS JOIN t2019_kar_water_lines w
WHERE ST_Intersects(r.geom, w.geom);

select * from T2019_KAR_BRIDGES

