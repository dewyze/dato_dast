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
      klass = Class.new { def render; end }

      new_types = {
        "link" => { "tag" => "button", "node" => klass },
        "newType" => { "tag" => "div", "node" => MiddlemanDatoDast::Nodes::Generic },
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
        "newType" => { "tag" => "div", "node" => MiddlemanDatoDast::Nodes::Generic },
      }

      config.types = new_types

      expect(config.types).to eq(expected_types)
    end
  end

  describe "#add_wrapper" do
    it "adds a wrapper for a given type" do
      config.add_wrapper("heading", {
        "tag" => "div",
        "css_class" => "heading",
        "meta" => { "id" => "data-value", "value" => "1" },
      })

      expect(config.types["heading"]).to eq(
        "tag" => "h#",
        "node" => MiddlemanDatoDast::Nodes::Heading,
        "wrappers" => [{
          "tag" => "div",
          "css_class" => "heading",
          "meta" => { "id" => "data-value", "value" => "1" },
        }],
      )
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

  describe "InvalidBlocksConfiguration" do
    it "raises the error if no key is present" do
      expect do
        config.blocks = { "image" => {} }
      end.to raise_error(MiddlemanDatoDast::Errors::InvalidBlocksConfiguration)
    end

    it "raises the error if two or more keys are present" do
      expect do
        config.blocks = {
          "image" => { "render_value" => "", "node" => "" },
        }
      end.to raise_error(MiddlemanDatoDast::Errors::InvalidBlocksConfiguration)
    end
  end

  describe "InvalidTypesConfiguration" do
    it "raises the error if no 'node' key is present" do
      expect do
        config.types = { "image" => {} }
      end.to raise_error(MiddlemanDatoDast::Errors::InvalidTypesConfiguration)
    end
  end

  describe "InvalidMarksConfiguration" do
    it "raises the error if no 'tag' key is present" do
      expect do
        config.marks = { "image" => {} }
      end.to raise_error(MiddlemanDatoDast::Errors::InvalidMarksConfiguration)
    end
  end

  describe "InvalidNode" do
    it "raises the error if a type node does not have a render method" do
      expect do
        config.types = {
          "generic" => { "node" => Class.new }
        }
      end.to raise_error(MiddlemanDatoDast::Errors::InvalidNodes)
    end
  end
end
