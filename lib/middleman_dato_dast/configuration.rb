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

    WRAPPER_TAGS = {
      Nodes::Code.type => "pre",
      Nodes::Blockquote.type => "figure",
    }

    OTHER_TAGS = {
      Nodes::Blockquote::ATTRIBUTION => "figcaption",
    }

    WHITESPACE = {
      Nodes::Blockquote.type => true,
      Nodes::Code.type => true,
      Nodes::Heading.type => true,
      Nodes::Link.type => true,
      Nodes::List.type => true,
      Nodes::ListItem.type => true,
      Nodes::Paragraph.type => true,
      Nodes::Root.type => true,
      Nodes::Span.type => false,
      Nodes::ThematicBreak.type => true,
    }

    attr_writer :mark_tags, :node_tags, :other_tags, :minify, :wrapper_tags

    def initialize
      @mark_tags = {}
      @node_tags = {}
      @other_tags = {}
      @minify = false
      @wrapper_tags = {}
    end

    def node_tags
      NODE_TAGS.merge(@node_tags)
    end

    def mark_tags
      MARK_TAGS.merge(@mark_tags)
    end

    def wrapper_tags
      WRAPPER_TAGS.merge(@wrapper_tags)
    end

    def other_tags
      OTHER_TAGS.merge(@other_tags)
    end

    def whitespace
      WHITESPACE
    end

    def minify
      @minify
    end
  end
end
