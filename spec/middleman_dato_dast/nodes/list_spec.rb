RSpec.describe MiddlemanDatoDast::Nodes::List do
  subject(:list) { described_class.new(raw) }

  let(:raw) do
    {
      "type" => "list",
      "style" => "bulleted",
      "children" => [
        {
          "type" => "listItem",
          "children" => [
            {
              "type" => "paragraph",
              "children" => [
                {
                  "type" => "span",
                  "value" => "This is a list item!"
                }
              ]
            }
          ]
        }
      ]
    }
  end

  describe "#type" do
    it "returns 'list'" do
      expect(list.type).to eq("list")
    end
  end

  describe "#tag" do
    it "returns 'ul' if style is 'bulleted'" do
      expect(list.tag).to eq("ul")
    end

    it "returns 'ol' if style is 'numbered'" do
      list = described_class.new({
        "type" => "list",
        "style" => "numbered",
        "children" => [],
      })

      expect(list.tag).to eq("ol")
    end
  end

  describe "#wrapper_tags" do
    it "returns nil" do
      expect(list.wrapper_tags).to be_empty
    end
  end

  describe "#style" do
    it "returns the style" do
      expect(list.style).to eq("bulleted")
    end
  end

  describe "#render" do
    it "returns the html string" do
      expect(list.render).to eq(<<~HTML.strip)
      <ul>
      <li>
      <p>
      This is a list item!
      </p>
      </li>
      </ul>
      HTML
    end
  end
end
