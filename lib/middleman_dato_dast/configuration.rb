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

    attr_reader :host
    attr_writer :marks, :types
    attr_accessor :blocks, :item_links, :smart_links

    def initialize
      @marks = {}
      @types = {}
      @item_links = {}
      @blocks = {}
      @smart_links = true
      @host = nil
    end

    def host=(new_host)
      uri = URI(new_host)

      if uri.host.present?
        @host = uri.host
      else
        @host = uri.to_s
      end
    end

    def marks
      @memoized_marks ||= MARK_CONFIG.dup.merge(@marks)
    end

    def types
      @memoized_typed ||= TYPE_CONFIG.dup.merge(@types)
    end
  end
end
