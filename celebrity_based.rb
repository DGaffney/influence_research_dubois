load 'environment.rb'
credentials = TWITTER_CONFIG[:dgaff_lb]
ffu = FollowersForUsers.new(credentials.merge(:screen_names => ["michaelbuble", "BradPaisley"]))
@buble = Dataset.first_or_create(:name => "Buble")
@paisley = Dataset.first_or_create(:name => "Paisley")
ffu.grab_followers_iterative do |celebrity_data, fans|
  binding.pry
  celebrity = User.new_from_raw(celebrity_data)
  if celebrity.screen_name == "michaelbuble"
    fans.each do |fan|
      print "."
      user = User.new_from_raw(fan)
      user.dataset_id = @buble.id
      user.tweets.first.dataset_id = @buble.id if !user.tweets.empty?
      user.save
      user.tweets.first.save if !user.tweets.empty?
    end
  elsif celebrity.screen_name == "BradPaisley"
    fans.each do |fan|
      print ","
      user = User.new_from_raw(fan)
      user.dataset_id = @paisley.id
      user.tweets.first.dataset_id = @paisley.id if !user.tweets.empty?
      user.save
      user.tweets.first.save if !user.tweets.empty?
    end
  end
end