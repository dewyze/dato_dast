RSpec.describe MiddlemanDatoDast::Nodes::Generic do
  subject(:code) { described_class.new(raw) }

  let(:raw) do
    {
      "type" => "generic",
      "tag" => "canvas",
      "wrapper_tags" => ["div"],
      "children" => [{ "type" => "span", "value" => "Hello world!" }],
    }
  end

  describe "#type" do
    it "returns 'code'" do
      expect(code.type).to eq("generic")
    end
  end

  describe "#tag" do
    it "returns 'code'" do
      expect(code.tag).to eq("canvas")
    end
  end

  describe "#wrapper_tags" do
    it "returns 'pre'" do
      expect(code.wrapper_tags).to eq(["div"])
    end
  end

  describe "#render" do
    it "returns the html string" do
      expect(code.render).to eq(<<~HTML.strip)
        <div>
        <canvas>
        Hello world!
        </canvas>
        </div>
      HTML
    end
  end
end
