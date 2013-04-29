load 'environment.rb'
["CPC", "NDP"].each do |party|
  puts party
  dataset = Dataset.first(:name => "#{party} Dataset Refined 1")
  ids = File.read("data/csv/#{party.downcase}_ids_eigen_removed.csv").split("\n").collect(&:to_i)
  user_ids = User.all(:dataset_id => dataset.id).collect{|u| u.id if ids.include?(u.twitter_id)}.compact
  puts Tweet.count(:user_id => user_ids)
end