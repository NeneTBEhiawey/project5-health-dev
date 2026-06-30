-- 03_transform.sql
-- Window functions: year-over-year change and within-year ranking

CREATE OR REPLACE TABLE panel_with_windows AS
SELECT
    iso_code,
    year,
    child_mortality,
    LAG(child_mortality) OVER (
        PARTITION BY iso_code ORDER BY year
    ) AS prior_year_mortality,
    child_mortality - LAG(child_mortality) OVER (
        PARTITION BY iso_code ORDER BY year
    ) AS yoy_change,
    RANK() OVER (
        PARTITION BY year ORDER BY child_mortality ASC
    ) AS rank_in_year
FROM panel_country_year;

-- CASE tiers
CREATE OR REPLACE TABLE panel_with_tiers AS
SELECT
    *,
    CASE
        WHEN yoy_change < 0 THEN 'Improving'
        WHEN yoy_change = 0 THEN 'Flat'
        WHEN yoy_change > 0 THEN 'Worsening'
        ELSE 'No prior data'
    END AS trend_tier
FROM panel_with_windows;
