# SQL-CodeX-Consumer-and-Market-Insights
This SQL project analyzes survey data from 10,000 respondents to extract consumer preferences and perceptions insights, supporting data-driven marketing decisions to strengthen CodeX’s market position.

##  Problem statement:
CodeX, a German beverage company, recently launched its energy drink in 10 Indian cities to enter the market. To boost brand awareness, market share, and product development, the marketing team surveyed 10,000 respondents. 

The challenge is to analyze this data for insights into consumer preferences and perceptions to guide data-driven marketing decisions and strengthen CodeX’s market position.

## Datasets and methodologies:
The dataset consists of 3 CSV files, including two-dimension tables and one fact table. The data types include int, varchar, and Enum. The dataset had 10k records.

MySQL was used for Data Analysis and Power BI was used for Data Visualization.

**1. Data Understanding:**
A database, codex_marketanalysis, and tables dim_cities, dim_respondents, and fact_survey_responses were created.

**2. Data Cleaning:**
CSV files are loaded into the tables and cleaned for inconsistencies to make sure the dataset is accurate for analysis.

**3. Data Modeling:**
Data Modeling is done by establishing relationships between the tables using foreign key constraints.

**4. Data Analysis:**
Data analysis was performed using SQL queries such as GROUP BY, CASE, JOIN, and aggregate functions.

**5. Uncovering Insights:**
Insights were uncovered through the analysis.

## Questions for Analysis:

**1. Demographic Insights**
   
a. Who prefers energy drinks more?  

b. Which age group prefers energy drinks more? 

c. Which age groups are most aware of our brand? 

**2. Consumer Preferences**
   
a. What are the preferred ingredients of energy drinks among respondents?

b. What packaging preferences do respondents have for energy drinks? 

**3. Competition Analysis**
   
a. Who are the current market leaders?

b. What are the primary reasons consumers prefer those brands over ours? 

**4. Marketing Channels and Brand Awareness**
   
a. Which marketing channels are most effective by city tier? 

**5. Brand Penetration**
   
a. What are the top reasons people in each city tier have not tried the product? 

b. Which cities do we need to focus more on? 

**6. Customer feedback**
   
a. Analyse brand perception by gender and age group.

**7. Purchase Behaviour**
   
a. Where do respondents prefer to purchase energy drinks?

b. What are the typical consumption situations for energy drinks among respondents? 

c. What is the price range preference by city and gender? 

**8. Product Development**
    
a. Which area of business should we focus more on our product development?

## Insights Uncovered:

Most consumers are males, while the 19-30 age group prefers energy drinks more and shows higher brand awareness.

39% prefer caffeine, 25% prefer vitamins, 40% prefer portable cans, and 30% prefer innovative bottle designs.  

Cola-Coka, Bepsi, and Gangster are the current market leaders and are being chosen because of brand reputation, and taste. CodeX stands at 5th position in the market.

Online and TV commercials are the two main channels contributing to 67% of the awareness among the sample size.

The top reasons people in each city tier haven’t tried the product are health concerns, non-availability, and brand unawareness. CodeX should focus more on tier 1 cities (Delhi, Mumbai, Hyderabad, Bangalore) and Pune.

The brand perception is neutral. The 19–30 age group stands out with the highest number of responses across all categories — positive, neutral, and negative. Similarly, males show the highest number of responses across all three categories—positive, neutral, and negative.

45% prefer supermarkets for purchasing energy drinks possibly due to ease of access or immediate availability and 25% opt for online retailers. 45% consume energy drinks during exercise/sports. 32% use them for studying/working late. 43% identified the ideal price range for energy drinks as 50–99.

Reduced sugar content and more natural ingredients can be immediate improvements that promote overall health.

## Recommendations:

- [x] CodeX should target ages 19-30, as they show higher brand awareness and more positive perceptions.
      
- [x] 25% of the sample didn’t try the product possibly due to health concerns, highlighting a preference for healthy drinks. The product should be improved with natural caffeine, vitamins, and reduced sugar.
      
- [x] Customers prefer other brands for reputation and taste. CodeX should focus on influencer marketing, consider a young cricketer like Shubman Gill as a brand ambassador, experiment with flavors to boost awareness, and taste and shift brand perception from neutral to positive.
      
- [x] Promote products through in-store ads and campaigns in supermarkets, and invest in SEO, SMS, and email marketing for online retailers especially in Tier 1 cities.
      
- [x] Design portable cans and innovative bottles to strengthen brand image, priced ideally at 50-99.

## Acknowledgements:
I offer my sincere thanks to Dhaval Patel sir, Hemanand Vadivel sir, and the Codebasics team for creating resume projects that help to solve real-time questions.












