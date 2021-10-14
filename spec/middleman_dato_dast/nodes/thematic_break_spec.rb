RSpec.describe MiddlemanDatoDast::Nodes::ThematicBreak do
  subject(:thematic_break) { described_class.new(raw) }

  let(:raw) do
    {
      "type" => "thematicBreak"
    }
  end

  describe "#type" do
    it "returns 'thematic_break'" do
      expect(thematic_break.type).to eq("thematicBreak")
    end
  end

  describe "#tag" do
    it "returns 'hr'" do
      expect(thematic_break.tag).to eq("hr")
    end
  end

  describe "#wrapper_tag" do
    it "returns nil" do
      expect(thematic_break.wrapper_tag).to eq(nil)
    end
  end

  describe "#render" do
    it "returns the html string" do
      expect(thematic_break.render).to eq("<hr/>\n")
    end
  end
end
