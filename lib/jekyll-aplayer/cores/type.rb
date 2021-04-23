# frozen_string_literal: true

require 'string_to_boolean'

module Jekyll::Aplayer
  class Type

    PROPERTY_DATA_TYPES = {
      'processor' => 'string',
      'assets'    => 'object',
      'id'        => 'string',
      'class'     => 'string',
      'fixed'     => 'bool',
      'mini'      => 'bool',
      'autoplay'  => 'bool',
      'theme'     => 'string',
      'loop'      => 'string',
      'order'     => 'string',
      'preload'   => 'string',
      'volume'    => 'float',
      'audio'     => 'array',
      'mutex'         => 'bool',
      'lrcType'       => 'integer',
      'listFolded'    => 'bool',
      'listMaxHeight' => 'integer',
      'storageName'   => 'string',
    }.freeze

    HTML_EXTENSIONS = %w(
      .html
      .xhtml
      .htm
    ).freeze

    CSS_EXTENSIONS = %w(
      .css
      .scss
    ).freeze

    MD_EXTENSIONS = %w(
      .md
      .markdown
    ).freeze

    HTML_BLOCK_TYPE_MAP = {
      'text/markdown'  => 'markdown',
    }.freeze

    def self.html?(_ext)
      HTML_EXTENSIONS.include?(_ext)
    end

    def self.css?(_ext)
      CSS_EXTENSIONS.include?(_ext)
    end

    def self.markdown?(_ext)
      MD_EXTENSIONS.include?(_ext)
    end

    def self.html_block_type(type)
      HTML_BLOCK_TYPE_MAP[type]
    end

    def self.datatype?(property)
      return PROPERTY_DATA_TYPES[property] if PROPERTY_DATA_TYPES.key?(property)
      return 'string'
    end

  end
end
