import numpy as py
import pandas as pd
import matplotlib.pyplot as plt


pathData = '../transform_data/data.csv'
output_file_path = 'output/graph.png'

# data inlezen
df = pd.read_csv(pathData, delimiter=';', decimal=',')
df['timestamp'] = pd.to_datetime(df['timestamp'], format='%Y%m%d-%H%M%S')

plt.figure(figsize=(12, 8))

# BTC Prices
plt.subplot(3, 1, 1)
plt.plot(df['timestamp'], df['BTC'], label='BTC', color='orange')
plt.title('BTC Prices')
plt.ylabel('Price')
plt.grid(True)

# S&P Prices
plt.subplot(3, 1, 2)
plt.plot(df['timestamp'], df['S&P'], label='S&P 500', color='red')
plt.title('S&P 500 Prices')
plt.ylabel('Price')
plt.grid(True)

# HS Prices
plt.subplot(3, 1, 3)
plt.plot(df['timestamp'], df['HS'], label='Hang Seng', color='green')
plt.title('Hang Seng Prices')
plt.ylabel('Price')
plt.xlabel('Timestamp')
plt.grid(True)

# toon grafieken
plt.tight_layout()
plt.savefig(output_file_path, format='png')
#plt.show()


# Statistieken
btc_mean = df['BTC'].mean()
btc_max = df['BTC'].max()
btc_min = df['BTC'].min()
btc_std = df['BTC'].std()

sp_mean = df['S&P'].mean()
sp_max = df['S&P'].max()
sp_min = df['S&P'].min()
sp_std = df['S&P'].std()

hs_mean = df['HS'].mean()
hs_max = df['HS'].max()
hs_min = df['HS'].min()
hs_std = df['HS'].std()

# statistieken in output file steken
statistics_text = (
    f"btcMean: {btc_mean} \nbtcMax: {btc_max} \nbtcMin: {btc_min} \nbtcStdDev: {btc_std}\n"
    f"spMean: {sp_mean} \nspMax: {sp_max} \nspMin: {sp_min} \nspStdDev: {sp_std}\n"
    f"hsMean: {hs_mean} \nhsMax: {hs_max} \nhsMin: {hs_min} \nhsStdDev: {hs_std}\n"
)

#print(statistics_text)

with open('output/statistics.txt', 'w') as file:
    file.write(statistics_text)


