RSpec.describe DatoDast::HtmlTag do
  let(:string_tag) { described_class.parse("p") }
  let(:hash_tag) do
    described_class.parse({
      "tag" => "p",
      "css_class" => "blue mx-auto",
      "meta" => [{ "id" => "data-value", "value" => 1 }, { "id" => "data-id", "value" => 2 }],
    })
  end

  describe ".parse" do
    it "returns the tag when it's an HtmlTag" do
      html_tag = described_class.new("p")

      expect(described_class.parse(html_tag)).to eq(html_tag)
    end
  end

  describe "#open" do
    it "returns the open_tag" do
      expect(string_tag.open).to eq("<p>\n")
      expect(hash_tag.open).to eq("<p class=\"blue mx-auto\" data-value=\"1\" data-id=\"2\">\n")
    end
  end

  describe "#close" do
    it "returns the close_tag" do
      expect(string_tag.close).to eq("\n</p>")
      expect(hash_tag.close).to eq("\n</p>")
    end
  end
end
