#!/usr/bin/env bash
#
# Get a random article from the past months from the New York Times.
# 
month_in_past=$(($1-1))
cache_dir="$HOME/.random-articles"
mkdir -p "$cache_dir"
temp_file=$(mktemp)
for i in $(seq 0 $month_in_past)
do
  api_month=$(date -v-"${i}"m +"%-m")
  api_year=$(date -v-"${i}"m +"%Y")
  last_modified_date=$(curl -s "https://api.nytimes.com/svc/archive/v1/${api_year}/${api_month}.json?api-key=$NYT_KEY" -I | grep "Last-Modified" | sed "s/Last-Modified: //g" | sed "s/[ ,:]/_/g"| tr -d '\n' | tr -d '\r') 
  cache_file="$cache_dir/$api_year.$api_month.$last_modified_date.json"
  if [ ! -f "$cache_file" ]
  then
    url="https://api.nytimes.com/svc/archive/v1/${api_year}/${api_month}.json?api-key=$NYT_KEY"
    curl -s "$url" | jq ".response.docs[].web_url" > "$cache_file"
  fi
  cat "$cache_file" >> "$temp_file"
done
article_count=$(wc -l < "$temp_file")
echo "Choosing among $article_count articles"
shuf -n1 "$temp_file"
rm "$temp_file"