RSpec.describe MiddlemanDatoDast::Nodes::Paragraph do
  subject(:paragraph) { described_class.new(raw) }

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
      expect(paragraph.type).to eq("paragraph")
    end
  end

  describe "#tag" do
    it "returns 'p'" do
      expect(paragraph.tag).to eq("p")
    end
  end

  describe "#wrapper_tag" do
    it "returns nil" do
      expect(paragraph.wrapper_tag).to eq(nil)
    end
  end

  describe "#render" do
    it "returns the html string" do
      expect(paragraph.render).to eq(<<~HTML)
        <p>A simple paragraph!</p>
      HTML
    end
  end
end
