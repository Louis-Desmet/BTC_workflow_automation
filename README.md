# data workflow
This folder contains a workflow automation for scraping, formatting and visualising crypto and stock price data in a linux environment. 
The workflow fetches data from the s&p500, Hang Seng and Bitcoin markets. Its purpose is to then compare the evolution of these prices.

This workflow has the following structure:  

.  
├── **data_analysis**  
│   ├── analysis.py  
│   ├── filled_report.md  
│   ├── *makeReport.sh*  
│   ├── output  
│   │   ├── graph.png  
│   │   └── statistics.txt  
│   ├── report.pdf  
│   └── template.md  
├── **raw_data**  
│   ├── BTC_RAW_DATA  
│   │   ├── ...  
│   ├── *fetch_raw_data.sh*  
│   ├── RAW_DATA_LOGS  
│   │   ├── ...  
│   └── STOCK_RAW_DATA  
│       ├── ...  
├── README.md  
├── run_workflow.sh  
└── **transform_data**  
    ├── data.csv  
    └── *transform_data.sh*  


There are three main directories: *raw_data, transform_data and data_analysis*  
Each directory contains a script that is essential for the workflow.  

### 1. raw_data directory
This folder contains the fetch_raw_data.sh script that fetches raw data from two different sources:
- Bitcoin price data (USD) using the coingecko API.
- By using a curl command that fetches Stock market prices from the Financial Times Website *https://markets.ft.com/data*

This folder also contains three subdirectories:  
- BTC_RAW_DATA: To store json files with btc prices
- STOCK_RAW_DATA: To store html files with S&P500 and Hang Seng prices.
- RAW_DATA_LOGS: To store log files containing info about the requests.

The *fetch_raw_data.sh* script fetches data from the datasources and stores the collected files in the appropriate directories.  
It does this by using a curl command. For the stock data, the script will also use a pup command to extract the correct HTML element with the data of interest.  
Each raw data file is stored using a timestamp in the file name.  


### 2. transform_data directory
This folder contains the *transform_data.sh script*.  
This script loops the files located in the BTC_RAW_DATA directory, it uses jq to extract the btc price.  
It will then check if there is already a line present in the data.csv file with the same timestamp (to avoid duplicates). After that, the script will extract the values of the stock price html files using a "pup" command.  

The result is a data.csv file in this folder that contains the essential data for the analysis.


### 3. data_analysis directory
This folder takes care of the analysis part of the workflow, it generates a pdf report with graphs.  
In this directory, there is a subdirectory called *output* which stores the graph (png) and statistic (txt) data files.  

The reason that a txt file is used is to not make the makeReport script dependant on the analysis.py script. In other words, to make the workflow more modular. 

Before the PDF report is generated, a python script called *analysis.py* is run. This script plots a graph using the panda and matplotlib libraries. It also calculates the mean, maximum, minimum and standard deviation of the btc and stock market prices.
The python script will save the graph in a png image and the statistics in a txt file, both located in the output folder.  

In this directory, we also find a markdown template which will later be filled in with actual data.  

The *makeReport.sh* script will read the data from the statistics.txt file using awk and fill it in the markdown template using sed.  
It then saves this filled in template under the name: *filled_report.md*  
After that the script will use pandoc to generate a nice looking PDF report.

### Global script
The whole workflow is automised using a global script called *run_workflow.sh* which runs the other 4 scripts in order.  
This scrip looks like this:  

```bash
#!/bin/bash
set -euo pipefail

#Globaal script om alle scripts te runnen

cd "$(dirname "$0")"

echo "Starting Data Workflow..."

echo "Fetching Raw Data..."
./raw_data/fetch_raw_data.sh

echo "Transforming Data..."
./transform_data/transform_data.sh

echo "Analyzing Data..."
(cd data_analysis && python3 analysis.py)

echo "Generating Report..."
./data_analysis/makeReport.sh

echo "Data Workflow Completed Successfully."
```  

### 4 Other info about the workflow

#### 4.1 cron job
The script located in the raw_data folder is executed multiple times by using a cron job.

The line of in the cronjob looks like this.

*0 * * * * cd /home/linuxmint/Linux_For_DS/datalinux-labs-2324-Louis-Desmet/data-workflow/raw_data/ && ./fetch_raw_data.sh*  

Data is fetched every hour.


#### 4.2 shell debugging 
Each script shell script has a shebang and after that the following line:  

set -euo pipefail:   

This line sets three shell options:
- e (errexit): Exit immediately if a command exits with a non-zero status.
- u (nounset): Treat unset variables as an error and exit immediately.
- o pipefail: The return value of a pipeline is the status of the last command to exit with a non-zero status, or zero if no command exited with a non-zero status.

All scripts have been checked using bash -n and shellcheck

In each bash script there is a line that looks like this:  
*cd "$(dirname "$0")"*  
This ensures that when the global script is run, all generated files will come in the correct folder.