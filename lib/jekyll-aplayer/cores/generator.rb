# frozen_string_literal: true

module Jekyll::Aplayer
  class Generator

    @@_generated = {}

    def self.machine_id(id)
      'app_' + id.gsub('-', '_')
    end

    def self.has_generated(id)
      @@_generated.key?(id)
    end

    def self.get_aplayer_regex(type)
      return /(((?<!\\)`+)\s*(aplayer)((?:.|\n)*?)\2)/ if type == :code_aplayer
      return /(<aplayer (.*)>\s*<\/aplayer>)/ if type == :html_aplayer
    end

    def self.has_aplayer_placeholder?(content, type = :code_aplayer)
      content.scan(self.get_aplayer_regex(type)) do |match_data|
        return true
      end
      return false
    end

    def self.asset_inject(type, url, doc)
      doc.add_child("<link href=\"#{url}\" rel=\"stylesheet\" type=\"text/css\">") if type == :css and !doc.to_html.include?("<link href=\"#{url}\" rel=\"stylesheet\" type=\"text/css\">")
      doc.add_child("<script src=\"#{url}\"></script>") if type == :js and !doc.to_html.include?("<script src=\"#{url}\"></script>")
    end

    def self.generate_aplayer_instance(id, config, &block)
      return @@_generated[id] if @@_generated.key?(id)

      machine_id = self.machine_id(id)

      content =
"""
const #{machine_id} = new APlayer(
  Object.assign(
    {
      \"container\": document.getElementById('#{id}')
    },
    #{config.to_json}
  )
);
"""
      block.call(machine_id, content) if !block.nil?

      return @@_generated[machine_id] = "<script>#{content}</script>"
    end

  end
end
