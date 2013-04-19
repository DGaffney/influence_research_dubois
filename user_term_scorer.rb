load 'environment.rb'
require 'csv'
terms = %w{HOC GOC SenCA byelxn roft cdnleft p2ca QP}.collect(&:downcase)
["CPC", "NDP"].each do |party|
  dataset = Dataset.first(:name => "#{party} Dataset Refined 1")
  csv = CSV.open("data/csv/#{party.downcase}_users_term_scores.csv", "w")
  csv << ["Twitter ID", "Score", "Num Tweets", "Num tweets including at least one term"]
  users = User.all(:dataset_id => dataset.id)
  users.each do |user|
    score = 0
    num_positive_hit_tweets = 0
    num_tweets = user.tweets.count
    
    user.tweets.each do |tweet|
      tweet_terms = tweet.text.downcase.split(/\W/)&terms
      score += tweet_terms.count
      num_positive_hit_tweets += 1 if tweet_terms.length > 0
    end
    user_result = UserResult.first(:twitter_id => user.twitter_id)
    user_result.term_score = score
    user_result.save
    puts [user.twitter_id, score, num_tweets, num_positive_hit_tweets].inspect
    csv << [user.twitter_id, score, num_tweets, num_positive_hit_tweets]
  end
  csv.close
end
