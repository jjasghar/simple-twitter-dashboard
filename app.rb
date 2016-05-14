require 'sinatra'
require 'twitter'
require 'yaml'
require 'rqrcode'

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
    # these are pulled from here: http://www.rubydoc.info/gems/twitter/Twitter/Tweet
    tweets[tweet.id] = {
      name: tweet.user.name,
      author: tweet.user.screen_name,
      tweet: tweet.full_text,
      gravitar: tweet.user.profile_image_url,
      retweeted: tweet.retweet_count,
      posted: tweet.created_at,
      url: tweet.url
    }

    tweets[tweet.id][:image] = tweet.media[0].media_uri.to_s if tweet.media[0]

    @qr = RQRCode::QRCode.new(tweet.url.to_s)
  end


  erb :index, :locals => {
        :output_tweets => tweets,
        :topic => topics[0],
        :refresh => config['refresh'],
        :posted => config['posted'],
        :qr => config['qr']
      }
end

get '/twitter-simple.css' do
  File.read(File.join('twitter-simple.css'))
end
