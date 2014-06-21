cycledirections-scraper
=======================

A scrappy scraper script that looks up directions pages for Glasgow to see if they have cycling directions.

The idea behind how it works:

1. Grabs Glasgow related venues from the Google places API (usually returns 20 per search term)
2. Searches venue name   'directions'
3. The top search result for each venue is scraped to see if it mentions cycling/bikes/cycle and if it mentions walking/walk/car/bus/train
4. The name, website, address, and whether the direction terms were matched are stored into a CSV. There's also a column for whether an error occurred while try to grab this data.

====

The dataset is an example. This was built up from the following api searches:

- food in Glasgow
- shops in Glasgow
- gallery in Glasgow
- gyms in Glasgow
- bars in Glasgow
- colleges in Glasgow
- unversity in Glasgow
- library in Glasgow
- clinic in Glasgow
- hospital in Glasgow
- cinema in Glasgow
- community centres in Glasgow

====

As you can see from the data set, there are a few false positives, in terms of directions pages and in terms of pages with cycling directions. 

But good on you GFT and NHS Greater Glasgow and Clyde for providing cycling directions!

