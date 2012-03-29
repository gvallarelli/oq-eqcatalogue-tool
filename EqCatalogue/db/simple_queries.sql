-- Queries

-- How many solutions there are for each event in the db ?

select id, id_event, count(id_solution)
from event
group by id_event;

-- Join on reference.
select e.id, e.agency, id_event, id_solution, m.id, origin_id, m_type, m_value
from event e, magnitude m
where e.id = m.event_id;

-- Find all events in the catalogue that have a "ML" magnitude
-- AND a "mb" magnitude.
select e.id_event
from event e, magnitude m
where e.id = m.event_id and m_type = 'ML'
intersect
select e.id_event
from event e, magnitude m
where e.id = m.event_id and m_type = 'mb';

-- Find all events that have agency [e.g. ISC] and "Ms" magnitude and a "mb"
-- magnitude.
select e.id_event
from event e, magnitude m
where e.id = m.event_id and m_type = 'ML' and e.agency = 'IDC'
intersect
select e.id_event
from event e, magnitude m
where e.id = m.event_id and m_type = 'mb' and e.agency = 'IDC';

-- Find all events that have a Ms solution for both Agency 1 (ISC) 
-- AND Agency 2 (BJI).
select e.id_event
from event e, magnitude m
where e.id = m.event_id and m_type = 'mb' and e.agency = 'BJI'
intersect
select e.id_event
from event e, magnitude m
where e.id = m.event_id and m_type = 'mb' and e.agency = 'IDC';

-- Find all events that have magnitude type Mw for Agency 1 (e.g. HVRD),
-- AND magnitude type Ms for Agency 2 (e.g. ISC).
select e.id_event
from event e, magnitude m
where e.id = m.event_id and m_type = 'mb' and e.agency = 'BJI'
intersect
select e.id_event
from event e, magnitude m
where e.id = m.event_id and m_type = 'MS' and e.agency = 'IDC';


-- Use time functions see ref (http://sqlite.org/lang_datefunc.html)
select id, id_event, id_solution, time
from event
where time > date('2002-09-13');

-- Geometry queries

create table point(
id integer primary key autoincrement);

select AddGeometryColumn('point', 'geometry', 4326, 'POINT', 2);

create table polygon(
id integer primary key autoincrement);

select AddGeometryColumn('polygon', 'geometry', 4326, 'POLYGON', 2);

insert into polygon(geometry)
values(GeomFromText(
'POLYGON((15.9217 36.5643, 21.1751 37.8216, 23.9401 34.9269, 20.3456 32.1199,
14.9078 32.4708, 15.9217 36.5643))', 4326));

select AsText(geometry) from polygon;

-- Given polygon built with these points
-- 15.9217,36.5643
-- 21.1751, 37.8216
-- 23.9401, 34.9269
-- 20.3456, 32.1199
-- 14.9078, 32.4708
-- 15.9217, 36.5643 (deleting...)

-- These points are considered to be contained:

insert into point(geometry)
values(GeomFromText('POINT(20.9376 35.5016)', 4326));
    
insert into point(geometry)
values(GeomFromText('POINT(19.7075 32.3049)', 4326));
    
insert into point(geometry)
values(GeomFromText('POINT(18.4352 32.2592)', 4326));
    
insert into point(geometry)
values(GeomFromText('POINT(16.342 33.1878)', 4326));
    
insert into point(geometry)
values(GeomFromText('POINT(17.6312 32.6248)', 4326));

insert into point(geometry)
values(GeomFromText('POINT(19.7953 37.3033)', 4326));

insert into point(geometry)
values (GeomFromText('POINT(18.9117 34.8861)', 4326));

-- These points are considered to be outside:

insert into point(geometry)
values(GeomFromText('POINT(26.2945 36.4432)', 4326));

insert into point(geometry)
values(GeomFromText('POINT(28.1158 33.7861)', 4326));

insert into point(geometry)
values(GeomFromText('POINT(12.5397 38.1158)', 4326));

-- Events inside polygon [Lon, Lat, Lon, Lat, ... Lon, Lat]

select p.id, AsText(p.geometry), within(p.geometry, pg.geometry)
from point p, polygon pg;


-- Reference node.
-- 19.9770, 34.9854

insert into point(geometry)
values (GeomFromText('POINT(19.9770 34.9854)', 4326));

-- Nodes supposed to be within a distance of 300km from the reference ones.

-- 22.6472 33.5073
-- 20.9376 35.5016
-- 19.7075 32.3049
-- 19.7953 37.3033
-- 18.9117 34.8861
-- 22.9263 35.7853
-- 23.1020 35.2114

insert into point(geometry)
values (GeomFromText('POINT(22.6472 33.5073)', 4326));

insert into point(geometry)
values (GeomFromText('POINT(20.9376 35.5016)', 4326));

insert into point(geometry)
values (GeomFromText('POINT(19.7075 32.3049)', 4326));

insert into point(geometry)
values (GeomFromText('POINT(19.7953 37.3033)', 4326));

insert into point(geometry)
values (GeomFromText('POINT(18.9117 34.8861)', 4326));

insert into point(geometry)
values (GeomFromText('POINT(22.9263 35.7853)', 4326));

insert into point(geometry)
values (GeomFromText('POINT(23.1020 35.2114)', 4326));

-- Nodes supposed to be far than 300km from the reference one.

-- 26.2945 36.4432
-- 28.1158 33.7861
-- 12.5397 38.1158

insert into point(geometry)
values (GeomFromText('POINT(26.2945 36.4432)', 4326));

insert into point(geometry)
values (GeomFromText('POINT(28.1158 33.7861)', 4326));

insert into point(geometry)
values (GeomFromText('POINT(12.5397 38.1158)', 4326));

-- Events within a distance of (e.g. 300 km) from point (Lon, Lat)
select Distance((select geometry from point where id=1), geometry)
from point;
