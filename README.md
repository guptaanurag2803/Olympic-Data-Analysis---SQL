# Olympic Data Analysis with SQL

## Overview
This project focuses on analyzing Olympic data using SQL and PostgreSQL. The dataset used in this project was obtained from Kaggle, specifically from the "120 years of Olympic history: athletes and results" dataset by Heesoo37. The dataset comprises two CSV files: `athlete_events.csv` and `noc_regions.csv`, which contain information about athletes, their events, and the National Olympic Committees (NOCs) and regions they belong to.

## Dataset 
- **athlete_events.csv**: This file contains information about athletes, including their unique IDs, names, sex, age, height, weight, team, NOC, games they participated in, and the medals they won.
- **noc_regions.csv**: This file contains information about NOCs, including their unique IDs, names, and the regions they belong to.
(https://www.kaggle.com/datasets/heesoo37/120-years-of-olympic-history-athletes-and-results)

## SQL Queries
The analysis is conducted using SQL queries, leveraging various SQL functionalities such as subqueries, Common Table Expressions (CTEs), aggregate functions, and window functions. The solution file, named `Solution - Olympic Dataset.sql`, contains SQL queries used to answer 20 specific questions related to the Olympic dataset.

## Files
- **athlete_events.csv**: Contains the main dataset with athlete information.
- **noc_regions.csv**: Contains information about National Olympic Committees and their regions.
- **Solution - Olympic Dataset.sql**: This file contains SQL queries used for data analysis and to answer the provided questions.
- **Questions.pdf**: This document lists the 20 questions that were answered using SQL queries.

## Questions Answered
The SQL queries provided in `Solution - Olympic Dataset.sql` address various questions related to the Olympic dataset, covering topics such as athlete demographics, medal distributions, historical trends, and more. Refer to the `Questions.pdf` file for a detailed list of questions answered.

## Usage
To replicate the analysis or further explore the dataset using SQL:
1. Ensure that PostgreSQL is installed on your system.
2. Import the provided CSV files (`athlete_events.csv` and `noc_regions.csv`) into your PostgreSQL database.
3. Open the `Solution - Olympic Dataset.sql` file and execute the SQL queries in a PostgreSQL environment.
4. Review the results to gain insights into the Olympic dataset based on the provided questions.