-- 01_staging.sql
-- Conforms OWID and World Bank sources to a shared (iso_code, year) key

CREATE OR REPLACE TABLE stg_owid AS
SELECT
    cm."Code" AS iso_code,
    cm."Year" AS year,
    cm."Under-five mortality rate (selected)" AS child_mortality,
    mal."Incidence of malaria (per 1,000 population at risk)" AS malaria_incidence,
    imm."Diphtheria/tetanus/pertussis (DTP3)" AS immunisation_rate
FROM owid_child_mortality_raw cm
LEFT JOIN owid_malaria_raw mal ON cm."Code" = mal."Code" AND cm."Year" = mal."Year"
LEFT JOIN owid_immunisation_raw imm ON cm."Code" = imm."Code" AND cm."Year" = imm."Year"
WHERE cm."Code" IN ('GHA', 'NGA', 'SEN', 'CIV', 'BFA')
  AND cm."Year" BETWEEN 2000 AND 2022;

-- World Bank arrives in wide format (years as columns); unpivot then pivot indicators into columns
CREATE OR REPLACE TABLE wb_long AS
UNPIVOT worldbank_raw ON COLUMNS(* EXCLUDE (economy, series)) INTO NAME year_label VALUE value;

CREATE OR REPLACE TABLE stg_worldbank AS
SELECT
    economy AS iso_code,
    CAST(REPLACE(year_label, 'YR', '') AS INTEGER) AS year,
    MAX(CASE WHEN series = 'SH.XPD.CHEX.GD.ZS' THEN value END) AS health_spend_pct_gdp,
    MAX(CASE WHEN series = 'NY.GDP.PCAP.CD' THEN value END) AS gdp_per_capita,
    MAX(CASE WHEN series = 'SH.STA.BASS.ZS' THEN value END) AS sanitation_access
FROM wb_long
GROUP BY economy, year_label;

-- Data quality block
SELECT 'owid' AS source, COUNT(*) AS rows FROM stg_owid
UNION ALL
SELECT 'worldbank', COUNT(*) FROM stg_worldbank;

SELECT iso_code, year, COUNT(*) AS n
FROM stg_owid
GROUP BY iso_code, year
HAVING COUNT(*) > 1;

SELECT COUNT(*) AS null_keys
FROM stg_owid
WHERE iso_code IS NULL OR year IS NULL;
