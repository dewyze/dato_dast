RSpec.describe MiddlemanDatoDast::Nodes::ListItem do
  subject(:list) { described_class.new(raw) }

  let(:raw) do
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
  end

  describe "#type" do
    it "returns 'listItem'" do
      expect(list.type).to eq("listItem")
    end
  end

  describe "#tag_info" do
    it "returns the tag info" do
      expect(list.tag_info).to eq({
        "tag" => "li",
        "meta" => nil,
        "css_class" => nil,
      })
    end
  end

  describe "#wrappers" do
    it "returns nil" do
      expect(list.wrappers).to be_empty
    end
  end

  describe "#render" do
    it "returns the html string" do
      expect(list.render).to eq(<<~HTML.strip)
        <li>
        <p>
        This is a list item!
        </p>
        </li>
      HTML
    end
  end
end
