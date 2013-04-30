load 'environment.rb'
dataset = Dataset.all[-2]
users = User.all(:dataset_id => dataset.id)
user_information = {}
users.each do |user|
  print "."
  user_information[user.twitter_id.to_s] = {:bio => user.description, :tweet_text => Tweet.first(:id => user.tweet_ids.first).text}
end

#now to CSV it.
require 'csv'
csv = CSV.open("data/csv/cpc_user_info.csv", "w")
csv << ["id", "bio", "latest_tweet_text"]
user_information.each_pair do |user_id, data|
  csv << [user_id, data[:bio], data[:tweet_text]]
end
csv.close