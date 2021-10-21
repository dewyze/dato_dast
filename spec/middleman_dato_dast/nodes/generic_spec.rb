RSpec.describe MiddlemanDatoDast::Nodes::Generic do
  subject(:generic) { described_class.new(raw) }

  let(:raw) do
    {
      "type" => "generic",
      "tag" => "canvas",
      "wrappers" => ["div"],
      "children" => [{ "type" => "span", "value" => "Hello world!" }],
    }
  end

  describe "#type" do
    it "returns 'generic'" do
      expect(generic.type).to eq("generic")
    end
  end

  describe "#tag_info" do
    it "returns the tag info" do
      expect(generic.tag_info).to eq({
        "tag" => "canvas",
        "meta" => nil,
        "css_class" => nil,
      })
    end
  end

  describe "#wrappers" do
    it "returns 'pre'" do
      expect(generic.wrappers).to eq(["div"])
    end
  end

  describe "#render" do
    it "returns the html string" do
      expect(generic.render).to eq(<<~HTML.strip)
        <div>
        <canvas>
        Hello world!
        </canvas>
        </div>
      HTML
    end
  end
end
