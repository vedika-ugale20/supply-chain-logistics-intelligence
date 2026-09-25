# Supply Chain & Logistics Intelligence System

An end-to-end Supply Chain & Logistics Intelligence System built using data analytics, SQL, statistical analysis, demand forecasting, machine learning, and Power BI.

## Project Overview

This project analyzes supply-chain operations to identify sales patterns, regional performance, inventory demand, shipping inefficiencies, delivery risks, and demand trends.

The system follows the workflow:

Raw Data → Data Cleaning → SQL Analysis → EDA → KPI Engineering → Inventory Analytics → Logistics Analytics → Forecasting → Machine Learning → Power BI

## Business Objectives

- Analyze sales, orders, and product performance
- Monitor regional revenue and logistics performance
- Measure delivery and shipping performance
- Identify fast and slow-moving products
- Analyze demand variability and replenishment priorities
- Forecast future demand
- Predict late-delivery risk using machine learning
- Provide management insights through an interactive Power BI dashboard

## Dataset

The project uses the DataCo Smart Supply Chain dataset containing order, customer, product, sales, shipping, delivery, and geographical information.

Dataset source:

https://www.kaggle.com/datasets/shashwatwork/dataco-smart-supply-chain-for-big-data-analysis

## Technologies Used

- Python
- Pandas
- NumPy
- Matplotlib
- Seaborn
- Scikit-learn
- Statsmodels
- SQL
- SQLite
- Power BI
- Google Colab
- GitHub

## Analytics Performed

### KPI Analysis

Key metrics include:

- Total Revenue
- Total Orders
- Total Units Sold
- Average Order Value
- Average Delivery Time
- On-Time Delivery Rate
- Late Delivery Rate

### SQL Analysis

The project includes operational and management queries for:

- Revenue and order analysis
- Product and category performance
- Regional performance
- Shipping-mode analysis
- Delivery performance
- Ranking and aggregation analysis

### Inventory Analytics

Products are analyzed using:

- Average monthly demand
- Demand variability
- Demand classification
- Fast/medium/slow movers
- Replenishment priority

### Demand Forecasting

Demand forecasting includes:

- Time-series aggregation
- Naive baseline forecasting
- Holt-Winters Exponential Smoothing
- MAE and RMSE evaluation
- Actual vs forecast visualization

### Machine Learning

Late-delivery prediction was evaluated using:

- Logistic Regression
- Random Forest
- Gradient Boosting

Evaluation metrics include:

- Accuracy
- Precision
- Recall
- F1-score
- ROC-AUC
- Confusion Matrix

Gradient Boosting achieved the highest F1-score among the evaluated models.

## Power BI Dashboard

The Power BI dashboard contains three report pages:

### Executive Control Tower
- Revenue
- Orders
- Units Sold
- Average Order Value
- On-Time Delivery Rate
- Demand Forecast

### Sales & Product Intelligence
- Revenue by Region
- Revenue by Product

### Operations & ML Analysis
- Late Delivery Rate by Shipping Mode
- Average Delivery Days by Shipping Mode
- ML Model F1 Score Comparison
- Product Demand Analysis

## Project Structure

```text
supply-chain-logistics-intelligence/
│
├── Supply_Chain_Logistics_Intelligence.ipynb
├── README.md
├── LICENSE
└── .gitignore
Author

Vedika Ugale

B.Tech Computer Science & Engineering (Artificial Intelligence)
