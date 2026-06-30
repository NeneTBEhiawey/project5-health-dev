-- 04_analysis.sql
-- Answers the three Analyse questions

-- Q1: Fastest improver, 2000 vs 2022, using FIRST_VALUE / LAST_VALUE
CREATE OR REPLACE TABLE mortality_change AS
SELECT DISTINCT
    iso_code,
    FIRST_VALUE(child_mortality) OVER (PARTITION BY iso_code ORDER BY year) AS mortality_2000,
    LAST_VALUE(child_mortality) OVER (
        PARTITION BY iso_code ORDER BY year
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS mortality_2022
FROM panel_country_year;

SELECT
    iso_code,
    mortality_2000,
    mortality_2022,
    mortality_2000 - mortality_2022 AS absolute_drop,
    ROUND(100.0 * (mortality_2000 - mortality_2022) / mortality_2000, 1) AS pct_drop,
    RANK() OVER (ORDER BY (mortality_2000 - mortality_2022) / mortality_2000 DESC) AS improvement_rank
FROM mortality_change
ORDER BY improvement_rank;

-- Q2: Correlation between predictors and child mortality
SELECT
    ROUND(CORR(health_spend_pct_gdp, child_mortality), 3) AS corr_spend_mortality,
    ROUND(CORR(gdp_per_capita, child_mortality), 3) AS corr_gdp_mortality,
    ROUND(CORR(sanitation_access, child_mortality), 3) AS corr_sanitation_mortality,
    ROUND(CORR(immunisation_rate, child_mortality), 3) AS corr_immunisation_mortality
FROM panel_country_year;

-- Q3: Ghana / Nigeria vs peers, 2022 snapshot
SELECT
    iso_code,
    child_mortality,
    immunisation_rate,
    sanitation_access,
    RANK() OVER (ORDER BY child_mortality ASC) AS mortality_rank_2022
FROM panel_country_year
WHERE year = 2022
ORDER BY mortality_rank_2022;
