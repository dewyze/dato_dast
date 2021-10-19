RSpec.describe MiddlemanDatoDast::Nodes::Heading do
  subject(:heading) { described_class.new(raw) }

  let(:raw) do
    {
      "type" => "heading",
      "level" => 2,
      "children" => [
        {
          "type" => "span",
          "value" => "An h2 heading!"
        }
      ],
    }
  end

  describe "#type" do
    it "returns 'heading'" do
      expect(heading.type).to eq("heading")
    end
  end

  describe "#tag" do
    it "returns 'h2'" do
      expect(heading.tag).to eq("h2")
    end
  end

  describe "#level" do
    it "returns the level" do
      expect(heading.level).to eq(2)
    end
  end

  describe "#wrapper_tags" do
    it "returns nil" do
      expect(heading.wrapper_tags).to be_empty
    end
  end

  describe "#render" do
    it "returns the html string" do
      expect(heading.render).to eq(<<~HTML.strip)
        <h2>
        An h2 heading!
        </h2>
      HTML
    end
  end
end
