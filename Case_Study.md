# E-Commerce Pipeline Project

A fictional e-commerce company, currently struggling with a high rate of incomplete orders, has approached me to conduct a comprehensive analysis of its customers, orders, and product reviews. The objective of this analysis is to identify key insights that can help the company strengthen its position and move toward becoming a major global player in the highly competitive online retail industry.

During my analysis, I transform raw transactional and customer data into actionable insights that drive data-informed decision-making across customer engagement, sales performance, and product strategy. Simulating an SQL → Excel → Power BI workflow, this project showcases a complete end-to-end analytics pipeline, demonstrating proficiency in essential business intelligence tools used to uncover everyday business insights.

---

## Business Problem

-Stakeholder: Executive Committee of the E-Commerce Company
-Key Question: What trends can be identified in the customer, product, and review data, and how can these insights be leveraged to optimize performance and position the business as a major player in the online retail market?
-Why Now?: After three years of operation, the company’s order volume and total revenue have begun to plateau, signaling a need for strategic intervention.
-Decision Impact: The decisions made at this stage will directly influence the financial stability of all stakeholders — from suppliers and warehouse staff to executives. Without decisive action, the business risks significant financial decline within the next year.

---

## Key Findings

- Electronics and apparel accounted for nearly half of all orders.
- 39% of all orders were either returned or cancelled resulted in profit losses of $3 million.
- Operating in 10 markets around the world, the companies top market by revenue was France.
- Platinum tier customers, the top 5% of clients by revenue, accounted for 25% of total revenue for the company.
- 60% of orders had customers buying at least 3 of the item showing the company was a good option for bulk ordering.
- Overall revenue peaked in Q3 of 2024 when the company had the most overall orders but the lowest revenue per order.
- Most products had a rating below 3 which highlights the need for newer and better products to be stocked.

---

## Data Sources

|Table|Notes|
|-------|-------|
|**Customer Table**|Customer ID, name, gender, age group, signup date and country|
|**Orders Table**|Order ID, quantity, unit price, order date, order status, payment method|
|**Products Table**|Product ID, product name, category|
|**Reviews Table**|Review ID, rating, review text|

**Data Processing Steps**

- Located an open source dataset on Kaggle that would suit the project I was looking to do.
- Loaded the raw CSV files into MySQL workbench and altered the tables to ensure data normalisation.
- Updated the data types and added primary and foreign keys to create the schema.
- Exported the updated files into Excel.
- Imported into Power BI and created datamodel.
- Created measures such as Net Revenue, Average Revenue per Customer and Incomplete Order Rate.

---

## Skills Demonstrated

**SQL**

- Creating a strong schema with primary and foreign keys 


