module MiddlemanDatoDast
  class Configuration
    MARK_TAGS = {
      Marks::CODE => "code",
      Marks::EMPHASIS => "em",
      Marks::HIGHLIGHT => "mark",
      Marks::STRIKETHROUGH => "strike",
      Marks::STRONG => "strong",
      Marks::UNDERLINE => "u",
    }

    NODE_TAGS = {
      Nodes::Blockquote.type => "blockquote",
      Nodes::Code.type => "code",
      Nodes::Heading.type => "h#",
      Nodes::Link.type => "a",
      Nodes::List.type => { "bulleted" => "ul", "numbered" => "ol" },
      Nodes::ListItem.type => "li",
      Nodes::Paragraph.type => "p",
      Nodes::Root.type => "div",
      Nodes::Span.type => nil,
      Nodes::ThematicBreak.type => "hr",
    }

    NODES = {
      Nodes::Blockquote.type => Nodes::AttributedQuote,
      Nodes::Code.type => Nodes::Code,
      Nodes::Heading.type => Nodes::Heading,
      Nodes::Link.type => Nodes::Link,
      Nodes::List.type => Nodes::List,
      Nodes::ListItem.type => Nodes::ListItem,
      Nodes::Paragraph.type => Nodes::Paragraph,
      Nodes::Root.type => Nodes::Root,
      Nodes::Span.type => Nodes::Span,
      Nodes::ThematicBreak.type => Nodes::ThematicBreak,
    }

    WRAPPER_TAGS = {
      Nodes::Code.type => "pre",
    }

    attr_writer :mark_tags, :node_tags, :nodes, :wrapper_tags

    def initialize
      @mark_tags = {}
      @node_tags = {}
      @nodes = {}
      @wrapper_tags = {}
    end

    def node_tags
      NODE_TAGS.merge(@node_tags)
    end

    def nodes
      # TODO, should this throw an error? Should there be an add?
      NODES.merge(@nodes)
    end

    def mark_tags
      MARK_TAGS.merge(@mark_tags)
    end

    def wrapper_tags
      WRAPPER_TAGS.merge(@wrapper_tags)
    end
  end
end
