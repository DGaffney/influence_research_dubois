load 'environment.rb'
require 'csv'
["CPC", "NDP"].each do |party|
  dataset = Dataset.first(:name => "#{party} Dataset Refined 1")
  csv = CSV.open("data/csv/#{party.downcase}_users_typical_tweets.csv", "w")
  csv << ["Twitter ID", "Internal ID", "Text", "Screen Name", "URL", "Created At"]
  users = User.all(:dataset_id => dataset.id).shuffle.first(250)
  users.each do |user|
    user.tweets.sort_by(&:created_at).reverse.first(10).each do |tweet|
      csv << [tweet.twitter_id, tweet.id, tweet.text, user.screen_name, "http://twitter.com/#{tweet.user.screen_name}/status/#{tweet.twitter_id}", tweet.created_at]
    end
  end
  csv.close
end
