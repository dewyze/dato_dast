RSpec.describe MiddlemanDatoDast::Nodes::Span do
  subject(:span) { described_class.new(raw) }

  let(:raw) do
    {
      "type" => "span",
      "marks" => ["highlight", "emphasis"],
      "value" => "Some random text here, move on!"
    }
  end

  describe "#type" do
    it "returns 'span'" do
      expect(span.type).to eq("span")
    end
  end

  describe "#tag" do
    it "returns nil" do
      expect(span.tag).to be_nil
    end
  end

  describe "#marks" do
    it "returns ['highlight', 'emphasis']" do
      expect(span.marks).to contain_exactly("highlight", "emphasis")
    end
  end

  describe "#wrapper_tags" do
    it "returns nil" do
      expect(span.wrapper_tags).to eq(["mark", "em"])
    end
  end

  describe "#value" do
    it "subs <br/> for newline characters" do
      new_span = raw.merge({ "value" => "Hello\nWorld" })
      span = described_class.new(new_span)

      expect(span.value).to eq("Hello<br/>World")
    end
  end

  describe "#render" do
    it "returns the html string" do
      expect(span.render).to eq(<<~HTML.strip)
        <mark>
        <em>
        Some random text here, move on!
        </em>
        </mark>
      HTML
    end
  end
end
