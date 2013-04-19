load 'environment.rb'
load 'array.rb'
require 'csv'
["CPC", "NDP"].each do |party|
  dataset = Dataset.first(:name => "#{party} Dataset Refined 1")
  users = User.all(:dataset_id => dataset.id)
  twitter_ids = users.collect(&:tweet_ids).flatten
  offset = 0
  user_mentions = UserMention.where(:fields => [:twitter_id], :tweet_id => twitter_ids, :twitter_id => users.collect(&:twitter_id))
  user_mention_counts = user_mentions.collect(&:twitter_id).flatten.counts
  file = CSV.open("data/csv/#{party.downcase}_mention_counts.csv", "w")
  file << ["Twitter ID", "Interaction count"]
  users.each do |user|
    user_result = UserResult.first(:twitter_id => user.twitter_id)
    mention_count = user_mention_counts[user.twitter_id] || 0
    user_result.mentions_in_dataset = mention_count
    file << [user.twitter_id, mention_count]
    user_result.save
  end
  file.close
end
