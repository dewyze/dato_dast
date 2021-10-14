RSpec.describe MiddlemanDatoDast::Configuration do
  subject(:config) { described_class.new }

  describe "#mark_tags" do
    it "returns the defaults" do
      defaults = {
        "code" => "code",
        "emphasis" => "em",
        "highlight" => "mark",
        "strikethrough" => "strike",
        "strong" => "strong",
        "underline" => "u",
      }

      expect(config.mark_tags).to eq(defaults)
    end

    it "merges in new values" do
      new_tags = {
        "code" => "pre",
        "superscript" => "sup",
      }
      expected_tags = {
        "code" => "pre",
        "emphasis" => "em",
        "highlight" => "mark",
        "strikethrough" => "strike",
        "strong" => "strong",
        "superscript" => "sup",
        "underline" => "u",
      }

      config.mark_tags = new_tags

      expect(config.mark_tags).to eq(expected_tags)
    end
  end

  describe "#node_tags" do
    it "returns the defaults" do
      defaults = {
        "blockquote" => "blockquote",
        "code" => "code",
        "heading" => "h#",
        "link" => "a",
        "list" => { "bulleted" => "ul", "numbered" => "ol" },
        "listItem" => "li",
        "paragraph" => "p",
        "root" => "div",
        "span" => nil,
        "thematicBreak" => "hr",
      }

      expect(config.node_tags).to eq(defaults)
    end

    it "merges in new values" do
      new_tags = {
        "paragraph" => "div",
      }
      expected_tags = {
        "blockquote" => "blockquote",
        "code" => "code",
        "heading" => "h#",
        "link" => "a",
        "list" => { "bulleted" => "ul", "numbered" => "ol" },
        "listItem" => "li",
        "paragraph" => "div",
        "root" => "div",
        "span" => nil,
        "thematicBreak" => "hr",
      }

      config.node_tags = new_tags

      expect(config.node_tags).to eq(expected_tags)
    end
  end

  describe "#wrapper_tags" do
    it "returns the defaults" do
      defaults = {
        "blockquote" => "figure",
        "code" => "pre",
      }

      expect(config.wrapper_tags).to eq(defaults)
    end

    it "merges in new values" do
      new_tags = {
        "paragraph" => "section",
      }
      expected_tags = {
        "blockquote" => "figure",
        "paragraph" => "section",
        "code" => "pre",
      }

      config.wrapper_tags = new_tags

      expect(config.wrapper_tags).to eq(expected_tags)
    end
  end

  describe "#other_tags" do
    it "returns the defaults" do
      defaults = {
        "attribution" => "figcaption",
      }

      expect(config.other_tags).to eq(defaults)
    end

    it "merges in new values" do
      new_tags = {
        "attribution" => "cite",
      }

      config.other_tags = new_tags

      expect(config.other_tags).to eq(new_tags)
    end
  end

  describe "#whitespace" do
    it "returns the defaults" do
      defaults = {
        "blockquote" => true,
        "code" => true,
        "heading" => true,
        "link" => true,
        "list" => true,
        "listItem" => true,
        "paragraph" => true,
        "root" => true,
        "span" => false,
        "thematicBreak" => true,
      }

      expect(config.whitespace).to eq(defaults)
    end

    it "merges in new values" do
      new_tags = {
        "attribution" => "cite",
      }

      config.other_tags = new_tags

      expect(config.other_tags).to eq(new_tags)
    end
  end
end
