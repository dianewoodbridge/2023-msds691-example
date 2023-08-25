-----------------------------------------------------------
-- Ex 2. Using oscars.csv and directors.csv, 
-- create oscars and directors table and add constraints.
-----------------------------------------------------------
--directors
----director_id
----name
----start_year
----end_year
CREATE TABLE directors
(
	director_id INTEGER NOT NULL,
	name VARCHAR(50) NOT NULL,
	start_year INTEGER CHECK (start_year > 0) NULL,
	end_year INTEGER CHECK(end_year > start_year) NULL,
	PRIMARY KEY (director_id)
);

COPY directors
FROM '/Users/dwoodbridge/Class/2023_MSDS691/Example/Data/directors.csv'
DELIMITER ',';

--oscars
----year
----director_id
----title

CREATE TABLE oscars
(
	year INTEGER NOT NULL, 
    director_id INTEGER NOT NULL,
    title VARCHAR(50) NOT NULL,
	PRIMARY KEY (year),
	FOREIGN KEY (director_id)
	REFERENCES directors(director_id) 
	ON UPDATE CASCADE ON DELETE CASCADE
);

COPY oscars
FROM '/Users/dwoodbridge/Class/2023_MSDS691/Example/Data/oscars.csv'
DELIMITER ',';

-----------------------------------------------------------
-- Ex 3. Update director_id by 2 for Ang Lee 
-- in director table.
-----------------------------------------------------------
SELECT * FROM directors;
SELECT * FROM oscars;

UPDATE directors
SET director_id = director_id + 2
WHERE name = 'Ang Lee';

SELECT * FROM directors;
SELECT * FROM oscars;
