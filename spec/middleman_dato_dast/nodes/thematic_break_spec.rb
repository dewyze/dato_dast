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

  describe "#tag_info" do
    it "returns the tag info" do
      expect(thematic_break.tag_info).to eq({
        "tag" => "hr",
        "meta" => nil,
        "css_class" => nil,
      })
    end
  end

  describe "#wrappers" do
    it "are empty" do
      expect(thematic_break.wrappers).to be_empty
    end
  end

  describe "#render" do
    it "returns the html string" do
      expect(thematic_break.render).to eq("<hr/>\n")
    end
  end
end
