# frozen_string_literal: true

require 'jekyll-aplayer/utils/netease'

module Jekyll::Aplayer
  class Netease < Processor

    def on_config_normalize(config)
      config['lrcType'] = 1
      config['audio'] = config['audio'].map do |v|
        {
          'lrc' => Jekyll::Aplayer::Util::Netease.get_lyric(v)
        }
      end
      puts config.inspect
      config
    end

  end
end
