# BTC_workflow_automation
A workflow automation for scraping, formatting and visualising crypto price data in a linux environment.


# raw_data
This folder contains a script that fetches raw data from two different sources:
- Bitcoin price data (USD) using the coingecko API.
- A curl command that fetches Stock market prices from the Financial Times Website

# cron job
The script located in the raw_data folder is executed multiple times by using a cron job.

Cron job:


# transform_data
The data of both datasources is transformed to a CSV file by using a script.