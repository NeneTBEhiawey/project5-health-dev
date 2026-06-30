-- 02_panel.sql
-- Joins staged OWID and World Bank tables into the core country x year panel
-- Grain: one row per country per year

CREATE OR REPLACE TABLE panel_country_year AS
SELECT
    o.iso_code,
    o.year,
    o.child_mortality,
    o.malaria_incidence,
    o.immunisation_rate,
    w.health_spend_pct_gdp,
    w.gdp_per_capita,
    w.sanitation_access
FROM stg_owid o
JOIN stg_worldbank w
    ON o.iso_code = w.iso_code
    AND o.year = w.year;
