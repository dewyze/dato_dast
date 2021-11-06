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

  describe "#wrappers" do
    it "returns nil" do
      expect(node.wrappers).to be_empty
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

    it "renders tag classes and meta fields" do

    end

    it "renders wrapper tags" do
      object_wrapper = MiddlemanDatoDast::HtmlTag.new(
        "body", {
          "css_class" => "body--wide mx-auto",
          "meta" => [{ "id" => "click", "value" => "hide" }],
        },
      )
      hash_wrapper = {
        "tag" => "section",
        "css_class" => "blue w-10",
        "meta" => [{ "id" => "data-value", "value" => 1 }],
      }
      string_wrapper = "article"
      raw["wrappers"] = [object_wrapper, hash_wrapper, string_wrapper]
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
