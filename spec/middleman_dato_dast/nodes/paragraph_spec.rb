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

  describe "#wrapper_tags" do
    it "returns nil" do
      expect(paragraph.wrapper_tags).to be_empty
    end
  end

  describe "#render" do
    it "returns the html string" do
      expect(paragraph.render).to eq(<<~HTML.strip)
        <p>
        A simple paragraph!
        </p>
      HTML
    end
  end
end
