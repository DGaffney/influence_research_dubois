load 'environment.rb'
require 'csv'
["CPC", "NDP"].each do |party|
  dataset = Dataset.first(:name => "#{party} Dataset Refined 1")
  users = User.all(:dataset_id => dataset.id)
  ten_percent= (users.count.to_f/10).to_i
  sample = users.shuffle[0..ten_percent]
  csv = CSV.open("data/csv/#{party.downcase}_tweets_random_10_percent.csv", "w")
  csv << ["id", "text", "description", "time_captured", "lang", "self-reported location"]
  sample.each do |user|
    t = Tweet.first(:id => user.tweet_ids.first)
    csv << [user.twitter_id, t.text, user.description, t.created_at, user.lang, user.location]
  end
  csv.close
end