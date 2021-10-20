RSpec.describe MiddlemanDatoDast::Configuration do
  subject(:config) { described_class.new }

  # describe "#mark_tags" do
  #   it "returns the defaults" do
  #     defaults = {
  #       "code" => "code",
  #       "emphasis" => "em",
  #       "highlight" => "mark",
  #       "strikethrough" => "strike",
  #       "strong" => "strong",
  #       "underline" => "u",
  #     }
  #
  #     expect(config.mark_tags).to eq(defaults)
  #   end
  #
  #   it "merges in new values" do
  #     new_tags = {
  #       "code" => "pre",
  #       "superscript" => "sup",
  #     }
  #     expected_tags = {
  #       "code" => "pre",
  #       "emphasis" => "em",
  #       "highlight" => "mark",
  #       "strikethrough" => "strike",
  #       "strong" => "strong",
  #       "superscript" => "sup",
  #       "underline" => "u",
  #     }
  #
  #     config.mark_tags = new_tags
  #
  #     expect(config.mark_tags).to eq(expected_tags)
  #   end
  # end
  #
  # describe "#node_tags" do
  #   it "returns the defaults" do
  #     defaults = {
  #       "blockquote" => "blockquote",
  #       "code" => "code",
  #       "heading" => "h#",
  #       "link" => "a",
  #       "list" => { "bulleted" => "ul", "numbered" => "ol" },
  #       "listItem" => "li",
  #       "paragraph" => "p",
  #       "root" => "div",
  #       "span" => nil,
  #       "thematicBreak" => "hr",
  #     }
  #
  #     expect(config.node_tags).to eq(defaults)
  #   end
  #
  #   it "merges in new values" do
  #     new_tags = {
  #       "paragraph" => "div",
  #     }
  #     expected_tags = {
  #       "blockquote" => "blockquote",
  #       "code" => "code",
  #       "heading" => "h#",
  #       "link" => "a",
  #       "list" => { "bulleted" => "ul", "numbered" => "ol" },
  #       "listItem" => "li",
  #       "paragraph" => "div",
  #       "root" => "div",
  #       "span" => nil,
  #       "thematicBreak" => "hr",
  #     }
  #
  #     config.node_tags = new_tags
  #
  #     expect(config.node_tags).to eq(expected_tags)
  #   end
  # end
  #
  # describe "#nodes" do
  #   it "returns the defaults" do
  #     defaults = {
  #       "blockquote" => MiddlemanDatoDast::Nodes::AttributedQuote,
  #       "code" => MiddlemanDatoDast::Nodes::Code,
  #       "heading" => MiddlemanDatoDast::Nodes::Heading,
  #       "link" => MiddlemanDatoDast::Nodes::Link,
  #       "list" => MiddlemanDatoDast::Nodes::List,
  #       "listItem" => MiddlemanDatoDast::Nodes::ListItem,
  #       "paragraph" => MiddlemanDatoDast::Nodes::Paragraph,
  #       "root" => MiddlemanDatoDast::Nodes::Root,
  #       "span" => MiddlemanDatoDast::Nodes::Span,
  #       "thematicBreak" => MiddlemanDatoDast::Nodes::ThematicBreak,
  #     }
  #
  #     expect(config.nodes).to eq(defaults)
  #   end
  #
  #   it "merges in new values" do
  #     new_nodes = {
  #       "blockquote" => MiddlemanDatoDast::Nodes::Blockquote,
  #     }
  #     expected_nodes = {
  #       "blockquote" => MiddlemanDatoDast::Nodes::Blockquote,
  #       "code" => MiddlemanDatoDast::Nodes::Code,
  #       "heading" => MiddlemanDatoDast::Nodes::Heading,
  #       "link" => MiddlemanDatoDast::Nodes::Link,
  #       "list" => MiddlemanDatoDast::Nodes::List,
  #       "listItem" => MiddlemanDatoDast::Nodes::ListItem,
  #       "paragraph" => MiddlemanDatoDast::Nodes::Paragraph,
  #       "root" => MiddlemanDatoDast::Nodes::Root,
  #       "span" => MiddlemanDatoDast::Nodes::Span,
  #       "thematicBreak" => MiddlemanDatoDast::Nodes::ThematicBreak,
  #     }
  #
  #     config.nodes = new_nodes
  #
  #     expect(config.nodes).to eq(expected_nodes)
  #   end
  # end
  #
  # describe "#wrapper_tags" do
  #   it "returns the defaults" do
  #     defaults = {
  #       "code" => "pre",
  #     }
  #
  #     expect(config.wrapper_tags).to eq(defaults)
  #   end
  #
  #   it "merges in new values" do
  #     new_tags = {
  #       "paragraph" => "section",
  #     }
  #     expected_tags = {
  #       "paragraph" => "section",
  #       "code" => "pre",
  #     }
  #
  #     config.wrapper_tags = new_tags
  #
  #     expect(config.wrapper_tags).to eq(expected_tags)
  #   end
  # end
end
