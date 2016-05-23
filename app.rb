require 'sinatra'
require 'twitter'
require 'yaml'
require 'yaml/store'

config = YAML.load_file('config.yml')

# i need to figure out a way to default the array to [","] so the .split will still work
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
    # create a place for the tweets to be stored
    @store = YAML::Store.new 'tweets.yml'

    # create a per follower tweet in the storage file
    @store.transaction do
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
    end

    # Randomly take from the storage file and display tweet.
    # add a live refresh on the divs every 10 seconds where the tweets
    # refresh every 3 seconds in the background
    erb :news, :locals => {
          :output_tweets => tweets,
          :refresh => config['refresh']
        }
  end
end
