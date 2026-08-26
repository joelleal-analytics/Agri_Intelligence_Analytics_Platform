USE crop_db;

-- ==============================================
-- SECTION 1. Creating Executive Crop Summary
-- ==============================================

CREATE OR REPLACE VIEW vw_executive_crop_summary AS (
WITH yield_stats AS (
SELECT
crop_id,
ROUND(AVG(yield_hg_per_ha), 2) AS yield_hg,
ROUND(AVG(rainfall_mm_per_year), 2) AS rainfall_mm,
ROUND(AVG(temp_celsius), 2) AS temp_celsius
FROM fact_crop_yield
GROUP BY crop_id
), 
fertilizer AS (
SELECT
crop_id,
ROUND(AVG(nitrogen), 2) AS nitrogen_required,
ROUND(AVG(phosphorus), 2) AS phosphorus_required,
ROUND(AVG(potassium), 2) AS potassium_required
FROM fact_fertilizer
GROUP BY crop_id
)
SELECT
d.crop_id,
d.crop,
y.yield_hg,
y.rainfall_mm,
y.temp_celsius,
f.nitrogen_required,
f.phosphorus_required,
f.potassium_required
FROM dim_crop d
LEFT JOIN yield_stats y
	ON d.crop_id = y.crop_id
LEFT JOIN fertilizer f
	ON d.crop_id = f.crop_id
);


-- ==============================================
-- SECTION 2. Verifying Executive Crop Summary
-- ==============================================

SELECT * 
FROM vw_executive_crop_summary
;