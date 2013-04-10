load 'environment.rb'
load 'gexf.rb'
credentials = [{"screen_name"=>"DGaff", "oauth_token"=>"13731562-Zv0itQvq7HvjFV7xrlRjQnn4dKUUlFWnargtRfayO", "oauth_token_secret"=>"0GpYk7UgfUykXAYuU2lj2fxqY1n3qCqhf3XL4uygI"}, {"screen_name"=>"xolotl", "oauth_token"=>"3775651-AJYfqDxKzXfBZjAMHPXP1o5uTTE5ovOAI1jFKgogn0", "oauth_token_secret"=>"iBam8voDXoM3njo0ToB3NeWkPn6uGvn23MFRz97HY"}, {"screen_name"=>"parakweets", "oauth_token"=>"1002926077-f6meWAKtHPa7JxvFdtxXAcPPGgyLm93c81nyp1b", "oauth_token_secret"=>"wA39RGNgafmmvImZxRE832cQRkYnyAh33M2MNeqg"}, {"screen_name"=>"Mikalina", "oauth_token"=>"5383262-O8TUUHrvS4wpru8jsNGWUzg2cDkFx4Aomdqy0IiY", "oauth_token_secret"=>"CGbKSYRJdg4tHn4nrtVrgHP1SirpwmBqfmLFUbrJk"}, {"screen_name"=>"peat", "oauth_token"=>"3658721-3Rjpc7SPxvGOtmTXMvHWpy9Kl7l6TkG9FPifC9Jc2U", "oauth_token_secret"=>"i1gYq3u4doqvwV1cU4TnjCfkceR6LZCvvcsBG5aA"}, {"screen_name"=>"JuiceStream", "oauth_token"=>"132367224-uO0OaktoFqAO6LRJdlK7bJB6tp4QQJtj3bgM1EOf", "oauth_token_secret"=>"N2O4L2f93oFjaUBU9exGZQHFqSZYhc93oH7OpWz3E"}, {"screen_name"=>"BaconStream", "oauth_token"=>"131018323-KKRqf8y7wHXeM63QZVJt2WSAMWrYBT8HioztokQV", "oauth_token_secret"=>"B3VqudwRlDN1iBxYTXdNnKdNyWrscZV4D4BWt7JXU"}, {"screen_name"=>"MuffinStream", "oauth_token"=>"132551409-Tssa50HfrRZGcurSHvyhe3RxhS34ayPfTECiHNHX", "oauth_token_secret"=>"uaRN9ZczI8IDAAQ3oiyP0ZtfVevWnNG03t6PjYQjrE"}, {"screen_name"=>"140kit", "oauth_token"=>"148584489-r4mDEiZ7KVZWDCu160vWiLocUzxzXibsW6SPuqQt", "oauth_token_secret"=>"1y92IWU8eWFIMnTDnVn9e6XXrWHyNfC0cek6nBqiY"}]
graphs = {}
["CPC", "NDP"].each do |party|
  graph_data = {:nodes => [], :edges => []}
  dataset = Dataset.first(:name => "#{party} Dataset Refined 1")
  users = User.all(:dataset_id => dataset.id)
  user_ids = users.collect(&:twitter_id)
  
  users.each do |user|
    user_result = UserResult.first(:twitter_id => user.twitter_id)
    klout_score = user_result.klout_score["score"] rescue nil
    klout_score_bucket = user_result.klout_score["bucket"] rescue nil
    kred_influence = user_result.kred_score["data"].first["influence"] rescue nil
    kred_outreach = user_result.kred_score["data"].first["outreach"] rescue nil
    node = {:id => user.twitter_id, :label => user.screen_name, :attributes => [
      {:for => "statuses_count", :value => user.statuses_count},
      {:for => "followers_count", :value => user.followers_count},
      {:for => "friends_count", :value => user.friends_count},
      {:for => "listed_count", :value => user.listed_count},
      {:for => "favourites_count", :value => user.favourites_count},
      {:for => "klout_score", :value => klout_score},
      {:for => "klout_score_bucket", :value => klout_score_bucket},
      {:for => "kred_influence", :value => kred_influence},
      {:for => "kred_outreach", :value => kred_outreach}
    ]}
    graph_data[:nodes] << node
    credential = Hashie::Mash[TWITTER_CONFIG[:dgaff_lb].merge(credentials.shuffle.first)]
    ffu = FollowersForUsers.new(credential.merge(:screen_names => users.collect(&:screen_name)))
    edges_to_generate = ffu.friend_ids_for(user.screen_name)&user_ids
    edges_to_generate.each do |target|
      graph_data[:edges] << {:source => user.twitter_id, :target => target}
    end
  end
  graphs[party] = graph_data
end
`mkdir -p graphs`
graphs.each_pair do |party, graph|
  f = File.open("graphs/#{party}.gexf", "w")
  #looks like {:node => {:static => [{:id => "statuses_count", :title => "Statuses Count", :type => "double"}]}}
  attribute_declarations = {:node => {:static => [
    {:id => "statuses_count", :title => "Statuses Count", :type => "double"},
    {:id => "followers_count", :title => "Followers Count", :type => "double"},
    {:id => "friends_count", :title => "Friends Count", :type => "double"},
    {:id => "listed_count", :title => "Listed Count", :type => "double"},
    {:id => "favourites_count", :title => "Favourites Count", :type => "double"},
    {:id => "klout_score", :title => "Klout Score", :type => "double"},
    {:id => "klout_score_bucket", :title => "Klout Score Bucket", :type => "string"},
    {:id => "kred_influence", :title => "Kred Influence", :type => "double"},
    {:id => "kred_outreach", :title => "Kred Outreach", :type => "double"}
    ]}
  }
  gexf = GEXF.new(f)
  opts = graph.merge({:attributes => attribute_declarations})
  gexf.write_all(opts)
end