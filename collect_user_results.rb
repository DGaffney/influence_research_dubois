load 'environment.rb'
klout_api_key = "fgxwcdnu2gvqru47mc746wz5"
kred_application_id = "8ee05668"
kred_application_key = "b51d6393f6e10158a6647a95b18450e1"
["CPC", "NDP"].each do |party|
  dataset = Dataset.first(:name => "#{party} Dataset Refined 1")
  users = User.all(:dataset_id => dataset.id)
  users.each do |user|
    user_result = UserResult.first_or_create(:user_id => user.id)
    user_result.twitter_id = user.twitter_id
    klout_id = JSON.parse(open("http://api.klout.com/v2/identity.json/twitter?screenName=#{user.screen_name}&key=#{klout_api_key}").read)["id"] rescue nil
    user_result.klout_score = JSON.parse(open("http://api.klout.com/v2/user.json/#{klout_id}/score?key=#{klout_api_key}").read) rescue {}
    user_result.kred_score = JSON.parse(open("http://api.kred.com/kredscore?term=#{user.screen_name}&source=twitter&app_id=#{kred_application_id}&app_key=#{kred_application_key}").read) rescue {}
    user_result.save
    print "."
  end
end
