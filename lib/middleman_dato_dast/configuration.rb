module MiddlemanDatoDast
  class Configuration
    TYPE_CONFIG = {
      Nodes::Blockquote.type => { "tag" => "blockquote", "node" => Nodes::AttributedQuote },
      Nodes::Code.type => { "tag" => "code", "node" => Nodes::Code, "wrappers" => ["pre"] },
      Nodes::Heading.type => { "tag" => "h#", "node" => Nodes::Heading },
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

    attr_writer :marks, :types

    def initialize
      @marks = {}
      @types = {}
    end

    def marks
      MARK_CONFIG.merge(@marks)
    end

    def types
      TYPE_CONFIG.merge(@types)
    end
  end
end
