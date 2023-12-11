#!/bin/bash
<<<<<<< HEAD

#Paths
PATH_BTC_DATA="../raw_data/BTC_RAW_DATA"
PATH_STOCK_DATA="../raw_data/STOCK_RAW_DATA/"

#loop btc files
for btcFile in "$PATH_BTC_DATA"/*
do
  # Extract the BTC price from each file
  btc_value=$(jq '.bitcoin.usd' "$btcFile")

  #get Timestamp
  filename=$(basename "$btcFile")
  timestamp=${filename:8:15}
  

  stockfile="${PATH_STOCK_DATA}dataS&P-${timestamp}.html"
  # Extracting S&P 500 value
  sp500_value=$(cat "$stockfile" | pup 'text{}' | grep -A8 'S&amp;P 500' | xargs | awk '{print $NF}')

  #Extracting hang seng
  hang_seng_value=$(cat "$stockfile" | pup 'text{}' | grep -A8 'Hang Seng' | xargs | awk '{print $NF}')

  output="${timestamp};${btc_value};${sp500_value};${hang_seng_value}"
  echo "${output}"

done






=======
set -euo pipefail

cd "$(dirname "$0")"

# Paths
PATH_BTC_DATA="../raw_data/BTC_RAW_DATA"
PATH_STOCK_DATA="../raw_data/STOCK_RAW_DATA/"
PATH_OUTPUT_FILE="./data.csv"

# Loop btc files
for btcFile in "$PATH_BTC_DATA"/*
do
  # Extract the BTC price 
  btc_value=$(jq '.bitcoin.usd' "$btcFile")

  # Get Timestamp
  filename=$(basename "$btcFile")
  timestamp=${filename:8:15}

  # Check timestamps
  if ! grep -q "$timestamp" "$PATH_OUTPUT_FILE"; then
    stockfile="${PATH_STOCK_DATA}dataS&P-${timestamp}.html"
    
    # Extracting S&P 500 
    sp500_value=$(cat "$stockfile" | pup 'text{}' | grep -A8 'S&amp;P 500' | xargs | awk '{print $NF}')
    sp500_value="${sp500_value//,}"
    sp500_value="${sp500_value/./,}"

    # Extracting Hang Seng 
    hang_seng_value=$(cat "$stockfile" | pup 'text{}' | grep -A8 'Hang Seng' | xargs | awk '{print $NF}')
    hang_seng_value="${hang_seng_value//,}"
    hang_seng_value="${hang_seng_value/./,}"

    # output string
    output="${timestamp};${btc_value};${sp500_value};${hang_seng_value}"
    
    # Append string to file
    echo "${output}" >> "$PATH_OUTPUT_FILE"
  fi
done

>>>>>>> master
