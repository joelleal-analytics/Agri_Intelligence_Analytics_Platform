USE crop_db;

-- ===================================================================
-- SECTION 1. Top 5 Highest Yielding Crops vs Their NPK Requirements
-- ===================================================================

SELECT
c.crop,
ROUND(AVG(y.yield_hg_per_ha), 2) AS yield_hg,
ROUND(AVG(f.nitrogen), 2) AS nitrogen_required,
ROUND(AVG(f.phosphorus), 2) AS phosphorus_required,
ROUND(AVG(f.potassium), 2) AS potassium_required
FROM dim_crop c
JOIN fact_crop_yield y
	ON c.crop_id = y.crop_id
JOIN fact_fertilizer f
	ON c.crop_id = f.crop_id
GROUP BY c.crop
ORDER BY yield_hg DESC
LIMIT 5
;


-- ==================================================
-- SECTION 2. High Nitrogen Fertilzier Optimization
-- ==================================================

SELECT
f.crop_id,
d.crop,
f.soil_type,
f.fertilizer_type,
f.nitrogen,
f.phosphorus,
f.potassium
FROM dim_crop d
JOIN fact_fertilizer f
	ON d.crop_id = f.crop_id
WHERE f.nitrogen > 20
ORDER BY f.nitrogen DESC
LIMIT 10
;


-- ==================================================
-- SECTION 3. Climate Resilience Analysis
-- ==================================================

SELECT
d.crop_id,
d.crop,
COUNT(y.yield_id) AS total_records,
ROUND(AVG(y.yield_hg_per_ha), 2) AS avg_yield_hg,
ROUND(AVG(y.rainfall_mm_per_year), 2) AS avg_rainfal_mm,
ROUND(AVG(y.temp_celsius), 2) AS avg_temp_celsius
FROM dim_crop d
JOIN fact_crop_yield y
	ON d.crop_id = y.crop_id
GROUP BY d.crop_id, d.crop
ORDER BY avg_yield_hg DESC
;
