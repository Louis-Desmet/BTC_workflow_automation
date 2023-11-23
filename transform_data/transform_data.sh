#!/bin/bash

#Paths
PATH_BTC_DATA="../raw_data/BTC_RAW_DATA"
PATH_STOCK_DATA="../raw_data/STOCK_RAW_DATA/"


#loop btc data files
for file in "$PATH_BTC_DATA"/*
do
  # Extract the BTC price
  btc_value=$(jq '.bitcoin.usd' "$file")
  # Perform operations on each file
  echo "$btc_value"
done



# Extracting S&P 500 value
sp500_value=$(cat "$html_file" | pup 'text{}' | grep -A8 'S&amp;P 500' | xargs | awk '{print $NF}')

# Extracting Hang Seng value
hang_seng_value=$(cat "$html_file" | pup 'text{}' | grep -A8 'Hang Seng' | xargs | awk '{print $NF}')


