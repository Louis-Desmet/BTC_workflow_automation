#!/bin/bash

# Script to fetch current Bitcoin price in USD 

# Directory for data files
DATA_DIR="BTC_RAW_DATA"
LOG_DIR="BTC_LOGS" 
mkdir -p "$DATA_DIR"
mkdir -p "$LOG_DIR" 

# API
API_ENDPOINT="https://api.coingecko.com/api/v3/simple/price"

#params
CURRENCY_IDS="bitcoin"
VS_CURRENCIES="usd"

#filenames
FILENAME_DATA="dataBTC-$(date "+%Y%m%d-%H%M%S").json"
FILENAME_LOG="BTC-$(date "+%Y%m%d").log"

# Full paths for the new files
FULL_PATH_DATA="${DATA_DIR}/${FILENAME_DATA}"
FULL_PATH_LOG="${LOG_DIR}/${FILENAME_LOG}"

# send request
HTTP_RESPONSE=$(curl -s -o "$FULL_PATH_DATA" -w "%{http_code}" "${API_ENDPOINT}?ids=${CURRENCY_IDS}&vs_currencies=${VS_CURRENCIES}")


#Check the response
if [ "$HTTP_RESPONSE" -ne 200 ]; then
    # If the HTTP status is not 200, log the error
    echo "$(date "+%Y-%m-%d %H:%M:%S") - Error fetching Bitcoin data. HTTP status code: $HTTP_RESPONSE" >> "$FULL_PATH_LOG"
    
    rm "$FULL_PATH_DATA"
else
    echo "$(date "+%Y-%m-%d %H:%M:%S") - Successfully fetched Bitcoin data." >> "$FULL_PATH_LOG"
fi

# Notify the user
echo "Check ${FULL_PATH_LOG} for the log entry."
