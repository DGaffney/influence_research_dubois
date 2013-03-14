# encoding: UTF-8

require 'oii_twitter_goodies'
Dir[File.dirname(__FILE__) + '/model/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/extensions/*.rb'].each {|file| require file }
MongoMapper.connection = Mongo::Connection.new("127.0.0.1", 27017)
MongoMapper.database = "influence_test"
TWITTER_CONFIG = 
  {:dgaff_1 => {
    :consumer_key => "zOXQ1JhQjmrgQZtY2k60uw", 
    :consumer_secret => "qtECkYcBrFf1NuCoL8Nq0CyxyFy2QfjcpkW9ZuKqWY", 
    :oauth_token => "13731562-mmI3rOLgR8pCzcuklgFKAPgpGOVh3JAmIUlNqZM4M", 
    :oauth_token_secret => "AZmqNurBqygMkqywkweyUO5TA9u2frsufHXAyE7zJgc"
  }, :dgaff_lb => {
    :consumer_key => "K0PZpHcYCfHd6teKEJjbw", 
    :consumer_secret => "XUWd6l2hf1GyMbHoDiCsiXYfJ1W52OCbDHFO70TXw", 
    :oauth_token => "13731562-Zv0itQvq7HvjFV7xrlRjQnn4dKUUlFWnargtRfayO", 
    :oauth_token_secret => "0GpYk7UgfUykXAYuU2lj2fxqY1n3qCqhf3XL4uygI"
  }
}

