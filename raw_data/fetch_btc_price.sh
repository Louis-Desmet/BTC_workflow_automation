#!/bin/bash

# Script to fetch current Bitcoin price in USD

#Create a directory for data files if it doesn't already exist
DATA_DIR="BTC_RAW_DATA"
mkdir -p "$DATA_DIR"

# API Endpoint for fetching Bitcoin prices
API_ENDPOINT="https://api.coingecko.com/api/v3/simple/price"

# Currency IDs and vs_currencies query parameters
CURRENCY_IDS="bitcoin"
VS_CURRENCIES="usd"

# Generate a filename with date and time
FILENAME="dataBTC-$(date "+%Y%m%d-%H%M%S").json"

# Full path for the new file
FULL_PATH="${DATA_DIR}/${FILENAME}"

# Fetch the current price of Bitcoin in USD
RESPONSE=$(curl -s "${API_ENDPOINT}?ids=${CURRENCY_IDS}&vs_currencies=${VS_CURRENCIES}")

# Save the response in a new JSON file
echo $RESPONSE > "$FULL_PATH"

# Notify the user
echo "Saved new data to ${FULL_PATH}"
