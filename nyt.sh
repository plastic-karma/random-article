#!/usr/bin/env bash
#
# Get a random article from the past months from the New York Times.
# 
month_in_past=$(($1-1))
cache_dir="$HOME/.random-articles"
mkdir -p "$cache_dir"
temp_file=$(mktemp)

function retrieveArticles {
  curl -s "$1" | jq ".response.docs[].web_url" > "$2"
}

for i in $(seq 0 $month_in_past)
do
  api_month=$(date -v-"${i}"m +"%-m")
  api_year=$(date -v-"${i}"m +"%Y")
  cache_file="$cache_dir/$api_year.$api_month.json"
  url="https://api.nytimes.com/svc/archive/v1/${api_year}/${api_month}.json?api-key=$NYT_KEY"
  if [ ! -f "$cache_file" ]
  then
     retrieveArticles "$url" "$cache_file"
  # if cache is for current month, we check once every twelve hours for new data
  elif [ "$i" -eq 0 ] && [ "$(find "$cache_file" -mmin +720)" ]
  then
     retrieveArticles "$url" "$cache_file"
  fi
  cat "$cache_file" >> "$temp_file"
done
article_count=$(wc -l < "$temp_file")
echo "Choosing among $article_count articles"
shuf -n1 "$temp_file"
rm "$temp_file"