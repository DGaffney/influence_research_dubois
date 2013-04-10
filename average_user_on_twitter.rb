load 'environment.rb'
credential = Hashie::Mash[TWITTER_CONFIG[:dgaff_lb].merge(credentials.shuffle.first)]
TOP_USER_ID = 1325522832
user_set = []
1.upto(100) do |user_lookup|
  retry_count = 0
  client = Twitter::Client.new(credential)
  rand_ids = []
  1.upto(100) do |rand_id|
    rand_ids << rand(TOP_USER_ID)
  end
  begin
    user_set << client.users(rand_ids)
  rescue
    retry if retry_count < 5
    retry_count+=1
  end
  print "."
end

user_information = {:statuses_count => [], :friends_count => [], :followers_count => [], :listed_count => [], :created_at => [], :lang => [], :default_profile => [], :utc_offset => [], :time_zone => []}
user_set.flatten.each do |user|
  user_information.keys.each do |k|
    user_information[k] << user[k]
  end
end;false
user_information[:statuses_count].all_stats
user_information[:friends_count].all_stats
user_information[:followers_count].all_stats
user_information[:listed_count].all_stats
user_information[:created_at].collect(&:to_i).all_stats

gg = {}
gz.each_pair.collect{|k,v| gg[k] = Time.at(v)}

gx = {}
gg.each_pair do |k,v|
  gx[k] = Time.at(v).hour
end