require 'pry'
load 'environment.rb'
credentials = TWITTER_CONFIG[:dgaff_lb]
ffu = FollowersForUsers.new(credentials.merge(:screen_names => ["BradPaisley"]))
@buble = Dataset.first_or_create(:name => "Buble")
@paisley = Dataset.first_or_create(:name => "Paisley")
ffu.grab_followers_iterative do |celebrity_data, fans|
  fan_id = fans && fans.first["id"]
  next if TwitterAPICall.first("params.user_id" => /#{fan_id}/)
  celebrity = User.new_from_raw(celebrity_data)
  if celebrity.screen_name == "michaelbuble"
    fans.each do |fan|
      next if fan.class == Hash || fan.class == Hashie::Mash
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
      begin
        next if User.first(:screen_name => fan["screen_name"])
        user = User.new_from_raw(fan)
        user.dataset_id = @paisley.id
        user.tweets.first.dataset_id = @paisley.id if !user.tweets.empty?
        user.save
        user.tweets.first.save if !user.tweets.empty?
      rescue MongoMapper::DocumentNotValid
        print "!"
      end
    end
  end
end
