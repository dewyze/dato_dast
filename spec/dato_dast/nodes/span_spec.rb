RSpec.describe DatoDast::Nodes::Span do
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

  describe "#tag_info" do
    it "returns the tag info" do
      expect(span.tag_info).to eq({
        "tag" => nil,
        "meta" => nil,
        "css_class" => nil,
      })
    end
  end

  describe "#marks" do
    it "returns ['highlight', 'emphasis']" do
      expect(span.marks).to contain_exactly("highlight", "emphasis")
    end
  end

  describe "#wrappers" do
    it "returns the wrappers" do
      expect(span.wrappers).to eq([{"tag" => "mark"}, {"tag" => "em"}])
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
