# frozen_string_literal: true

require 'deep_merge'
require 'securerandom'
require 'nokogiri'
require 'json/next'

module Jekyll::Aplayer
  class Processor

    DEFAULT_PRIORITY = 20

    PRIORITY_MAP = {
      :lowest  => 0,
      :low     => 10,
      :normal  => 20,
      :high    => 30,
      :highest => 40,
    }.freeze

    @@_registers = []
    @@_exclusions = []
    @@_priority = nil
    @@_site_config = {}

    attr_reader :page
    attr_reader :logger
    attr_reader :config
    attr_reader :priority
    attr_reader :registers
    attr_reader :exclusions
    attr_accessor :handled

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

    def self.config
      {}
    end

    def process?
      return true if Type.html?(output_ext) or Type.markdown?(output_ext)
    end

    def ext
      Manager.ext @page
    end

    def output_ext
      Manager.output_ext @page
    end

    def initialize()
      self.initialize_priority
      self.initialize_register
      self.initialize_exclusions
      @logger = Logger.new(self.name)
      @@_site_config = {}.deep_merge!(Config.site_config()).deep_merge!(self.config)
      @handled_files = {}
    end

    ####
    # Priority
    #
    def initialize_priority
      @priority = @@_priority
      unless @priority.nil? or @priority.is_a? Numeric
        @priority = PRIORITY_MAP[@priority.to_sym]
      end
      @priority = DEFAULT_PRIORITY if @priority.nil?
      @@_priority = nil
    end

    def self.priority(value)
      @@_priority = value.to_sym
    end

    ####
    # Register
    #
    def initialize_register
      if @@_registers.size.zero?
        self.class.register :pages, :pre_render, :post_render
        self.class.register :documents, :pre_render, :post_render
      end
      @registers = Array.new @@_registers
      @@_registers.clear
    end

    def self.register(container, *events)
      @@_registers << [container, events]
    end

    ####
    # Exclusions
    #
    def initialize_exclusions
      if @@_exclusions.size.zero?
        self.class.exclude :code, :math, :liquid_filter
      end
      @exclusions = @@_exclusions.uniq
      @@_exclusions.clear
    end

    def self.exclude(*types)
      @@_exclusions = types
    end

    def exclusion_regexs()
      regexs = []
      @exclusions.each do |type|
        regex = nil
        if type == :code
          regex = /(((?<!\\)`{4,})\s*(\w*)((?:.|\n)*?)\2)/
        elsif type == :math
          regex = /(((?<!\\)\${1,2})[^\n]*?\1)/
        elsif type == :liquid_filter
          regex = /((?<!\\)((\{\{[^\n]*?\}\})|(\{%[^\n]*?%\})))/
        end
        regexs.push regex unless regex.nil?
      end
      regexs
    end

    def pre_exclude(content, regexs = self.exclusion_regexs())
      @exclusion_store = []
      regexs.each do |regex|
        content.scan(regex) do |match_data|
          match = match_data[0]
          id = @exclusion_store.size
          content = content.sub(match, "<!JEKYLL@#{object_id}@#{id}>")
          @exclusion_store.push match
        end
      end
      content
    end

    def post_exclude(content)
      while @exclusion_store.size > 0
        match = @exclusion_store.pop
        id = @exclusion_store.size
        content = content.sub("<!JEKYLL@#{object_id}@#{id}>", match)
      end
      @exclusion_store = []
      content
    end

    def converter(name)
      Manager.converter @page, name
    end

    def dispatch(page, container, event)
      @page = page
      @handled = false
      return unless self.process?
      method = "on_#{container}_#{event}"
      self.send method, @page if self.respond_to? method
      method = ''
      if event.to_s.start_with?('pre')
        if Type.markdown? ext
          method = 'on_handle_markdown'
        end
        if self.respond_to? method
          @page.content = self.pre_exclude @page.content
          @page.content = self.send method, @page.content
          @page.content = self.post_exclude @page.content
        end
      else
        if Type.html? output_ext
          method = 'on_handle_html'
        elsif Type.css? output_ext
          method = 'on_handle_css'
        end
        if self.respond_to? method
          @page.output = self.send method, @page.output
          if Type.html? output_ext
            @page.output = self.class.escape_html(@page.output)
          end
        end
      end
    end


    ####
    # Handle content.
    #
    def on_handle_markdown(content)
      # Do not handle markdown if no aplayer placeholder.
      return content unless Generator.has_aplayer_placeholder?(content, :code_aplayer)

      # pre-handle aplayer code block in markdown.
      content.scan(Generator.get_aplayer_regex(:code_aplayer)) do |match_data|
        # Generate customize config.
        config = {}
          .deep_merge!(@@_site_config)
          .deep_merge!(
            HANSON.parse(match_data[3]).map {
              |data|

              # Convert string to real datatype.
              method = 'to_' + Type.datatype?(data[0])
              data[1] = data[1].send(method) if data[1].respond_to?(method)

              data
            }.to_h
          )

        # Skip if the processor not match.
        next unless config['processor'].strip == self.name.downcase

        # Replace aplayer placeholder.
        uuid = config.key?('id') ? config['id'] : SecureRandom.uuid;

        content = content.gsub(match_data[0], Nokogiri::HTML::Document.new.create_element('aplayer', '', {
          'id' => uuid,
          'class' => config['class'],
        }).to_html)

        # Store the each aplayers' config.
        Config.store(uuid, config)
      end

      content
    end

    def on_handle_html_block(content, type)
      # default handle method
      content
    end

    def on_handle_html(content)
      # Do not handle html if no aplayer placeholder.
      return content unless Generator.has_aplayer_placeholder?(content, :html_aplayer)

      # use nokogiri to parse html.
      doc = Nokogiri::HTML(content)

      # Prepare doms.
      head = doc.at('head')
      body = doc.at('body')
      return content if head.nil? or body.nil?

      # Inject assets into head.
      @@_site_config['assets'].each do |type, value|
        value.each do |asset|
          Generator.asset_inject(:"#{type}", asset, head)
        end
      end

      # Parse aplayer doc, and inset aplayer instances into body.
      doc.css('aplayer').each do |elem|
        elem['id'] = SecureRandom.uuid if !elem.key?('id') or elem['id'].empty?

        config = {}.deep_merge!(
          Config.get(elem['id']) ? Config.get(elem['id']) : @@_site_config
        ).deep_merge!(
          elem.keys.map { |key| [key, elem[key]] }.to_h
        )

        # Store each aplayers' config.
        Config.store(elem['id'], config)

        # Generate aplayer instance.
        body.add_child(
          Generator.generate_aplayer_instance(elem['id'], Config.normalize?(config))
        ) if !body.to_html.include?(Generator.machine_id(elem['id']))
      end

      self.handled = true

      doc.to_html
    end

    def on_handled
      source = page.site.source
      file = page.path.sub(/^#{source}\//, '')
      return if @handled_files.has_key? file
      @handled_files[file] = true
      logger.log file
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
