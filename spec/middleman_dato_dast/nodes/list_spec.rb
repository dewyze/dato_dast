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

  describe "#tag_info" do
    context "with style 'bulleted'" do
      it "returns the tag info for " do
        expect(list.tag_info).to eq({
          "tag" => "ul",
          "meta" => nil,
          "css_class" => nil,
        })
      end
    end

    context "with style 'numbered'" do
      it "returns the tag info for " do
        list = described_class.new({
          "type" => "list",
          "style" => "numbered",
          "children" => [],
        })

        expect(list.tag_info).to eq({
          "tag" => "ol",
          "meta" => nil,
          "css_class" => nil,
        })
      end
    end
  end

  describe "#wrappers" do
    it "returns nil" do
      expect(list.wrappers).to be_empty
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
