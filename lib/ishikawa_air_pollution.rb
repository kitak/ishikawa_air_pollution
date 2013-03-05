# coding: utf-8
require "ishikawa_air_pollution/version"
require "mechanize"

class IshikawaAirPollution
  def initialize
    @agent = Mechanize.new
    @agent.user_agent_alias = 'Mac Safari'
    @agent.request_headers = {
      'Accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
      'Accept-language' => 'ja-jp',
      'Accept-charset' => '',
      'Accept-encoding' => 'gzip, deflate',
      'Keep-alive' => nil
    }
  end

  def pm25
    fetch('SO2')
  end

  def fetch(target) 
    measure = {}

    page = @agent.get('http://www.pref.ishikawa.jp/cgi-bin/taiki/top.pl')

    # 測定日時を取得
    measure_date = nil
    measure_time = nil
    page.search('#subhead div').each do |div|
      text = div.text
      measure['date'] = text if /(\d{4})年(\d{2})月(\d{2})日/ =~ text
      measure['time'] = text if /\d{2}:\d{2}/ =~ text
    end

    # データテーブルを探す
    points = []
    page.search('table').each do |table|
      next unless table.search('td')[0].text == '測定局名'
      
      # テーブルヘッダをキーにする
      header = []
      target_key = nil
      unit = nil
      trs = table.search('tr')
      thead = trs.shift
      thead.search('td').each do |td|
        key = td.text
        if /#{Regexp.escape(target)}\((.+)\)/ =~ key
          target_key = key 
          unit = $1
        end
        header << key
      end

      raise 'invalid form' unless target_key

      # データをなめる
      trs.each do |tr|
        row = {}
        tr.search('td').each_with_index do |td, i|
          row[header[i]] = td.text.gsub(/\302\240/, ' ').strip
        end

        unless row[target_key].empty?
          points << {
            'station_name' => row['測定局名'],
            'value' => row[target_key],
            'unit' => unit 
          }
        end
      end
    end
    measure['points'] = points
    measure
  end
end

if __FILE__ == $0
  api = IshikawaAirPollution.new
  require 'pp'
  pp api.fetch('PM2.5')
  pp api.fetch('SO2')
end
