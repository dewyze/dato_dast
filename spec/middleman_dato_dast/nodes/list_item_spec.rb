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

  describe "#tag" do
    it "returns 'li'" do
      expect(list.tag).to eq("li")
    end
  end

  describe "#wrapper_tag" do
    it "returns nil" do
      expect(list.wrapper_tag).to eq(nil)
    end
  end

  describe "#render" do
    it "returns the html string" do
      expect(list.render).to eq(<<~HTML)
        <li><p>This is a list item!</p></li>
      HTML
    end
  end
end
