load 'environment.rb'
require 'csv'
["CPC", "NDP"].each do |party|
  `mkdir -p data/csv`
  dataset = Dataset.first(:name => party+" Dataset Refined 1")
  users = User.all(:dataset_id => dataset.id)
  csv = CSV.open("data/csv/#{party.downcase}_tweets_hashtag.csv", "w")
  csv << ["Twitter ID", "Internal ID", "Text", "Screen Name", "URL"]
  all_hashtags = Hashtag.all(:tweet_id => users.collect(&:tweet_ids).flatten).select{|h| [party.upcase, party.downcase].include?(h.text)}
  tweet_ids = all_hashtags.collect(&:tweet_id).shuffle.first(500)
  tweets = Tweet.all(:id => tweet_ids)
  tweets.each do |tweet|
    csv << [tweet.twitter_id, tweet.id, tweet.text, tweet.user.screen_name, "http://twitter.com/#{tweet.user.screen_name}/status/#{tweet.twitter_id}"]
  end
  csv.close
  
  csv = CSV.open("data/csv/#{party.downcase}_users_typical_tweets.csv", "w")
  csv << ["Twitter ID", "Internal ID", "Text", "Screen Name", "URL"]
  sample_users = users.shuffle.first(20)
  sample_tweet_ids = sample_users.collect(&:tweet_ids).flatten
  sample_tweets = Tweet.all(:id => sample_tweet_ids)
  sample_tweets.each do |tweet|
    csv << [tweet.twitter_id, tweet.id, tweet.text, tweet.user.screen_name, "http://twitter.com/#{tweet.user.screen_name}/status/#{tweet.twitter_id}"]
  end
  csv.close
end
