#!/bin/bash

# Script to fetch current Bitcoin price in USD 

# Directory for data files
DATA_DIR_BTC="BTC_RAW_DATA"
DATA_DIR_SP="S&P_RAW_DATA"
LOG_DIR="RAW_DATA_LOGS" 
mkdir -p "$DATA_DIR_BTC"
mkdir -p "$DATA_DIR_SP"
mkdir -p "$LOG_DIR" 

# API for bitcoin
API_ENDPOINT="https://api.coingecko.com/api/v3/simple/price"
CURRENCY_IDS="bitcoin"
VS_CURRENCIES="usd"

# Filenames (common timestamp for both BTC and S&P data)
TIMESTAMP=$(date "+%Y%m%d-%H%M%S")
FILENAME_DATA_BTC="dataBTC-${TIMESTAMP}.json"
FILENAME_DATA_SP="dataS&P-${TIMESTAMP}.html"
FILENAME_LOG="LOG-$(date "+%Y%m%d").log"

# Full paths for the new files
FULL_PATH_DATA_BTC="${DATA_DIR_BTC}/${FILENAME_DATA_BTC}"
FULL_PATH_DATA_SP="${DATA_DIR_SP}/${FILENAME_DATA_SP}"
FULL_PATH_LOG="${LOG_DIR}/${FILENAME_LOG}"

# fetch btc dta
HTTP_RESPONSE=$(curl -s -o "$FULL_PATH_DATA_BTC" -w "%{http_code}" "${API_ENDPOINT}?ids=${CURRENCY_IDS}&vs_currencies=${VS_CURRENCIES}")

#Check the response
if [ "$HTTP_RESPONSE" -ne 200 ]; then
    echo "$(date "+%Y-%m-%d %H:%M:%S") - Error fetching Bitcoin data. HTTP status code: $HTTP_RESPONSE" >> "$FULL_PATH_LOG"
    rm "$FULL_PATH_DATA_BTC"
else
    echo "$(date "+%Y-%m-%d %H:%M:%S") - Successfully fetched Bitcoin data." >> "$FULL_PATH_LOG"
fi



# Fetch S&P 500 data
curl -s 'https://markets.ft.com/data' | pup 'table.mod-ui-table:first-of-type tbody' > "$FULL_PATH_DATA_SP"

# Check if S&P data was successfully fetched
if [ -s "$FULL_PATH_DATA_SP" ]; then
    echo "$(date "+%Y-%m-%d %H:%M:%S") - Successfully fetched stock market data." >> "$FULL_PATH_LOG"
else
    echo "$(date "+%Y-%m-%d %H:%M:%S") - Error fetching stock market data data." >> "$FULL_PATH_LOG"
fi

# Notify the user
echo "Check ${FULL_PATH_LOG} for the log entry."
