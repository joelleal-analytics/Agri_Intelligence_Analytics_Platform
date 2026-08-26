USE crop_db;

-- ====================================================
-- SECTION 1: Crop Dataset: Database Setup and Staging 
-- Original File: crop_dataset.sql
-- ====================================================

CREATE TABLE staging_crop_json (
id INT AUTO_INCREMENT PRIMARY KEY,
text VARCHAR(1000),
metadata JSON
);

CREATE TABLE clean_crop_metrics AS
SELECT
JSON_UNQUOTE(JSON_EXTRACT(metadata, '$.crop')) AS crop,
CAST(REPLACE(REGEXP_SUBSTR(text, 'nitrogen is [0-9]+'), 'nitrogen is ', '') AS UNSIGNED) AS nitrogen,
CAST(REPLACE(REGEXP_SUBSTR(text, 'phosphorus is [0-9]+'), 'phosphorus is ', '') AS UNSIGNED) AS phosphorus,
CAST(REPLACE(REGEXP_SUBSTR(text, 'potassium is [0-9]+'), 'potassium is ', '') AS UNSIGNED) AS potassium,
CAST(REPLACE(REGEXP_SUBSTR(text, 'temperature is around [0-9.]+'), 'temperature is around ', '') AS DECIMAL(10,4)) AS temperature,
CAST(REPLACE(REGEXP_SUBSTR(text, 'humidity [0-9.]+'), 'humidity ', '') AS DECIMAL(10,4)) AS humidity,
CAST(REPLACE(REGEXP_SUBSTR(text, 'pH should be around [0-9.]+'), 'pH should be around ', '') AS DECIMAL (10,4)) AS soil_pH,
CAST(REPLACE(REGEXP_SUBSTR(text, 'rainfall about [0-9.]+'), 'rainfall about ', '') AS DECIMAL (10,4)) AS rainfall_mm
FROM staging_crop_json
;


-- ====================================================
-- SECTION 2: Crop Yield: Database Setup and Staging
-- Original File: crop_yield.sql
-- ====================================================

CREATE TABLE staging_crop_yield_json (
id INT AUTO_INCREMENT PRIMARY KEY,
text VARCHAR(1000),
metadata JSON
);

CREATE TABLE clean_crop_yield AS
SELECT
id,
JSON_UNQUOTE(JSON_EXTRACT(metadata, '$.crop')) AS crop,
JSON_UNQUOTE(JSON_EXTRACT(metadata, '$.country')) AS country,
CAST(REPLACE(REGEXP_SUBSTR(text, 'average yield of [0-9.]+'), 'average yield of ', '') AS UNSIGNED) AS yield_hg_per_ha,
CAST(REPLACE(REGEXP_SUBSTR(text, 'average rainfall is [0-9.]+'), 'average rainfall is ', '') AS DECIMAL(7,2)) AS rainfall_mm_per_year,
CAST(REPLACE(REGEXP_SUBSTR(text, 'average temperature of [0-9.]+'), 'average temperature of ', '') AS DECIMAL(5,2)) AS temp_celsius,
CAST(REPLACE(REGEXP_SUBSTR(text, 'usage is approximately [0-9.]+'), 'usage is approximately ', '') AS DECIMAL(8,2)) AS pesticide_tonnes
FROM staging_crop_yield_json
;


-- ====================================================
-- SECTION 3: Fertilizer: Database Setup and Staging
-- Original File: fertilizer.sql
-- ====================================================

CREATE TABLE staging_fertilizer_json (
id INT AUTO_INCREMENT PRIMARY KEY,
text VARCHAR(1000),
metadata JSON
);

CREATE TABLE clean_fertilizer_data AS
SELECT
id,
JSON_UNQUOTE(JSON_EXTRACT(metadata, '$.crop')) AS crop,
JSON_UNQUOTE(JSON_EXTRACT(metadata, '$.soil')) AS soil,
JSON_UNQUOTE(JSON_EXTRACT(metadata, '$.fertilizer')) AS fertilizer,
CAST(REPLACE(REGEXP_SUBSTR(text, 'nitrogen level [0-9.]+'), 'nitrogen level ', '') AS UNSIGNED) AS nitrogen,
CAST(REPLACE(REGEXP_SUBSTR(text, 'phosphorus [0-9.]+'), 'phosphorus ', '') AS UNSIGNED) AS phosphorus,
CAST(REPLACE(REGEXP_SUBSTR(text, 'and potassium [0-9.]+'), 'and potassium ', '') AS UNSIGNED) AS potassium
FROM staging_fertilizer_json
;



