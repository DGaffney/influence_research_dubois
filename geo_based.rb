load 'environment.rb'
credentials = TWITTER_CONFIG[:dgaff_lb]
@louisville = Dataset.first_or_create(:name => "Louisville (-85.865,38.111,-85.496,38.351)")
@portland = Dataset.first_or_create(:name => "Portland (-122.785,45.335,-122.542,45.634)")
@louisville_centroid = [-85.865, 38.111, -85.496, 38.351].centroid
@portland_centroid = [-122.785, 45.335, -122.542, 45.634].centroid
def store_to_dataset(tweet)
 tweet_lon = (tweet.coordinates && tweet.coordinates.coordinates && tweet.coordinates.coordinates.first) || (tweet.geo && tweet.geo.coordinates && tweet.geo.coordinates.last) || (tweet.place && tweet.place.bounding_box && tweet.place.bounding_box.coordinates && tweet.place.bounding_box.coordinates.first && tweet.place.bounding_box.coordinates.first.collect(&:first).average)
 tweet_lat = (tweet.coordinates && tweet.coordinates.coordinates && tweet.coordinates.coordinates.last) || (tweet.geo && tweet.geo.coordinates && tweet.geo.coordinates.first) || (tweet.place && tweet.place.bounding_box && tweet.place.bounding_box.coordinates && tweet.place.bounding_box.coordinates.first && tweet.place.bounding_box.coordinates.first.collect(&:last).average)
 dist_louisville_lon = (@louisville_centroid.first-tweet_lon).abs
 dist_louisville_lat = (@louisville_centroid.last-tweet_lat).abs
 dist_portland_lon = (@portland_centroid.first-tweet_lon).abs
 dist_portland_lat = (@portland_centroid.last-tweet_lat).abs
 val_louisville = dist_louisville_lon+dist_louisville_lat
 val_portland = dist_portland_lon+dist_portland_lat
 if val_louisville < val_portland
   user = User.new_from_raw(tweet)
   user.dataset_id = @louisville.id
   user.tweets.first.dataset_id = @louisville.id
   user.save
   user.tweets.first.save   
 elsif val_louisville > val_portland
   user = User.new_from_raw(tweet)
   user.dataset_id = @portland.id
   user.tweets.first.dataset_id = @portland.id
   user.save
   user.tweets.first.save
 else
   raise "LOLWUT"
 end
end
s = Streamer.new(credentials.merge(:stream_type => "locations", :stream_conditions => "-85.865,38.111,-85.496,38.351,-122.785,45.335,-122.542,45.634"))
s.stream do |tweet|
  print "."
  tweet = Hashie::Mash[tweet.attrs]
  store_to_dataset(tweet)
end