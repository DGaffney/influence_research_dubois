class UserResult
  include MongoMapper::Document
  key :klout_score
  key :kred_score
  key :twitter_id
end