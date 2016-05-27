# twitter-simple-dashboard

This is a simple dashboard to pull the newest tweets from a specific hashtag.

## Configuration

Edit or create the `config.yml` with the following variables:

```yaml
consumer_key: "uwTQpCfKF_FAKE_KEY_336FaMZdFgN"
consumer_secret: "KK5ZzeJhcMVBgM54_ANOTHER_FAKE_KEY_vTwZxJpuUYXetFnlha81EyH"
\#hashtag: "#devopsdays" # if you would like to just display a hashtag
follower: "@AP,@BBCBreaking,@cnnbrk" # if you would like to display a follower
bind_address: "0.0.0.0" # you probably want it on all addresses
refresh: 30 # remember you only have 200 calls per hour by default
```

There is `Gemfile` so you'll need to do a `bundle install` to get dependencies.

## Usage

In order to start this application, you can use `ruby app.rb` to start
this application.

## License & Authors

- Author:: Thomas Cate (tcate@chef.io)
- Author:: Christine Draper (christine_draper@thirdwaveinsights.com)
- Author:: JJ Asghar (jj@chef.io)

```
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
