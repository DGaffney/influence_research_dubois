load 'environment.rb'
credentials = TWITTER_CONFIG[:dgaff_1]
@cpc = Dataset.first_or_create(:name => "CPC Dataset")
@ndp = Dataset.first_or_create(:name => "NDP Dataset")
def store_to_dataset(tweet)
  if tweet.text.downcase.include?("#cpc") && tweet.text.downcase.include?("#ndp")
    [@cpc,@ndp].each do |dataset|
      user = User.new_from_raw(tweet)
      user.dataset_id = dataset.id
      user.tweets.first.dataset_id = dataset.id
      user.save
      user.tweets.first.save
    end
  elsif tweet.text.downcase.include?("#cpc")
    user = User.new_from_raw(tweet)
    user.dataset_id = @cpc.id
    user.tweets.first.dataset_id = @cpc.id
    user.save
    user.tweets.first.save
  elsif tweet.text.downcase.include?("#ndp")
    user = User.new_from_raw(tweet)
    user.dataset_id = @ndp.id
    user.tweets.first.dataset_id = @ndp.id
    user.save
    user.tweets.first.save
  end
end
s = Streamer.new(credentials.merge(:stream_type => "track", :stream_conditions => "#cpc,#ndp,#CPC,#NDP"))
s.stream do |tweet|
  print "."
  tweet = Hashie::Mash[tweet.attrs]
  store_to_dataset(tweet)
end