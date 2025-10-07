# restaurant-database-project
This SQL project on restaurant management and ratings. It includes database creation, table design, sample data insertion, and advanced SQL queries using joins, subqueries, and aggregate functions. I built it to practice and demonstrate my database and SQL skills.

## 📌 Project Overview
This project is a database system built with SQL to help manage information about restaurants, consumers, cuisines, and ratings. It simulates a real-world restaurant review and recommendation system where users (consumers) can rate restaurants and express their food preferences. This system helps businesses understand customer tastes and improves dining recommendations. 

The goal is to practice real-world SQL problem solving and showcase skills relevant for *Data Analyst / Data Science roles*.

---

## 🗂 Repository Contents
- **RESTAURANT AND CONSUMER ANALYSIS.sql** → complete SQL script (DDL + queries).  
- **ER_Diagram.png** → Entity Relationship Diagram of the database.  
- **Project_Presentation.pptx** → presentation explaining schema, queries, and insights.  
- *Datasets (CSV)*  
- **README.md** → this file, documentation for the project.  

---

## 🛠 Database Schema
The database consists of 5 tables:

- Consumers table: Stores consumer demographics and preferences.
- Restaurants table: Contains restaurant details like location, price, and services.
- Restaurant-Cuisine table: Links restaurants to the cuisines they offer.
- Consumer Preferences table: Records each consumer's preferred cuisines.
- Ratings table: Stores consumer ratings for restaurants on various attributes.  

📌 ER Diagram included in this repo for visualization.  

---

## 🔍 Key SQL Features Demonstrated
✔ *DDL & DML* – creating and managing relational tables.  
✔ *Filtering & Aggregation* – WHERE, GROUP BY, HAVING, averages.  
✔ *Joins & Subqueries* – combining datasets and deriving insights.  
✔ *CTEs (Common Table Expressions)* – cleaner and reusable query logic.  
✔ *Window Functions* – ROW_NUMBER, RANK, LEAD, AVG OVER.  
✔ *Views* – reusable query definitions.  
✔ *Stored Procedures* – parameterized queries for business scenarios.  

---

## 📊 Sample Business Questions Solved
- List highly rated Mexican restaurants in each city.  
- Find consumers who prefer Mexican cuisine but haven’t rated highly-rated Mexican restaurants.  
- Identify students with low budgets and extract their top 3 preferred cuisines.  
- Compare consumer ratings against restaurant averages and flag performance (Above/At/Below Average).  
- Rank restaurant ratings within each city using window functions.  
- Retrieve restaurant ratings above a given threshold using stored procedures.  

---

## 🚀 How to Run the Project
1. Install *MySQL 8+* (or MariaDB).  
2. Create a database:  
   ```sql
   CREATE DATABASE PROJECT;
   USE PROJECT;
3. Copy and run the script from **RESTAURANT AND CONSUMER ANALYSIS.sql** into your SQL client (MySQL 8+ recommended).
4. Explore queries step by step:
   - *Section A:* Basic filters (WHERE)
   - *Section B:* Joins & Subqueries
   - *Section C:* Aggregations & Order of Execution (GROUP BY, HAVING)
   - *Section D:* Advanced SQL (CTEs, Window Functions, Views, Stored Procedures)
