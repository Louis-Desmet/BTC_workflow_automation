#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")"

# paths
pathData='../transform_data/data.csv'
md_file_path='filled_report.md'
pdf_file_path='report.pdf'
html_file_path='report.html'
template_md='template.md'
txt_file='output/statistics.txt'

# Read data from the txt
btc_mean=$(awk -F ': ' '/btcMean/{print $2}' "$txt_file" | xargs)
btc_max=$(awk -F ': ' '/btcMax/{print $2}' "$txt_file" | xargs)
btc_min=$(awk -F ': ' '/btcMin/{print $2}' "$txt_file" | xargs)

sp_mean=$(awk -F ': ' '/spMean/{print $2}' "$txt_file" | xargs)
sp_max=$(awk -F ': ' '/spMax/{print $2}' "$txt_file" | xargs)
sp_min=$(awk -F ': ' '/spMin/{print $2}' "$txt_file" | xargs)

hs_mean=$(awk -F ': ' '/hsMean/{print $2}' "$txt_file" | xargs)
hs_max=$(awk -F ': ' '/hsMax/{print $2}' "$txt_file" | xargs)
hs_min=$(awk -F ': ' '/hsMin/{print $2}' "$txt_file" | xargs)

# substitute values in md file
current_date=$(date "+%Y-%m-%d")
filled_template=$(sed "s/{date}/$current_date/;
                       s/{btc_mean}/$btc_mean/; s/{btc_max}/$btc_max/; s/{btc_min}/$btc_min/;
                       s/{sp_mean}/$sp_mean/; s/{sp_max}/$sp_max/; s/{sp_min}/$sp_min/;
                       s/{hs_mean}/$hs_mean/; s/{hs_max}/$hs_max/; s/{hs_min}/$hs_min/" "$template_md")

# save template to filled template
echo "$filled_template" > "$md_file_path"

# Generate PDF 
pandoc "$md_file_path" -o "$pdf_file_path"

# Generate webpage 
pandoc "$md_file_path" -o "$html_file_path"

# Generate ppt
pandoc "$md_file_path" -t pptx -o report.pptx

