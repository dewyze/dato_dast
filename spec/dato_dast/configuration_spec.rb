RSpec.describe DatoDast::Configuration do
  subject(:config) { described_class.new }

  describe "#types" do
    it "returns the defaults" do
      defaults = {
        "block" => { "node" => DatoDast::Nodes::Block },
        "blockquote" => { "tag" => "blockquote", "node" => DatoDast::Nodes::AttributedQuote },
        "code" => { "tag" => "code", "node" => DatoDast::Nodes::Code, "wrappers" => ["pre"] },
        "generic" => { "node" => DatoDast::Nodes::Generic },
        "inlineItem" => { "node" => DatoDast::Nodes::InlineItem },
        "itemLink" => { "tag" => "a", "node" => DatoDast::Nodes::ItemLink, "url_key" => :slug },
        "link" => { "tag" => "a", "node" => DatoDast::Nodes::Link },
        "listItem" => { "tag" => "li", "node" => DatoDast::Nodes::ListItem },
        "paragraph" => { "tag" => "p", "node" => DatoDast::Nodes::Paragraph },
        "root" => { "tag" => "div", "node" => DatoDast::Nodes::Root },
        "span" => { "node" => DatoDast::Nodes::Span },
        "thematicBreak" => { "tag" => "hr", "node" => DatoDast::Nodes::ThematicBreak }
      }

      expect(config.types).to include(defaults)
    end

    it "returns the correct values for headings" do
      heading_config = config.types["heading"]

      expect(heading_config["node"]).to eq(DatoDast::Nodes::Heading)
      expect(heading_config["tag"]).to be_a(Proc)
    end

    it "returns the correct values for bulleted lists" do
      list_config = config.types["list"]

      expect(list_config["node"]).to eq(DatoDast::Nodes::List)
      expect(list_config["tag"]).to be_a(Proc)
    end

    it "merges in new values" do
      klass = Class.new { def render; end }

      new_types = {
        "link" => { "tag" => "button", "node" => klass },
        "newType" => { "tag" => "div", "node" => DatoDast::Nodes::Generic },
      }
      expected_types = {
        "block" => { "node" => DatoDast::Nodes::Block },
        "blockquote" => { "tag" => "blockquote", "node" => DatoDast::Nodes::AttributedQuote },
        "code" => { "tag" => "code", "node" => DatoDast::Nodes::Code, "wrappers" => ["pre"] },
        "generic" => { "node" => DatoDast::Nodes::Generic },
        "inlineItem" => { "node" => DatoDast::Nodes::InlineItem },
        "itemLink" => { "tag" => "a", "node" => DatoDast::Nodes::ItemLink, "url_key" => :slug },
        "link" => { "tag" => "button", "node" => klass },
        "listItem" => { "tag" => "li", "node" => DatoDast::Nodes::ListItem },
        "paragraph" => { "tag" => "p", "node" => DatoDast::Nodes::Paragraph },
        "root" => { "tag" => "div", "node" => DatoDast::Nodes::Root },
        "span" => { "node" => DatoDast::Nodes::Span },
        "thematicBreak" => { "tag" => "hr", "node" => DatoDast::Nodes::ThematicBreak },
        "newType" => { "tag" => "div", "node" => DatoDast::Nodes::Generic },
      }

      config.types = new_types

      expect(config.types).to include(expected_types)
    end
  end

  describe "#add_wrapper" do
    it "adds a wrapper for a given type" do
      config.add_wrapper("span", {
        "tag" => "div",
        "css_class" => "text",
        "meta" => { "id" => "data-value", "value" => "1" },
      })

      expect(config.types["span"]).to eq(
        "node" => DatoDast::Nodes::Span,
        "wrappers" => [{
          "tag" => "div",
          "css_class" => "text",
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

  describe "#item_links" do
    it "defaults to empty hash" do
      expect(config.item_links).to eq({})
    end

    it "can be configurable" do
      item_links = { "page" => "slug" }
      config.item_links = item_links

      expect(config.item_links).to eq(item_links)
    end
  end

  describe "#highlight" do
    it "defaults to true" do
      expect(config.highlight).to be true
    end

    it "can be configured" do
      config.highlight = false

      expect(config.highlight).to be false
    end
  end

  describe "#host" do
    it "defaults to nil" do
      expect(config.host).to be_nil
    end

    it "does not set a nil host" do
      expect do
        config.host = nil
      end.to_not raise_error
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

  describe "blocks InvalidItemsConfiguration" do
    it "raises the error if no key is present" do
      expect do
        config.blocks = { "image" => {} }
      end.to raise_error(DatoDast::Errors::InvalidItemsConfiguration, /blocks->image/)
    end

    it "raises the error if two or more keys are present" do
      expect do
        config.blocks = {
          "image" => { "render_value" => "", "node" => "" },
        }
      end.to raise_error(DatoDast::Errors::InvalidItemsConfiguration, /blocks->image/)
    end
  end

  describe "inline_items InvalidItemsConfiguration" do
    it "raises the error if no key is present" do
      expect do
        config.inline_items = { "image" => {} }
      end.to raise_error(DatoDast::Errors::InvalidItemsConfiguration, /inline_items->image/)
    end

    it "raises the error if two or more keys are present" do
      expect do
        config.inline_items = {
          "image" => { "render_value" => "", "node" => "" },
        }
      end.to raise_error(DatoDast::Errors::InvalidItemsConfiguration, /inline_items->image/)
    end
  end

  describe "InvalidTypesConfiguration" do
    it "raises the error if no 'node' key is present" do
      expect do
        config.types = { "image" => {} }
      end.to raise_error(DatoDast::Errors::InvalidTypesConfiguration)
    end
  end

  describe "InvalidMarksConfiguration" do
    it "raises the error if no 'tag' key is present" do
      expect do
        config.marks = { "image" => {} }
      end.to raise_error(DatoDast::Errors::InvalidMarksConfiguration)
    end
  end

  describe "InvalidNode" do
    it "raises the error if a type node does not have a render method" do
      expect do
        config.types = {
          "generic" => { "node" => Class.new }
        }
      end.to raise_error(DatoDast::Errors::InvalidNodes)
    end
  end
end
