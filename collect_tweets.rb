load 'environment.rb'
credentials = [{"screen_name"=>"DGaff", "oauth_token"=>"13731562-Zv0itQvq7HvjFV7xrlRjQnn4dKUUlFWnargtRfayO", "oauth_token_secret"=>"0GpYk7UgfUykXAYuU2lj2fxqY1n3qCqhf3XL4uygI"}, {"screen_name"=>"xolotl", "oauth_token"=>"3775651-AJYfqDxKzXfBZjAMHPXP1o5uTTE5ovOAI1jFKgogn0", "oauth_token_secret"=>"iBam8voDXoM3njo0ToB3NeWkPn6uGvn23MFRz97HY"}, {"screen_name"=>"parakweets", "oauth_token"=>"1002926077-f6meWAKtHPa7JxvFdtxXAcPPGgyLm93c81nyp1b", "oauth_token_secret"=>"wA39RGNgafmmvImZxRE832cQRkYnyAh33M2MNeqg"}, {"screen_name"=>"Mikalina", "oauth_token"=>"5383262-O8TUUHrvS4wpru8jsNGWUzg2cDkFx4Aomdqy0IiY", "oauth_token_secret"=>"CGbKSYRJdg4tHn4nrtVrgHP1SirpwmBqfmLFUbrJk"}, {"screen_name"=>"peat", "oauth_token"=>"3658721-3Rjpc7SPxvGOtmTXMvHWpy9Kl7l6TkG9FPifC9Jc2U", "oauth_token_secret"=>"i1gYq3u4doqvwV1cU4TnjCfkceR6LZCvvcsBG5aA"}, {"screen_name"=>"JuiceStream", "oauth_token"=>"132367224-uO0OaktoFqAO6LRJdlK7bJB6tp4QQJtj3bgM1EOf", "oauth_token_secret"=>"N2O4L2f93oFjaUBU9exGZQHFqSZYhc93oH7OpWz3E"}, {"screen_name"=>"BaconStream", "oauth_token"=>"131018323-KKRqf8y7wHXeM63QZVJt2WSAMWrYBT8HioztokQV", "oauth_token_secret"=>"B3VqudwRlDN1iBxYTXdNnKdNyWrscZV4D4BWt7JXU"}, {"screen_name"=>"MuffinStream", "oauth_token"=>"132551409-Tssa50HfrRZGcurSHvyhe3RxhS34ayPfTECiHNHX", "oauth_token_secret"=>"uaRN9ZczI8IDAAQ3oiyP0ZtfVevWnNG03t6PjYQjrE"}, {"screen_name"=>"140kit", "oauth_token"=>"148584489-r4mDEiZ7KVZWDCu160vWiLocUzxzXibsW6SPuqQt", "oauth_token_secret"=>"1y92IWU8eWFIMnTDnVn9e6XXrWHyNfC0cek6nBqiY"}]
["CPC", "NDP"].each do |party|
  dataset = Dataset.first(:name => "#{party} Dataset Refined 1")
  users = User.all(:dataset_id => dataset.id)
  users.each do |user|
    puts user.screen_name
    existing_tweet_ids = user.tweets.collect(&:twitter_id)
    client = Twitter::Client.new
    credentials_employed = credentials.shuffle.first
    client.oauth_token = credentials_employed["oauth_token"]
    client.oauth_token_secret = credentials_employed["oauth_token_secret"]
    begin
      raw_tweets = client.user_timeline(user.twitter_id, :count => 200)
    rescue Twitter::Error::NotFound
      raw_tweets = []
      puts "User gone!"
    rescue Twitter::Error::Unauthorized
      raw_twets = []
      puts "User private now!"
    rescue Twitter::Error::ClientError
      raw_tweets = []
      puts "Random error."
    end
    raw_tweets.each do |raw_tweet|
      if !existing_tweet_ids.include?(raw_tweet["id"])
        tweet = Tweet.new_from_raw(raw_tweet, user.id)
        user.tweet_ids << tweet.id
        print "."
      else
        print "!"
      end
    end
    user.save!
    print "|"
  end
<<<<<<< HEAD
end
=======
end
>>>>>>> c50cd60819977d28f821c3f3c66802df1375d0d2
