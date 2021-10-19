RSpec.describe MiddlemanDatoDast::Nodes::Paragraph do
  subject(:node) { described_class.new(raw) }

  let(:raw) do
    {
      "type" => "paragraph",
      "children" => [
        {
          "type" => "span",
          "value" => "A simple paragraph!"
        }
      ]
    }
  end

  describe "#type" do
    it "returns 'paragraph'" do
      expect(node.type).to eq("paragraph")
    end
  end

  describe "#tag" do
    it "returns 'p'" do
      expect(node.tag).to eq("p")
    end
  end

  describe "#children" do
    it "returns the children" do
      expect(node.children).to eq([{ "type" => "span", "value" => "A simple paragraph!" }])
    end
  end

  describe "#open_tag" do
    it "returns the open tag with newline" do
      expect(node.open_tag).to eq("<p>\n")
    end

    it "returns empty when there is no tag defined" do
      node = described_class.new({ "type" => "span", "value" => "Hello world!" })

      expect(node.open_tag).to eq("")
    end
  end

  describe "#close_tag" do
    it "returns the close tag with preceding newline" do
      expect(node.close_tag).to eq("\n</p>")
    end

    it "returns empty when there is no tag defined" do
      node = described_class.new({ "type" => "span", "value" => "Hello world!" })

      expect(node.close_tag).to eq("")
    end
  end

  describe "#wrapper_tags" do
    it "returns nil" do
      expect(node.wrapper_tags).to be_empty
    end
  end

  describe "#render" do
    it "returns the html string" do
      expect(node.render).to eq(<<~HTML.strip)
        <p>
        A simple paragraph!
        </p>
      HTML
    end

    it "renders wrapper tags" do
      object_wrapper = MiddlemanDatoDast::HtmlTag.new(
        "body", {
          "class" => "body--wide mx-auto",
          "meta" => [{ "id" => "click", "value" => "hide" }],
        },
      )
      hash_wrapper = { "tag" => "section", "class" => "blue w-10", "meta" => [{ "id" => "data-value", "value" => 1 }]}
      string_wrapper = "article"
      raw["wrapper_tags"] = [object_wrapper, hash_wrapper, string_wrapper]
      node = described_class.new(raw)

      expect(node.render).to eq(<<~HTML.strip)
      <body class="body--wide mx-auto" click="hide">
      <section class="blue w-10" data-value="1">
      <article>
      <p>
      A simple paragraph!
      </p>
      </article>
      </section>
      </body>
      HTML
    end
  end
end
