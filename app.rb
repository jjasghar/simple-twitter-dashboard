require 'sinatra'
require 'twitter'
require 'yaml'

config = YAML.load(ERB.new(File.read("config.yml")).result)

if config['follower']
  follower = config['follower'].split(",")
 else
   follower = "@AP,@BBCBreaking,@cnnbrk".split(",")
end

hashtag = config['hashtag']

set :bind, config['bind_address']

client = Twitter::REST::Client.new do |client_config|
  client_config.consumer_key = config['consumer_key']
  client_config.consumer_secret = config['consumer_secret']
end

get '/' do
  tweets = Hash.new
  if hashtag
    client.search(hashtag, result_type: "recent").take(1).each do |tweet|
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
          :topic => hashtag,
          :refresh => config['refresh']
        }

  else follower
    require 'pry'; binding.pry
    follower.each do |f|
      client.user_timeline(f)[0..0].each do |tweet|
        tweets[tweet.id] = {
          name: tweet.user.name,
          author: tweet.user.screen_name,
          tweet: tweet.full_text,
          gravitar: tweet.user.profile_image_url,
          retweeted: tweet.retweet_count
        }

        tweets[tweet.id][:image] = tweet.media[0].media_uri.to_s if tweet.media[0]
      end
    end

    # Randomly take from the storage file and display tweet.
    # add a live refresh on the divs every 10 seconds where the tweets
    # refresh every 3 seconds in the background
    erb :news, :locals => {
          :tweet => tweets.map { |k,v| v }.sample,
          :refresh => config['refresh']
        }

  end
end
