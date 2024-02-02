# Salary-Dataset-Analysis

![](mainpage.PNG)

## Introduction
It’s hard to get real-world information about what jobs pay. Online salary websites are often inaccurate, and people can get weird when you ask them directly.
So let’s take some of the mystery out of salaries. The data is a Salary Survey from _AskAManager.org_. It’s US-centric-ish but does allow for a range of country inputs.

## Understanding the dataset
- There are 17 variables
- 6 of the variables are free-form text entry, which always results in lots of data cleaning to be done!
- The dataset is “live” and constantly growing.
- When downloading the dataset, there’s also a “timestamp” variable (column A), so you can simulate a growing list by filtering data by longer and longer timespans if it’s no longer receiving any updates.

## Problem statement
1. Which industry pays the most?
2. How does salary increase given years of experience?
3. How do salaries compare for the same role in different locations?
4. How much do salaries differ by gender and years of experience?
5. How do factors like race and education level correlate with salary?
6. Is there a “sweet spot” total work experience vs years in the specific field?

## Skill/ concepts demonstrated
- Power BI
- RStudio
- Data Cleaning
- Buttons
- Modelling
- Navigation
- Data Manipulation
- Interactive Dashboard

## Modelling
Before gettings my hands into the data, I like to create a prototype of how the final dashboard should look like. This helps in navigating through the project. The data had a _country_ column so I instantly thought of integrating map in the dashboard. Users can filter the visuals by _country_.

![](dashboardmodel.jpg)

## Data cleaning in RStudio
![](datacleaning.PNG)
