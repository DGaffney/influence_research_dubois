load 'environment.rb'
# datasets = Dataset.all.select{|d| !["Buble", "Paisley"].include?(d.name) && !d.name.include?("DUPES") && !d.name.include?("Louisville") && !d.name.include?("Portland")}
# datasets.each do |d|
#   dataset = Dataset.new(:name => d.name+" Refined 1")
#   dataset.save!
# end

["CPC", "NDP"].each do |party|
  old_dataset = Dataset.first(:name => "#{party} Dataset")
  new_dataset = Dataset.first(:name => "#{party} Dataset Refined 1")
  old_users = User.all(:dataset_id => old_dataset.id);false
  old_users.each do |old_user|
    all_old_users = User.all(:dataset_id => old_dataset.id, :twitter_id => old_user.twitter_id)
    all_old_tweets = all_old_users.collect(&:tweets).flatten
    next if User.count(:dataset_id => new_dataset.id, :twitter_id => old_user.twitter_id) >= 1
    attributes = old_user.attributes
    attributes.delete("_id")
    attributes.delete("tweet_ids")
    attributes.delete("dataset_id")
    new_user = User.new(attributes.merge(:dataset_id => new_dataset.id))
    all_old_tweets.each do |old_tweet|
      attributes = old_tweet.attributes
      attributes.delete("_id")
      attributes.delete("place_id")
      attributes.delete("user_id")
      attributes.delete("hashtag_ids")
      attributes.delete("media_ids")
      attributes.delete("url_ids")
      attributes.delete("user_mention_ids")
      attributes.delete("geo_id")
      attributes.delete("coordinate_id")
      new_tweet = Tweet.new(attributes)
      new_tweet.user_id = new_user.id
      new_user.tweet_ids << new_tweet.id
      old_tweet.hashtags.each do |old_hashtag|
        attributes = old_hashtag.attributes
        attributes.delete("_id")
        attributes.delete("tweet_id")
        new_hashtag = Hashtag.new(attributes)
        new_tweet.hashtag_ids << new_hashtag.id
        new_hashtag.tweet_id = new_tweet.id
        new_hashtag.save!
      end
      old_tweet.urls.each do |old_url|
        attributes = old_url.attributes
        attributes.delete("_id")
        attributes.delete("tweet_id")
        new_url = Url.new(attributes)
        new_tweet.url_ids << new_url.id
        new_url.tweet_id = new_tweet.id
        new_url.save!
      end
      old_tweet.user_mentions.each do |old_user_mention|
        attributes = old_user_mention.attributes
        attributes.delete("_id")
        attributes.delete("tweet_id")
        new_user_mention = UserMention.new(attributes)
        new_tweet.user_mention_ids << new_user_mention.id
        new_user_mention.tweet_id = new_tweet.id
        new_user_mention.save!
      end
      old_tweet.media.each do |old_media|
        attributes = old_media.attributes
        attributes.delete("_id")
        attributes.delete("tweet_id")
        attributes.delete("size_ids")
        new_media = Medium.new(attributes)
        old_media.sizes.each do |old_size|
          attributes = old_size.attributes
          attributes.delete("_id")
          attributes.delete("media_id")
          new_size = Size.new(attributes)
          new_size.media_id = new_media.id
          new_media.size_ids << new_size.id
          new_size.save!
        end
        new_tweet.media_ids << new_media.id
        new_media.tweet_id = new_tweet.id
        new_media.save!
      end
      if old_tweet.place
        attributes = old_tweet.place.attributes
        attributes.delete("_id")
        attributes.delete("tweet_id")
        attributes.delete("bounding_box_id")
        attributes.delete("place_attribute_ids")
        new_place = Place.new(attributes)
        if old_tweet.place.bounding_box
          attributes = old_tweet.place.bounding_box.attributes
          attributes.delete("_id")
          attributes.delete("place_id")
          new_bounding_box = BoundingBox.new(attributes)
          new_bounding_box.place_id = new_place.id
          new_place.bounding_box_id = new_bounding_box.id
          new_bounding_box.save!
        end
        old_tweet.place.place_attributes.each do |old_place_attribute|
          attribute = old_place_attribute.attributes
          attributes.delete("_id")
          attributes.delete("place_id")
          new_place_attribute = PlaceAttribute.new(attributes)
          new_place_attribute.place_id = new_place.id
          new_place.place_attribute_ids << new_place_attribute.id
          new_place_attribute.save!
        end
      end
      if old_tweet.geo
        attributes = old_tweet.geo.attributes
        attributes.delete("_id")
        attributes.delete("tweet_id")
        new_geo = Geo.new(attributes)
        new_geo.tweet_id = new_tweet.id
        new_tweet.geo_id = new_geo.id
        new_geo.save!
      end
      new_tweet.save!
      print "."
    end
    new_user.save!
    print "|"
  end
end
