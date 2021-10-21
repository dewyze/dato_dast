module MiddlemanDatoDast
  class Configuration
    TYPE_CONFIG = {
      Nodes::Blockquote.type => { "tag" => "blockquote", "node" => Nodes::AttributedQuote },
      Nodes::Code.type => { "tag" => "code", "node" => Nodes::Code, "wrappers" => ["pre"] },
      Nodes::Heading.type => { "tag" => "h#", "node" => Nodes::Heading },
      Nodes::ItemLink.type => { "tag" => "a", "node" => Nodes::ItemLink, "url_key" => :slug },
      Nodes::Link.type => { "tag" => "a", "node" => Nodes::Link },
      Nodes::List.type => { "tag" => { "bulleted" => "ul", "numbered" => "ol" }, "node" => Nodes::List },
      Nodes::ListItem.type => { "tag" => "li", "node" => Nodes::ListItem },
      Nodes::Paragraph.type => { "tag" => "p", "node" => Nodes::Paragraph },
      Nodes::Root.type => { "tag" => "div", "node" => Nodes::Root },
      Nodes::Span.type => { "node" => Nodes::Span },
      Nodes::ThematicBreak.type => { "tag" => "hr", "node" => Nodes::ThematicBreak },
    }

    MARK_CONFIG = {
      Marks::CODE => { "tag" => "code" },
      Marks::EMPHASIS => { "tag" => "em" },
      Marks::HIGHLIGHT => { "tag" => "mark" },
      Marks::STRIKETHROUGH => { "tag" => "strike" },
      Marks::STRONG => { "tag" => "strong" },
      Marks::UNDERLINE => { "tag" => "u" },
    }

    attr_reader :host
    attr_writer :marks, :types
    attr_accessor :item_links, :smart_links

    def initialize
      @marks = {}
      @types = {}
      @item_links = {}
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
      MARK_CONFIG.merge(@marks)
    end

    def types
      TYPE_CONFIG.merge(@types)
    end
  end
end
