# Random Articles

This is my quick and dirty attempt to discover new and unknown things after reading [Where good ideas come from](https://www.goodreads.com/book/show/8034188-where-good-ideas-come-from).


## The New York Times
This script gets you random articles from the New York Times, looking back a specified number of months. The script caches responses under `$HOME/.random-articles`. You can get your API key [here](https://developer.nytimes.com/)
.
### Usage
```bash
export NYT_KEY=<your API key>
nyt.sh <no_of_months>
```

### Dependecies
- [curl](https://curl.se/)
- [jq](https://stedolan.github.io/jq/)