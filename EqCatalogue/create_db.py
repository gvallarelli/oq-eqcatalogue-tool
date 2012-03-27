import os
from pyspatialite import dbapi2 as sqlite3
from datetime import datetime as time

from reader import CsvEqCatalogueReader, Converter

SRID = 4326
NO_NULL_GEO = 1

def create_db(db_filename, db_schema):

    db_is_new = not os.path.exists(db_filename)
    with sqlite3.connect(db_filename) as conn:
        if db_is_new:
            with open(db_schema, 'r') as file_to:
                schema = file_to.read()
                conn.executescript(schema)

def add_geo_column(db_filename, srid, no_null_geo):

    add_geo_query = """select AddGeometryColumn('event', 'geometry',
        %d, 'POINT', 'XY', %d);""" % (srid, no_null_geo)
    with sqlite3.connect(db_filename) as conn:
        cursor = conn.cursor()
        cursor.execute(add_geo_query)

def create_data_dict(entry):

    point_wkt = "GeomFromText('POINT(%d %d)', %d)" % (
                    entry['Latitude'], entry['Longitude'], SRID)

    ev_time = time(entry['year'], entry['month'], entry['day'],
            entry['hour'], int(entry['second'])).isoformat()

    data_dict = {'id_event': entry['eventKey'],
        'id_solution': entry['solutionKey'],
        'description': entry['solutionDesc'],
        'agency': entry['solutionAgency'],
        'time': ev_time,
        'time_error': entry['timeError'],
        'time_rms': entry['time_rms'],
        'geometry': point_wkt,
        'semi_major90': entry['semiMajor90'],
        'semi_minor90': entry['semiMinor90'],
        'error_azimuth': entry['errorAzimuth'],
        'depth_error': entry['depthError'],
        'phases': entry['phases'],
        'stations': entry['stations'],
        'azimuth_gap': entry['azimuthGap'],
        'min_distance': entry['minDistance'],
        'max_distance': entry['maxDistance']}

    return data_dict


def parse_catalogue(cat_filename):
    converter = Converter()
    cat_fileobj = open(cat_filename)
    reader = CsvEqCatalogueReader(cat_fileobj)

    entries = []
    for entry in reader.read(converter):
        entries.append(entry)

    cat_fileobj.close()

    return entries


def insert_entries(db_filename, entries):
    with sqlite3.connect(db_filename) as conn:
        cursor = conn.cursor()
        query_event = """insert into event(id_event, id_solution, description,
            agency, time, time_error, time_rms, geometry, semi_major90,
            semi_minor90, error_azimuth, depth_error, phases, stations,
            azimuth_gap, min_distance, max_distance)
            values(:id_event, :id_solution, :description, :agency, :time,
                :time_error, :time_rms, :geometry, :semi_major90,
                :semi_minor90, :error_azimuth, :depth_error, :phases,
                :stations, :azimuth_gap, :min_distance, :max_distance);"""

        for entry in entries:
            data_dict = create_data_dict(entry)
            cursor.execute(query_event, data_dict)

if __name__ == '__main__':

    db_filename = 'db/eqcatalogue.db'
    entries = parse_catalogue('../tests/data/myanmar_sample.csv')
    create_db(db_filename, 'db/schema/eqcatalogue.sql')
    add_geo_column(db_filename, SRID, NO_NULL_GEO)
    insert_entries(db_filename, entries)


