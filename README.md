# IshikawaAirPollution

Fetch the observed value of air pollutants in Ishikawa pref.

## Installation

Add this line to your application's Gemfile:

    gem 'ishikawa_air_pollution', :git => "https://github.com/kitak/ishikawa_air_pollution.git"

And then execute:

    $ bundle install

<!--Or install it yourself as:-->
<!--$ gem install ishikawa_air_pollution-->

## Usage
```ruby
require 'pp'
client = IshikawaAirPollution.new
pp client.pm25 # 微小粒子状物質
pp client.so2  # 二酸化硫黄
pp client.no   # 一酸化窒素
pp client.no2  # 二酸化窒素
pp client.nox  # 窒素酸化物
pp client.co   # 一酸化炭素
pp client.ox   # 光化学オキシダント
pp client.nmhc # 非メタン炭素水素
pp client.ch4  # メタン
pp client.thc  # 全炭素水素
pp client.spm  # 浮遊粒子状物質
```

## Origin
Thanks, sharapeco! [IshikawaAirPollutionAPI.rb](https://gist.github.com/sharapeco/5089792)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
