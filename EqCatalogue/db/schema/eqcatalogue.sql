-------------------------------------------------------------------------------
-- Table definitions
-------------------------------------------------------------------------------

-- Enable Foreign Key Support in Sqlite
PRAGMA foreign_keys = ON;

CREATE TABLE event (

    -- Internal identifier
    id INTEGER PRIMARY KEY AUTOINCREMENT,

    -- Event identifier by catalogue.
    id_event INTEGER NOT NULL,

    -- Solution identifier by catalogue.
    id_solution INTEGER NOT NULL,

    -- Event short description.
    description TEXT,

    -- Agency which recorded the event.
    agency TEXT,

    -- Time in format "YYYY-MM-DD HH:MM:SS.SSS".
    time DATETIME,

    -- Time errors expressed in seconds.
    time_error REAL,

    -- Time error expressed as a Root Mean Square in seconds.
    time_rms REAL,

    -- Semi-Major axis of the 90th percentile confidence ellipsis of the
    -- epicentre.
    semi_major90 REAL,

    -- Semi-Minor axis of the 90th percentile confidence ellipsis of the
    -- epicentre.
    semi_minor90 REAL,

    -- Azimuth with respect to geographical north of the Semi-Major axis.
    error_azimuth REAL,

    -- Error in km on the hypocentre depth.
    depth_error REAL,

    -- Number of phases used to constraint hypocentre.
    phases INTEGER,

    -- Number of stations used to constraint hypocentre.
    stations INTEGER,

    -- Gap in degrees of event to site azimuth.
    azimuth_gap INTEGER,

    -- Minimum source to station distance.
    min_distance REAL,

    -- Maximum source to station distance.
    max_distance REAL
);


CREATE TABLE magnitude(
    
    -- Internal identifier
    id INTEGER PRIMARY KEY AUTOINCREMENT,

    -- Identifier for the hypocentre solution.
    origin_id INTEGER NOT NULL,

    -- Agency which recored the magnitude.
    agency TEXT,

    -- Magnitude type.
    m_type TEXT,

    -- Magnitude value.
    m_value REAL,

    -- Magnitude error.
    error REAL,

    -- Magnitude stations used to estimate magnitude.
    num_stations INTEGER,

    event_id INTEGER NOT NULL,

    CONSTRAINT fk_mag_event
        FOREIGN KEY(event_id)
        REFERENCES event(int_id)
);
