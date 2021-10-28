RSpec.describe MiddlemanDatoDast::Configuration do
  subject(:config) { described_class.new }

  describe "#types" do
    it "returns the defaults" do
      defaults = {
        "block" => { "node" => MiddlemanDatoDast::Nodes::Block },
        "blockquote" => { "tag" => "blockquote", "node" => MiddlemanDatoDast::Nodes::AttributedQuote },
        "code" => { "tag" => "code", "node" => MiddlemanDatoDast::Nodes::Code, "wrappers" => ["pre"] },
        "generic" => { "node" => MiddlemanDatoDast::Nodes::Generic },
        "heading" => { "tag" => "h#", "node" => MiddlemanDatoDast::Nodes::Heading },
        "itemLink" => { "tag" => "a", "node" => MiddlemanDatoDast::Nodes::ItemLink, "url_key" => :slug },
        "link" => { "tag" => "a", "node" => MiddlemanDatoDast::Nodes::Link },
        "list" => {
          "bulleted" => { "tag" => "ul", "node" => MiddlemanDatoDast::Nodes::List },
          "numbered" => { "tag" => "ol", "node" => MiddlemanDatoDast::Nodes::List },
        },
        "listItem" => { "tag" => "li", "node" => MiddlemanDatoDast::Nodes::ListItem },
        "paragraph" => { "tag" => "p", "node" => MiddlemanDatoDast::Nodes::Paragraph },
        "root" => { "tag" => "div", "node" => MiddlemanDatoDast::Nodes::Root },
        "span" => { "node" => MiddlemanDatoDast::Nodes::Span },
        "thematicBreak" => { "tag" => "hr", "node" => MiddlemanDatoDast::Nodes::ThematicBreak }
      }

      expect(config.types).to eq(defaults)
    end

    it "merges in new values" do
      klass = Class.new

      new_types = {
        "link" => { "tag" => "button", "node" => klass },
        "newType" => { "tag" => "div" },
      }
      expected_types = {
        "block" => { "node" => MiddlemanDatoDast::Nodes::Block },
        "blockquote" => { "tag" => "blockquote", "node" => MiddlemanDatoDast::Nodes::AttributedQuote },
        "code" => { "tag" => "code", "node" => MiddlemanDatoDast::Nodes::Code, "wrappers" => ["pre"] },
        "generic" => { "node" => MiddlemanDatoDast::Nodes::Generic },
        "heading" => { "tag" => "h#", "node" => MiddlemanDatoDast::Nodes::Heading },
        "itemLink" => { "tag" => "a", "node" => MiddlemanDatoDast::Nodes::ItemLink, "url_key" => :slug },
        "link" => { "tag" => "button", "node" => klass },
        "list" => {
          "bulleted" => { "tag" => "ul", "node" => MiddlemanDatoDast::Nodes::List },
          "numbered" => { "tag" => "ol", "node" => MiddlemanDatoDast::Nodes::List },
        },
        "listItem" => { "tag" => "li", "node" => MiddlemanDatoDast::Nodes::ListItem },
        "paragraph" => { "tag" => "p", "node" => MiddlemanDatoDast::Nodes::Paragraph },
        "root" => { "tag" => "div", "node" => MiddlemanDatoDast::Nodes::Root },
        "span" => { "node" => MiddlemanDatoDast::Nodes::Span },
        "thematicBreak" => { "tag" => "hr", "node" => MiddlemanDatoDast::Nodes::ThematicBreak },
        "newType" => { "tag" => "div" },
      }

      config.types = new_types

      expect(config.types).to eq(expected_types)
    end
  end

  describe "#marks" do
    it "returns the defaults" do
      defaults = {
        "code" => { "tag" => "code"},
        "emphasis" => { "tag" => "em" },
        "highlight" => { "tag" => "mark" },
        "strikethrough" => { "tag" => "strike" },
        "strong" => { "tag" => "strong" },
        "underline" => { "tag" => "u" },
      }

      expect(config.marks).to eq(defaults)
    end

    it "merges in new values" do
      new_marks = {
        "code" => { "tag" => "pre"},
        "superscript" => { "tag" => "sup" },
      }
      expected_marks = {
        "code" => { "tag" => "pre"},
        "emphasis" => { "tag" => "em" },
        "highlight" => { "tag" => "mark" },
        "strikethrough" => { "tag" => "strike" },
        "strong" => { "tag" => "strong" },
        "underline" => { "tag" => "u" },
        "superscript" => { "tag" => "sup" },
      }

      config.marks = new_marks

      expect(config.marks).to eq(expected_marks)
    end
  end

  describe "#smart_links" do
    it "defaults to true" do
      expect(config.smart_links).to be true
    end

    it "can be configured" do
      config.smart_links = false

      expect(config.smart_links).to be false
    end
  end

  describe "#host" do
    it "defaults to nil" do
      expect(config.host).to be_nil
    end

    it "accepts a string and returns a host" do
      config.host = "google.com"

      expect(config.host).to eq("google.com")
    end

    it "accepts a uri and returns a host" do
      config.host = "https://google.com"

      expect(config.host).to eq("google.com")
    end
  end
end
