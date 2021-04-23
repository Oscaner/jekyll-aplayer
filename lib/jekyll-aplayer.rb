# frozen_string_literal: true

require 'jekyll-aplayer/cores/config'
require 'jekyll-aplayer/cores/extend'
require 'jekyll-aplayer/cores/generator'
require 'jekyll-aplayer/cores/logger'
require 'jekyll-aplayer/cores/manager'
require 'jekyll-aplayer/cores/processor'
require 'jekyll-aplayer/cores/register'
require 'jekyll-aplayer/cores/type'

module Jekyll::Aplayer
  Logger::display_info
  Config.load_config do
    Register.use_processors
  end
end
