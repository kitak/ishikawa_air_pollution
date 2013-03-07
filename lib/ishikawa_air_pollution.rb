# coding: utf-8
require "ishikawa_air_pollution/version"
require "date"
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
    parse_page(fetch_page)
  end

  def refetch!
    parse_page(fetch_page)
  end

  def location(name)
    raise "unexist location" unless @location.has_key?(name)
    @location[name].inject({}) do |buf, (key, val)|
      buf[key] = val.merge(@material[key]) 
      buf
    end
  end

  def observation
    {
      "start" => @start_observation,
      "end" => @start_observation + Rational(1, 24),
      "period_sec" => 3600
    }
  end

  private
  def fetch_page
    @agent.get('http://www.pref.ishikawa.jp/cgi-bin/taiki/top.pl')
  end

  def method_missing(name, *args)
    if @material.has_key? name.to_s
      locations = @location.inject([]) do |buf, (key, val)|
        if val.has_key? name.to_s 
          buf << {
            "name" => key,
            "value" => val[name.to_s]["value"]
          } 
        end
        buf 
      end 
      @material[name.to_s].merge({
        "locations" => locations
      })
    else
      super
    end
  end

  def respond_to?(name)
    return true if @material.has_key? name.to_s
    super
  end

  def parse_page(page) 
    @start_observation = fetch_datetime(page)
    @material = fetch_material_header(page)
    @location = fetch_value_each_location(page)
  rescue => e
    raise "parse failed: #{e.message}"
  end

  def fetch_datetime(page)
    y = 0; mon = 0; d = 0; h = 0; min = 0
    page.search('#subhead div').each do |div|
      y, mon, d = $1.to_i, $2.to_i, $3.to_i if /(\d{4})年(\d{2})月(\d{2})日/ =~ div.text
      h, min = $1.to_i, $2.to_i if /(\d{2})\:(\d{2})/ =~ div.text
    end
    DateTime.new(y, mon, d, h, min, 0, 'GMT+09')
  end

  def fetch_material_header(page)
    tables = page.search('table')
    tables.detect { |table|
      table.search('td')[0].text == '測定局名'
    }.instance_eval {
      self.search('tr')[0].search('td').inject({}) do |buf, td|
        if /((?:\p{Han}|\p{katakana}|\p{Hiragana})+)(.+)\((.+)\)/u =~ td.text
          name_ja = $1; name = $2; unit = $3
          buf[$2.downcase.gsub(/\./, '')] = {
            "name_ja" => name_ja,
            "name" => name,
            "unit" => unit 
          }
        end
        buf
      end
    }
  end

  def fetch_value_each_location(page)
    tables = page.search('table')
    tables.select { |table|
      table.search('td')[0].text == '測定局名'
    }.map { |table|
      trs = table.search('tr')
      trs[1..-1].inject({}) { |buf, tr|
        tds = tr.search('td')
        loc_name = tds[0].text.gsub(/\302\240/, ' ').strip
        buf[loc_name] = tds[1..-1].each_with_index.inject({}) do |buf2, (td, i)|
          value = td.text.gsub(/\302\240/, ' ').strip
          buf2[@material.keys[i]] = { "value" => value.to_f } unless value.empty? || value=="***"
          buf2 
        end
        buf  
      } 
    }.instance_eval {
      self[0].merge(self[1])
    }
  end
end

if __FILE__ == $0
  client = IshikawaAirPollution.new
  require 'pp'
  pp client.pm25
  pp client.location("津幡")
  pp client.observation
end
