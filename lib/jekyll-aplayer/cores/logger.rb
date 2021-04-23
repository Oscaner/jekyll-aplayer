# frozen_string_literal: true

require 'jekyll-aplayer/version'
require 'rainbow/refinement'

using Rainbow

module Jekyll::Aplayer
  class Logger

    def initialize(namespace)
      @namespace = namespace
    end

    def self.display_info
      self.log "🚀 Jekyll-Aplayer #{Jekyll::Aplayer::VERSION}"
      self.log '🍭 A Jekyll plugin to beautiful HTML5 music player.'
      self.log '👉 ' + 'https://github.com/Oscaner/jekyll-aplayer'.underline
    end

    def self.log(content)
      self.output 'Jekyll Aplayer', content.bright
    end

    def self.output(title, content)
      puts "#{title.rjust(18)}: #{content}"
    end

    def log(content)
      if @namespace.nil?
        self.class.log content
      else
        self.class.log "[#{@namespace}] #{content}"
      end
    end

  end
end
