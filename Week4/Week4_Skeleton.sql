DROP TABLE IF EXISTS epa_air_quality_no_index;
DROP TABLE IF EXISTS epa_air_quality_btree_index;
DROP TABLE IF EXISTS epa_air_quality_hash_index;


-- Ex1.  Create without index and load data from data.csv.
CREATE TABLE epa_air_quality_no_index
(
	date DATE DEFAULT CURRENT_DATE,
	site_id INTEGER CHECK (site_id > 0),
	daily_mean_pm10_concentration REAL NOT NULL,	
	daily_aqi_value REAL NOT NULL
);

COPY epa_air_quality_no_index
FROM '/Users/dwoodbridge/Class/2023_MSDS691/Example/Data/epa_air_quality.csv'
DELIMITER ','
CSV HEADER;


--Ex2. Create with index using btree and cluster. Load data from data.csv.
CREATE TABLE epa_air_quality_btree_index
(
	date DATE DEFAULT CURRENT_DATE,
	site_id INTEGER CHECK (site_id > 0),
	daily_mean_pm10_concentration REAL NOT NULL,	
	daily_aqi_value REAL NOT NULL
);

--TO DO : CREATE INDEX

COPY epa_air_quality_btree_index
FROM '/Users/dwoodbridge/Class/2023_MSDS691/Example/Data/epa_air_quality.csv'
DELIMITER ','
CSV HEADER;
 
--TO DO :  CLUSTER


-- Ex3.
-- Analyze the following in the epa_air_quality_no_index table.
-- Scan
EXPLAIN ANALYZE VERBOSE SELECT * FROM epa_air_quality_no_index; -- Execution Time: 
-- Equality Selection - site_id is 60650500
EXPLAIN ANALYZE VERBOSE SELECT * FROM epa_air_quality_no_index WHERE site_id = 60650500; -- Execution Time: 
-- Range Selection - plaza_id is great than 60650500
EXPLAIN ANALYZE VERBOSE SELECT * FROM epa_air_quality_no_index WHERE site_id > 60650500; -- Execution Time: 
-- Insert  - ('2021-09-22', 60431001, 23, 120)
EXPLAIN ANALYZE VERBOSE INSERT INTO epa_air_quality_no_index VALUES ('2021-09-22', 60431001, 23, 120); -- Execution Time: 
-- Delete - the inserted row
EXPLAIN ANALYZE VERBOSE DELETE FROM epa_air_quality_no_index WHERE site_id = 60431001 AND date = '2021-09-22'; -- Execution Time:

-- Ex4. Analyze the following in the epa_air_quality_btree_index table.
-- Scan
EXPLAIN ANALYZE VERBOSE SELECT * FROM epa_air_quality_btree_index; -- Execution Time: 
-- Equality Selection - site_id is 60650500
EXPLAIN ANALYZE VERBOSE SELECT * FROM epa_air_quality_btree_index WHERE site_id = 60650500; -- Execution Time:
-- Range Selection - plaza_id is great than 60650500
EXPLAIN ANALYZE VERBOSE SELECT * FROM epa_air_quality_btree_index WHERE site_id > 60650500; -- Execution Time: 
-- Insert  - ('2021-09-22', 60431001, 23, 120)
EXPLAIN ANALYZE VERBOSE INSERT INTO epa_air_quality_btree_index VALUES ('2021-09-22', 60431001, 23, 120); -- Execution Time:
-- Delete - the inserted row
EXPLAIN ANALYZE VERBOSE DELETE FROM epa_air_quality_btree_index WHERE site_id = 60431001 AND date = '2021-09-22'; -- Execution Time: 
						
-- Ex5. Create epa_air_quality_hash_index with hash index on site_id.
CREATE TABLE epa_air_quality_hash_index
(
	date DATE DEFAULT CURRENT_DATE,
	site_id INTEGER CHECK (site_id > 0),
	daily_mean_pm10_concentration REAL NOT NULL,	
	daily_aqi_value REAL NOT NULL
);


-- TODO : CREATE INDEX

COPY epa_air_quality_hash_index
FROM '/Users/dwoodbridge/Class/2023_MSDS691/Example/Data/epa_air_quality.csv'
DELIMITER ','
CSV HEADER;


-- Ex6. Analyze the following in the epa_air_quality_hash_index table.
-- Scan
EXPLAIN ANALYZE VERBOSE SELECT * FROM epa_air_quality_hash_index; -- Execution Time: 
-- Equality Selection - site_id is 60650500
EXPLAIN ANALYZE VERBOSE SELECT * FROM epa_air_quality_hash_index WHERE site_id = 60650500; -- Execution Time:
-- Range Selection - plaza_id is great than 60650500
EXPLAIN ANALYZE VERBOSE SELECT * FROM epa_air_quality_hash_index WHERE site_id > 60650500; -- Execution Time:
-- Insert  - ('2021-09-22', 60431001, 23, 120)
EXPLAIN ANALYZE VERBOSE INSERT INTO epa_air_quality_hash_index VALUES ('2021-09-22', 60431001, 23, 120); -- Execution Time:
-- Delete - the inserted row
EXPLAIN ANALYZE VERBOSE DELETE FROM epa_air_quality_hash_index WHERE site_id = 60431001 AND date = '2021-09-22'; -- Execution Time: 
