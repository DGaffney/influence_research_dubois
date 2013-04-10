users[0..12].collect{|u| u.tweets}.each do |tweet_set|
  if tweet_set.collect(&:twitter_id).length != tweet_set.collect(&:twitter_id).uniq.length
end