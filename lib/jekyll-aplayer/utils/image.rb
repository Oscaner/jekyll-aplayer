# frozen_string_literal: true

module Jekyll::Aplayer::Util
  class Image

    def self.fetch_img_data(url)
      begin
        res = Net::HTTP.get_response URI(url)
        raise res.body unless res.is_a?(Net::HTTPSuccess)
        content_type = res.header['Content-Type']
        raise 'Unknown content type!' if content_type.nil?
        content_body = res.body.force_encoding('UTF-8')
        return {
          'type' => content_type,
          'body' => content_body
        }
      rescue StandardError => msg
        logger = Logger.new(self.class_name)
        logger.log msg
      end
    end

    def self.make_img_tag(data)
      css_class = data['class']
      type = data['type']
      body = data['body']
      if type == 'url'
        "<img class=\"#{css_class}\" src=\"#{body}\">"
      elsif type.include?('svg')
        body.gsub(/\<\?xml.*?\?>/, '')
          .gsub(/<!--[^\0]*?-->/, '')
          .sub(/<svg /, "<svg class=\"#{css_class}\" ")
      else
        body = Base64.encode64(body)
        body = "data:#{type};base64, #{body}"
        "<img class=\"#{css_class}\" src=\"#{body}\">"
      end
    end

  end
end
