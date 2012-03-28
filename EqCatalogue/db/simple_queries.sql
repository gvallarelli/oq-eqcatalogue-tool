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
