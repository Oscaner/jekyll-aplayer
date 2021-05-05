# frozen_string_literal: true

module Jekyll::Aplayer
  class Common

    def name
      self.class.class_name
    end

    def self.class_name
      self.name.split('::').last
    end

    def filename
      self.name
        .gsub(/([A-Z]+)([A-Z][a-z])/,'\1-\2')
        .gsub(/([a-z\d])([A-Z])/,'\1-\2')
        .tr("_", "-")
        .downcase
    end

    def self.escape_html(content)
      # escape link
      content.scan(/((https?:)?\/\/\S+\?[a-zA-Z0-9%\-_=\.&;]+)/) do |result|
        result = result[0]
        link = result.gsub('&amp;', '&')
        content = content.gsub(result, link)
      end
      content
    end

  end
end
