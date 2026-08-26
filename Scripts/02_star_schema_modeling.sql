USE crop_db;

-- ==========================================
-- SECTION 1: Creating Dimension Table
-- ==========================================

CREATE TABLE dim_crop (
crop_id INT AUTO_INCREMENT PRIMARY KEY,
crop VARCHAR(100) UNIQUE NOT NULL
);


-- ==========================================
-- SECTION 2: Populating Dimension Table
-- ==========================================

INSERT IGNORE INTO dim_crop (crop)
SELECT DISTINCT LOWER(TRIM(crop))
FROM clean_crop_yield
UNION
SELECT DISTINCT LOWER(TRIM(crop))
FROM clean_fertilizer_data
;


-- ==============================================
-- SECTION 3: Creating Fact Table 1. Crop Yield
-- ==============================================

CREATE TABLE fact_crop_yield AS
SELECT
y.id AS yield_id,
c.crop_id,
y.crop,
y.country,
y.yield_hg_per_ha,
y.rainfall_mm_per_year,
y.temp_celsius,
y.pesticide_tonnes
FROM clean_crop_yield y
JOIN dim_crop c 
	ON LOWER(TRIM(y.crop)) = c.crop
;


-- ==============================================
-- SECTION 4: Creating Fact Table 2. Fertilizer
-- ==============================================

CREATE TABLE fact_fertilizer AS
SELECT
f.id AS fertilizer_id,
c.crop_id,
f.crop,
f.soil AS soil_type,
f.fertilizer AS fertilizer_type,
f.nitrogen,
f.phosphorus,
f.potassium
FROM clean_fertilizer_data f
JOIN dim_crop c
	ON LOWER(TRIM(f.crop)) = c.crop
;


-- ==============================================
-- SECTION 5: Testing Relational Model
-- ==============================================

SELECT
c.crop,
COUNT(DISTINCT y.yield_id) AS yield_record_count,
COUNT(DISTINCT f.fertilizer_id) AS fertilizer_record_count
FROM dim_crop c
LEFT JOIN fact_crop_yield y 
	ON c.crop_id = y.crop_id
LEFT JOIN fact_fertilizer f
	ON c.crop_id = f.crop_id
GROUP BY c.crop
LIMIT 10
;