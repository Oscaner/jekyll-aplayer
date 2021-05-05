# frozen_string_literal: true

require 'net/http'
require 'json/next'
require 'jekyll-aplayer/cores/logger'
require 'jekyll-aplayer/common'

module Jekyll::Aplayer::Util
  class Netease < Jekyll::Aplayer::Common

    API_URI = 'https://music.163.com/api'
    API_URI_WE = 'https://music.163.com/weapi'

    @logger = Jekyll::Aplayer::Logger.new(self.class_name)

    attr_reader :logger

    def self.get_lyric(id)
      begin
        uri = URI("#{API_URI}/song/lyric")
        uri.query = URI.encode_www_form({
          :id => id,
          :lv => -1,
          :kv => -1,
          :tv => -1
        })
        res = Net::HTTP.get_response(uri)
        raise res.body unless res.is_a?(Net::HTTPSuccess)
        body = HANSON.parse(res.body)
        raise res.body unless body.key?('lrc')
        return body['lrc']['lyric']
      rescue StandardError => msg
        @logger.log(msg)
      end
    end

  end
end
