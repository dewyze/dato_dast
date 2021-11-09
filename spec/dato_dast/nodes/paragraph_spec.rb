RSpec.describe DatoDast::Nodes::Paragraph do
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

  describe "#tag_info" do
    it "returns the tag info" do
      expect(paragraph.tag_info).to eq({
        "tag" => "p",
        "meta" => nil,
        "css_class" => nil,
      })
    end
  end

  describe "#wrappers" do
    it "returns nil" do
      expect(paragraph.wrappers).to be_empty
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
