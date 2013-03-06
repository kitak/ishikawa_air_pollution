# IshikawaAirPollution

石川県の大気汚染物質の測定値を取得するライブラリです．  
[石川県の大気環境の状況](http://www.pref.ishikawa.jp/cgi-bin/taiki/top.pl)からデータを取得しています.

## Installation

Add this line to your application's Gemfile:

    gem 'ishikawa_air_pollution', :git => "https://github.com/kitak/ishikawa_air_pollution.git"

And then execute:

    $ bundle install

<!--Or install it yourself as:-->
<!--$ gem install ishikawa_air_pollution-->

## Usage
```ruby
require 'ishikawa_air_pollution'

client = IshikawaAirPollution.new

# 取得できる物質一覧
# so2  二酸化硫黄
# no   一酸化窒素
# no2  二酸化窒素
# nox  窒素酸化物
# co   一酸化炭素
# ox   光化学オキシダント
# nmhc 非メタン炭素水素
# ch4  メタン
# thc  全炭素水素
# spm  浮遊粒子状物質
# pm25 微小粒子状物質

pp client.pm25
# PM2.5の測定データを取得
# {"name_ja"=>"微小粒子状物質",
#  "name"=>"PM2.5",
#  "unit"=>"μg/m3",
#  "locations"=>
#   [{"name"=>"小松", "value"=>19.0},
#    {"name"=>"七尾", "value"=>22.0},
#    {"name"=>"野々市自排", "value"=>23.0}]}

pp client.location("津幡")
# 津幡の測定局で測定したデータ
# {"no"=>{"value"=>0.001, "name_ja"=>"一酸化窒素", "name"=>"NO", "unit"=>"ppm"},
#  "no2"=>{"value"=>0.006, "name_ja"=>"二酸化窒素", "name"=>"NO2", "unit"=>"ppm"},
#  "nox"=>{"value"=>0.007, "name_ja"=>"窒素酸化物", "name"=>"NOx", "unit"=>"ppm"},
#  "ox"=>{"value"=>0.06, "name_ja"=>"光化学オキシダント", "name"=>"Ox", "unit"=>"ppm"},
#  "spm"=>{"value"=>0.025, "name_ja"=>"浮遊粒子状物質", "name"=>"SPM", "unit"=>"mg/m3"}}

pp client.observation
# 各測定局の測定開始時間．一時間毎に元サイトは更新される
# {"start"=>
#   #<DateTime: 2013-03-06T15:00:00+09:00 ((2456358j,21600s,0n),+32400s,2299161j)>,
#  "end"=>
#   #<DateTime: 2013-03-06T16:00:00+09:00 ((2456358j,25200s,0n),+32400s,2299161j)>,
#  "period_sec"=>3600}

client.refetch! # データの再取得
```

## Origin
Thanks, sharapeco! [IshikawaAirPollutionAPI.rb](https://gist.github.com/sharapeco/5089792)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
