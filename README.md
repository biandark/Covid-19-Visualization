# Covid-19 Visualization
*A personal project of making a visualization about Covid-19 pandemic using Tableau and SQL for data exploration.* 

The Covid-19 pandemic is still the main focus of the government in each country. Each country has begun to implement efforts to deal with Covid-19 based on the existing situation, one of which is to start vaccinating. The problems that arise include:
- What is the development trend of the world Covid-19 case?
- Is the possibility of death for a person with Covid-19 high?
- Has each country vaccinated its citizens?

To answer the existing problems, Covid-19 data from https://ourworldindata.org/covid-deaths  were used and data exploration conduct using SQL. The dataset contains all data starting from the first case reported until May 2021. Before doing my exploration, I divided the dataset into 3 parts and changed the data type to facilitate analysis using python. The first dataset contains data related to case developments, patient deaths due to Covid-19, and the number of tests performed every day. The second dataset contains data related to vaccination, and the last dataset contains country-related data such as population, average age, gdp index, and so on. I include the python script that is used to perform the transformation in the project folder.

Furthermore, data exploration is carried out using SQL. At this stage, several operations such as joins, aggregate functions, and view creation are used. I did a query to get the total daily cases in the world to the cases in each country. In addition, it also looks at the development of the mortality rate every day, and adds new parameters such as the fatality rate and the prevalence rate. This parameter serves to determine the mortality rate and the likelihood of incidence of the entire population. I include the query used to explore data in the project folder.

The insights obtained are then visualized using the Tableau tools. The visualization used is a monitoring dashboard that shows global Covid-19 data and on each continent. From the dashboard, there is a trend pattern for the addition of new cases around the world. At the end of 2020 until now there tends to be a cycle pattern every 7 days. The mortality rate also shows an irregular trend pattern but almost follows the pattern of adding new cases. For detailed information on the dashboard, you can go to the link: https://public.tableau.com/app/profile/bianda.reyhan.kesuma6575/viz/covidworldwide/Covid-19dashboard
