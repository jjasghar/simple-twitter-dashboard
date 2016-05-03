require 'sinatra'
require 'twitter'
require 'yaml'

config = YAML.load_file('config.yml')

topics = [config['topics']]

set :bind, config['bind_address']

client = Twitter::REST::Client.new do |client_config|
  client_config.consumer_key = config['consumer_key']
  client_config.consumer_secret = config['consumer_secret']
end

get '/' do
  tweets = Hash.new
  client.search(topics.join(","), result_type: "recent").take(1).each do |tweet|
    tweets[tweet.id] = {
      name: tweet.user.name,
      author: tweet.user.screen_name,
      tweet: tweet.full_text,
      gravitar: tweet.user.profile_image_url,
      retweeted: tweet.retweet_count
    }

    tweets[tweet.id][:image] = tweet.media[0].media_uri.to_s if tweet.media[0]
  end


  erb :index, :locals => {
        :output_tweets => tweets,
        :topic => topics[0],
        :refresh => config['refresh']
      }
end

get '/twitter-simple.css' do
  File.read(File.join('twitter-simple.css'))
end
