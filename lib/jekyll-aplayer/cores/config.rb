# frozen_string_literal: true

require 'deep_merge'

module Jekyll::Aplayer
  class Config

    CONFIG_NAME = 'jekyll-aplayer'

    DEFAULT_CONFIG = {
      'processor' => 'default',
      'assets'    => {
        'css' => ['//unpkg.com/aplayer/dist/APlayer.min.css'],
        'js'  => ['//unpkg.com/aplayer/dist/APlayer.min.js'],
      },
      'class'    => 'jekyll-aplayer',
      'fixed'    => false,
      'mini'     => false,
      'autoplay' => false,
      'theme'    => '#b7daff',
      'loop'     => 'all',
      'order'    => 'random',
      'preload'  => 'auto',
      'volume'   => 0.7,
      'audio'    => [],
      'mutex'    => true,
      'lrcType'  => 0,
      'listFolded' => false,
      'listMaxHeight' => 90,
      'storageName' => 'aplayer-setting',
    }

    @@_site_config = {}
    @@_store_config = {}

    def self.normalize?(config)
      cpy = config.without?('processor', 'assets', 'id', 'class', 'container', 'customAudioType')
      # Convert string to real datatype.
      cpy.map { |key, value|
        method = 'to_' + Type.datatype?(key)
        value.respond_to?(method) ? [key, value.send(method)] : [key, value]
      }.to_h
    end

    def self.get(uuid)
      @@_store_config[uuid] if @@_store_config.key?(uuid)
    end

    def self.store(uuid, config)
      @@_store_config[uuid] = config
    end

    def self.site_config()
      @@_site_config
    end

    def self.load(config = {})
      config = {}.deep_merge!({
        CONFIG_NAME => DEFAULT_CONFIG
      }).deep_merge!(config)[CONFIG_NAME]
      @@_site_config = config
    end

    def self.load_config(&block)
      # post load site config for `group :jekyll_plugin`
      Jekyll::Hooks.register :site, :after_init do |site|
        self.load(site.config)
        block.call()
      end
    end

  end
end
