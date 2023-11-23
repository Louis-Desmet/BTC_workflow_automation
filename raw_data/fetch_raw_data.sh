#!/bin/bash

# Directory for data files
DATA_DIR_BTC="BTC_RAW_DATA"
DATA_DIR_SP="S&P_RAW_DATA"
LOG_DIR="RAW_DATA_LOGS" 
mkdir -p "$DATA_DIR_BTC"
mkdir -p "$DATA_DIR_SP"
mkdir -p "$LOG_DIR" 

# API params for bitcoin
API_ENDPOINT="https://api.coingecko.com/api/v3/simple/price"
CURRENCY_IDS="bitcoin"
VS_CURRENCIES="usd"

# Filenames
TIMESTAMP=$(date "+%Y%m%d-%H%M%S")
FILENAME_DATA_BTC="dataBTC-${TIMESTAMP}.json"
FILENAME_DATA_SP="dataS&P-${TIMESTAMP}.html"
FILENAME_LOG="LOG-$(date "+%Y%m%d").log"

# Full paths for the new files
FULL_PATH_DATA_BTC="${DATA_DIR_BTC}/${FILENAME_DATA_BTC}"
FULL_PATH_DATA_SP="${DATA_DIR_SP}/${FILENAME_DATA_SP}"
FULL_PATH_LOG="${LOG_DIR}/${FILENAME_LOG}"

# log messages
log_message() {
    echo "$(date "+%Y-%m-%d %H:%M:%S") - $1" >> "$FULL_PATH_LOG"
}

# Fetch Bitcoin data
fetch_bitcoin_data() {
    local http_response=$(curl -s -o "$FULL_PATH_DATA_BTC" -w "%{http_code}" "${API_ENDPOINT}?ids=${CURRENCY_IDS}&vs_currencies=${VS_CURRENCIES}")
    if [ "$http_response" -ne 200 ]; then
        log_message "Error fetching Bitcoin data. HTTP status code: $http_response"
        rm "$FULL_PATH_DATA_BTC"
    else
        log_message "Successfully fetched Bitcoin data."
    fi
}

# Fetch stock data
fetch_sp_data() {
    curl -s 'https://markets.ft.com/data' | pup 'table.mod-ui-table:first-of-type tbody' > "$FULL_PATH_DATA_SP"
    if [ -s "$FULL_PATH_DATA_SP" ]; then
        log_message "Successfully fetched stock market data."
    else
        log_message "Error fetching stock market data."
    fi
}

# Execute functions
fetch_bitcoin_data
fetch_sp_data

# Notify the user
echo "Check ${FULL_PATH_LOG} for the log entry."
