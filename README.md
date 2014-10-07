## Google Trends Collector

Requires Firefox.

Installation (it's a private gem):

```
 gem install google_trends_collector
```

Example:
```ruby
  query = 'iphone'
  GoogleTrendsCollector.new.import(query) # => returns hash of values and dates as keys
```