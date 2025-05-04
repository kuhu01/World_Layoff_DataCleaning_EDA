# 📉 World Layoff Data Analysis (2020–2025)

This project focuses on analyzing global layoff trends from 2020 to 2025 using the World Layoff dataset available on Kaggle. The entire analysis is performed using SQL for data cleaning, transformation, and exploratory analysis.

---

## 📂 Dataset

- **Source**: [Kaggle - Layoffs Dataset](https://www.kaggle.com/datasets/swaptr/layoffs-2022/data)
- **Period Covered**: 2020 to 2025
- **Key Features**:
  - Company
  - Location
  - Industry
  - Total Laid Off
  - Percentage Laid Off
  - Stage
  - Country
  - Funds Raised
  - Date

---

## 🧽 Data Cleaning (SQL-based)

Key cleaning steps included:

- Handling missing and NULL values
- Converting text-based percentages to numeric format
- Ensuring correct data types for `date`, `total_laid_off`, and `percentage_laid_off`
- Identifying and removing duplicate records using `GROUP BY` and `HAVING`
- Standardizing inconsistent values in columns 

---

## 📊 SQL-Based Exploratory Data Analysis

Highlights of the analysis:

- Year-wise trend of layoffs
- Top companies with highest layoffs per year using `DENSE_RANK()`
- Sector-wise layoff distribution
- Country-wise layoff summaries
- Identifying peaks and troughs in layoffs across years
- Use of SQL window functions (`DENSE_RANK`) and aggregation functions

---

## 💡 Key Insights

- Massive layoffs were observed during early 2020 and late 2022
- The tech sector dominated the layoff charts consistently
- Certain companies appear multiple times in the top layoffs by year

---

## 🛠️ Tools Used

- **SQL**: MySQL Workbench 
