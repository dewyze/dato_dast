# frozen_string_literal: true

module MiddlemanDatoDast
  class Configuration
    TYPE_CONFIG = {
      Nodes::Block.type => { "node" => Nodes::Block },
      Nodes::Blockquote.type => { "tag" => "blockquote", "node" => Nodes::AttributedQuote },
      Nodes::Code.type => { "tag" => "code", "node" => Nodes::Code, "wrappers" => ["pre"] },
      Nodes::Generic.type => { "node" => Nodes::Generic },
      Nodes::Heading.type => { "tag" => "h#", "node" => Nodes::Heading },
      Nodes::ItemLink.type => { "tag" => "a", "node" => Nodes::ItemLink, "url_key" => :slug },
      Nodes::Link.type => { "tag" => "a", "node" => Nodes::Link },
      Nodes::List.type => {
        "bulleted" => { "tag" => "ul", "node" => Nodes::List },
        "numbered" => { "tag" => "ol", "node" => Nodes::List },
      },
      Nodes::ListItem.type => { "tag" => "li", "node" => Nodes::ListItem },
      Nodes::Paragraph.type => { "tag" => "p", "node" => Nodes::Paragraph },
      Nodes::Root.type => { "tag" => "div", "node" => Nodes::Root },
      Nodes::Span.type => { "node" => Nodes::Span },
      Nodes::ThematicBreak.type => { "tag" => "hr", "node" => Nodes::ThematicBreak },
    }.freeze

    MARK_CONFIG = {
      Marks::CODE => { "tag" => "code" },
      Marks::EMPHASIS => { "tag" => "em" },
      Marks::HIGHLIGHT => { "tag" => "mark" },
      Marks::STRIKETHROUGH => { "tag" => "strike" },
      Marks::STRONG => { "tag" => "strong" },
      Marks::UNDERLINE => { "tag" => "u" },
    }.freeze

    BLOCK_RENDER_KEYS = ["node", "render_value", "structure"].freeze

    attr_reader :blocks, :host, :marks, :types
    attr_accessor :highlight, :item_links, :smart_links

    def initialize
      @blocks = {}
      @highlight = true
      @host = nil
      @item_links = {}
      @marks = MARK_CONFIG.transform_values { |value| value.dup }
      @smart_links = true
      @types = TYPE_CONFIG.transform_values { |value| value.dup }
    end

    def host=(new_host)
      uri = URI(new_host)

      if uri.host.present?
        @host = uri.host
      else
        @host = uri.to_s
      end
    end

    def blocks=(new_blocks)
      validate_blocks_configuration(new_blocks)

      @blocks = new_blocks
    end

    def marks=(new_marks)
      validate_marks_configuration(new_marks)

      @marks.merge!(new_marks)
    end

    def types=(new_types)
      validate_types(new_types)

      @types.merge!(new_types)
    end

    def add_wrapper(type, wrapper)
      wrappers = Array.wrap(@types[type]["wrappers"])
      wrappers << wrapper
      @types[type]["wrappers"] = wrappers
    end

    private

    def validate_blocks_configuration(blocks_config)
      invalid_blocks = []

      blocks_config.each do |block, block_config|
        intersection = block_config.keys & BLOCK_RENDER_KEYS
        invalid_blocks << block unless intersection.length == 1
      end

      raise Errors::InvalidBlocksConfiguration.new(invalid_blocks) if invalid_blocks.present?
    end

    def validate_types(types_config)
      invalid_configs = []
      invalid_nodes = []

      types_config.each do |type, type_config|
        node = type_config["node"]
        if node
          invalid_nodes << type unless node.instance_methods.include?(:render)
        else
          invalid_configs << type
        end
      end

      raise Errors::InvalidTypesConfiguration.new(invalid_configs) if invalid_configs.present?
      raise Errors::InvalidNodes.new(invalid_nodes) if invalid_nodes.present?
    end

    def validate_marks_configuration(marks_config)
      invalid_marks = []

      marks_config.each do |mark, mark_config|
        invalid_marks << mark unless mark_config.keys.include?("tag")
      end

      raise Errors::InvalidMarksConfiguration.new(invalid_marks) if invalid_marks.present?
    end
  end
end
