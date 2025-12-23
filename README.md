# Brazilian E-Commerce Analytics – Olist Dataset

##  Project Overview

This project presents an end-to-end business analytics case study using the **Olist Brazilian E-Commerce dataset**. The analysis focuses on revenue growth, delivery performance, customer satisfaction, and retention. Insights are derived through SQL, Python-based exploratory data analysis, and visualized via dashboards, with the goal of demonstrating data-driven decision-making suitable for a professional analytics portfolio.


##  Business Questions

1. What factors are driving revenue growth over time?
2. Which months perform worst in terms of revenue, and why?
3. How can delivery performance be improved to enhance customer satisfaction and retention?


##  Tools & Technologies

* **SQL** – Data extraction, joins, aggregations, and performance analysis
* **Python** – Data cleaning, EDA, feature engineering, and modeling
* **Power BI** – Interactive dashboards and KPI monitoring
* **Libraries** – pandas, matplotlib, seaborn, scikit-learn


## Key Observations
ALL visualization are saved in outputs/visualizations 
### Revenue & Demand Trends

* Revenue demonstrates a **consistent upward trend** over time.
* Order volume and revenue peak during **spring and summer**.
* **Winter and autumn** show lower demand and reduced revenue.
* Monthly revenue patterns:

  * **March–August (3–8)**: ~$850,000 to $1,000,000+ per month
  * **September–February (9–2)**: ~$500,000 to $750,000 per month

### Delivery Performance

* **Average delivery time**: 12.02 days
* **Median delivery time**: 10.00 days
* **On-time deliveries**: 94%
* **Late deliveries**: ~6–7%

  * Late: 7.24%
  * Very late: 3.11%
* Most deliveries fall within **1–30 days**, with extreme outliers up to **209 days**.
* Delivery performance improved significantly over time:

  * Early 2016 showed high delivery delays
  * Continuous improvement followed
  * By 2018, late deliveries were nearly eliminated

### Geographic Performance

* States with the highest late-delivery rates (**15–20% late orders**):

  * AL, PA, PI, MA, SE, CE

### Product & Category Performance

* Highest-volume categories: **Furniture** and **Electronics**
* Top profit-generating categories:

  1. Watches & Gifts
  2. Health & Beauty
  3. Bed, Bath & Table

### Customer Reviews & Satisfaction

* **57% of customers** provided a 5-star review
* Faster delivery strongly correlates with higher review scores
* Late deliveries typically result in lower ratings
* Some long-delivery orders still received high scores, likely due to:

  * Remote customer locations
  * Accurate delivery time expectations

### Freight Cost Analysis

* Most freight charges are below **$150**
* Higher freight costs are associated with **shorter delivery times**
* Indicates a clear trade-off between delivery speed and logistics cost

### Customer Segmentation

* **At-risk customers**: ~17,500 (one-time buyers who did not return)
* **Loyal customers**: ~12,500 repeat buyers despite frequent late deliveries
* **New customers**: ~7,200 customers with 2–3 purchases but no continuation
* **Champion customers**: ~7,000 high-value, frequent purchasers

---

##  Key Insights

* Delivery speed is a critical driver of customer satisfaction and review scores
* Seasonality significantly impacts both demand and logistics efficiency
* Logistics improvements over time directly improved delivery reliability
* Persistent regional delivery issues suggest structural logistics constraints
* Increased freight spending can reduce delivery time but impacts margins
* A large at-risk customer segment represents a major retention opportunity
* Loyal customers tolerate delays, but sustained service issues may increase churn risk

---

##  Dashboards

* Revenue and seasonal trend analysis
* Delivery performance KPIs (on-time vs late)
* Geographic late-delivery heatmaps
* Customer segmentation and retention metrics

> *Dashboard screenshots and Power BI files can be found in the `/dashboards` directory.*

---

##  Recommendations

### Logistics & Operations

* Prioritize logistics optimization in high-delay states (AL, PA, PI, MA, SE, CE)
* Maintain investments that reduced late deliveries post-2016
* Implement automated alerts for extreme delivery-time outliers

### Customer Experience

* Set realistic delivery expectations, especially for remote regions
* Proactively notify customers about delays to reduce negative reviews

### Revenue & Seasonal Strategy

* Align inventory, staffing, and marketing with spring and summer demand peaks
* Introduce targeted campaigns to stimulate demand during low-revenue seasons

### Pricing & Freight Strategy

* Explore dynamic freight pricing based on delivery urgency and region
* Offer premium shipping options for high-value customers and orders

### Customer Retention

* Launch re-engagement campaigns targeting at-risk customers
* Reward loyal and champion customers with faster shipping or exclusive offers
* Monitor early customer behavior to improve new-customer retention

---

##  Conclusion

This analysis demonstrates how data-driven insights can improve revenue planning, logistics efficiency, and customer retention. By addressing regional delivery challenges, leveraging seasonality, and strengthening customer lifecycle strategies, Olist can continue to scale profitably while enhancing customer satisfaction.
