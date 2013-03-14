# encoding: UTF-8
load 'environment.rb'
credentials = TWITTER_CONFIG[:dgaff_lb]
ffu = FollowersForUsers.new(credentials.merge(:screen_names => ["michaelbuble", "BradPaisley"]))
results = ffu.grab_followers
@buble = Dataset.new(:name => "Bublé")
@paisley = Dataset.new(:name => "Paisley")
results.each_pair do |celebrity_data, fans|
  celebrity = User.new_from_raw(celebrity_data)
  if celebrity.screen_name == "michaelbuble"
    fans.each do |fan|
      user = User.new_from_raw(fan)
      user.dataset_id = @buble.id
      user.tweets.first.dataset_id = @buble.id
      user.save
      user.tweets.first.save
    end
  elsif celebrity.screen_name == "BradPaisley"
    fans.each do |fan|
      user = User.new_from_raw(fan)
      user.dataset_id = @paisley.id
      user.tweets.first.dataset_id = @paisley.id
      user.save
      user.tweets.first.save
    end
  end
end