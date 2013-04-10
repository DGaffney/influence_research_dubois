load 'environment.rb'
datasets = Dataset.all.select{|d| !["Buble", "Paisley"].include?(d.name) && !d.name.include?("DUPES") && !d.name.include?("Louisville") && !d.name.include?("Portland")}
dataset_ids = datasets.collect(&:id)
offset = 0
limit = 100
users = User.all(:dataset_id => dataset_ids, :limit => limit, :offset => offset)
while !users.empty?
  credentials = [{"screen_name"=>"DGaff", "oauth_token"=>"13731562-Zv0itQvq7HvjFV7xrlRjQnn4dKUUlFWnargtRfayO", "oauth_token_secret"=>"0GpYk7UgfUykXAYuU2lj2fxqY1n3qCqhf3XL4uygI"}, {"screen_name"=>"xolotl", "oauth_token"=>"3775651-AJYfqDxKzXfBZjAMHPXP1o5uTTE5ovOAI1jFKgogn0", "oauth_token_secret"=>"iBam8voDXoM3njo0ToB3NeWkPn6uGvn23MFRz97HY"}, {"screen_name"=>"parakweets", "oauth_token"=>"1002926077-f6meWAKtHPa7JxvFdtxXAcPPGgyLm93c81nyp1b", "oauth_token_secret"=>"wA39RGNgafmmvImZxRE832cQRkYnyAh33M2MNeqg"}, {"screen_name"=>"Mikalina", "oauth_token"=>"5383262-O8TUUHrvS4wpru8jsNGWUzg2cDkFx4Aomdqy0IiY", "oauth_token_secret"=>"CGbKSYRJdg4tHn4nrtVrgHP1SirpwmBqfmLFUbrJk"}, {"screen_name"=>"peat", "oauth_token"=>"3658721-3Rjpc7SPxvGOtmTXMvHWpy9Kl7l6TkG9FPifC9Jc2U", "oauth_token_secret"=>"i1gYq3u4doqvwV1cU4TnjCfkceR6LZCvvcsBG5aA"}, {"screen_name"=>"JuiceStream", "oauth_token"=>"132367224-uO0OaktoFqAO6LRJdlK7bJB6tp4QQJtj3bgM1EOf", "oauth_token_secret"=>"N2O4L2f93oFjaUBU9exGZQHFqSZYhc93oH7OpWz3E"}, {"screen_name"=>"BaconStream", "oauth_token"=>"131018323-KKRqf8y7wHXeM63QZVJt2WSAMWrYBT8HioztokQV", "oauth_token_secret"=>"B3VqudwRlDN1iBxYTXdNnKdNyWrscZV4D4BWt7JXU"}, {"screen_name"=>"MuffinStream", "oauth_token"=>"132551409-Tssa50HfrRZGcurSHvyhe3RxhS34ayPfTECiHNHX", "oauth_token_secret"=>"uaRN9ZczI8IDAAQ3oiyP0ZtfVevWnNG03t6PjYQjrE"}, {"screen_name"=>"140kit", "oauth_token"=>"148584489-r4mDEiZ7KVZWDCu160vWiLocUzxzXibsW6SPuqQt", "oauth_token_secret"=>"1y92IWU8eWFIMnTDnVn9e6XXrWHyNfC0cek6nBqiY"}]
  credential = Hashie::Mash[TWITTER_CONFIG[:dgaff_lb].merge(credentials.shuffle.first)]
  ffu = FollowersForUsers.new(credential.merge(:screen_names => users.collect(&:screen_name)))
  users.each do |user|
    ffu.friend_ids_for(user.screen_name)
    print "."
  end
  offset += limit
  users = User.all(:dataset_id => dataset_ids, :limit => limit, :offset => offset)
end
users = []
limit = 200
offset = 0
user_set = User.where(:dataset_id => dataset_ids).limit(limit).offset(offset)
while !user_set.empty?
  users << user_set
  offset += limit
  user_set = User.where(:dataset_id => dataset_ids).limit(limit).offset(offset)
  print "."
end
screen_names = screen_names.flatten.uniq;false
while true
  total = screen_names.length
  api_call_count = TwitterAPICall.count(:url => "/1.1/friends/ids.json", :params => screen_names.collect{|s| {"cursor" => -1, "screen_name" => s}})
  puts "#{total} total users, #{api_call_count} complete, #{total-api_call_count} remain (#{api_call_count/total.to_f}% complete.)"
end

screen_names.each_slice(100) do |screen_name_set|
  credentials = [{"screen_name"=>"DGaff", "oauth_token"=>"13731562-Zv0itQvq7HvjFV7xrlRjQnn4dKUUlFWnargtRfayO", "oauth_token_secret"=>"0GpYk7UgfUykXAYuU2lj2fxqY1n3qCqhf3XL4uygI"}, {"screen_name"=>"xolotl", "oauth_token"=>"3775651-AJYfqDxKzXfBZjAMHPXP1o5uTTE5ovOAI1jFKgogn0", "oauth_token_secret"=>"iBam8voDXoM3njo0ToB3NeWkPn6uGvn23MFRz97HY"}, {"screen_name"=>"parakweets", "oauth_token"=>"1002926077-f6meWAKtHPa7JxvFdtxXAcPPGgyLm93c81nyp1b", "oauth_token_secret"=>"wA39RGNgafmmvImZxRE832cQRkYnyAh33M2MNeqg"}, {"screen_name"=>"Mikalina", "oauth_token"=>"5383262-O8TUUHrvS4wpru8jsNGWUzg2cDkFx4Aomdqy0IiY", "oauth_token_secret"=>"CGbKSYRJdg4tHn4nrtVrgHP1SirpwmBqfmLFUbrJk"}, {"screen_name"=>"peat", "oauth_token"=>"3658721-3Rjpc7SPxvGOtmTXMvHWpy9Kl7l6TkG9FPifC9Jc2U", "oauth_token_secret"=>"i1gYq3u4doqvwV1cU4TnjCfkceR6LZCvvcsBG5aA"}, {"screen_name"=>"JuiceStream", "oauth_token"=>"132367224-uO0OaktoFqAO6LRJdlK7bJB6tp4QQJtj3bgM1EOf", "oauth_token_secret"=>"N2O4L2f93oFjaUBU9exGZQHFqSZYhc93oH7OpWz3E"}, {"screen_name"=>"BaconStream", "oauth_token"=>"131018323-KKRqf8y7wHXeM63QZVJt2WSAMWrYBT8HioztokQV", "oauth_token_secret"=>"B3VqudwRlDN1iBxYTXdNnKdNyWrscZV4D4BWt7JXU"}, {"screen_name"=>"MuffinStream", "oauth_token"=>"132551409-Tssa50HfrRZGcurSHvyhe3RxhS34ayPfTECiHNHX", "oauth_token_secret"=>"uaRN9ZczI8IDAAQ3oiyP0ZtfVevWnNG03t6PjYQjrE"}, {"screen_name"=>"140kit", "oauth_token"=>"148584489-r4mDEiZ7KVZWDCu160vWiLocUzxzXibsW6SPuqQt", "oauth_token_secret"=>"1y92IWU8eWFIMnTDnVn9e6XXrWHyNfC0cek6nBqiY"}]
  credential = Hashie::Mash[TWITTER_CONFIG[:dgaff_lb].merge(credentials.shuffle.first)]
  ffu = FollowersForUsers.new(credential.merge(:screen_names => screen_name_set))
  screen_name_set.each do |screen_name|
    ffu.friend_ids_for(screen_name)
    print "."
  end
end


users = User.all(:dataset_id => dataset_ids);false