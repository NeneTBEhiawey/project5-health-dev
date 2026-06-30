Project 5: Health and Development, West Africa
Business question
Has health in Ghana, Nigeria, and peer West African countries genuinely improved since 2000, and does health spending explain the improvement?
Data sources
Our World in Data (child mortality, malaria incidence, immunisation coverage) joined with World Bank indicators (health spend % GDP, GDP per capita, sanitation access), covering Ghana, Nigeria, Senegal, Côte d'Ivoire, and Burkina Faso, 2000-2022.
Pipeline
Extract (OWID + World Bank API) -> Load (DuckDB) -> Model (country x year panel) -> Transform (SQL staging, joins, window functions) -> Analyse (SQL + Python) -> Predict (linear regression) -> Dashboard (Looker Studio) -> Repo.
Key findings
All five countries reduced child mortality substantially between 2000-2022. Senegal improved fastest (68.9% reduction), followed by Ghana (61.4%). Nigeria improved slowest (33.7%) and remains highest in absolute terms (11.75 per 1,000 in 2022, vs. Ghana's 3.86).
Immunisation coverage is the strongest correlate of lower child mortality (r = -0.72), markedly stronger than health spending as % of GDP (r = 0.01). Nigeria's comparatively low immunisation rate (59% vs. 91-99% for peers) likely explains much of its lagging position.
A four-variable regression (spend, GDP/capita, sanitation, immunisation) explains 79% of the variation in child mortality across the panel (R-squared = 0.786), though as a correlation-based model on five countries, it should not be read causally.
Recommendation
Policy and donor attention focused on immunisation coverage, not aggregate health spending, appears better targeted for closing the West African child mortality gap, particularly in Nigeria, where the immunisation shortfall is the most distinctive feature relative to its peers.
Repo structure
See /sql, /notebooks, /dashboard, /docs/data_dictionary.md
Dashboard
[Paste your Looker Studio shareable link here]
