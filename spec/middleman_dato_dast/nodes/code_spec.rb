RSpec.describe MiddlemanDatoDast::Nodes::Code do
  subject(:code) { described_class.new(raw) }

  let(:raw) do
    {
      "type" => "code",
      "language" => "javascript",
      "highlight" => [1],
      "code" => "function greetings() {\n  console.log('Hi!');\n}"
    }
  end

  describe "#type" do
    it "returns 'code'" do
      expect(code.type).to eq("code")
    end
  end

  describe "#tag_info" do
    it "returns the tag info" do
      expect(code.tag_info).to eq({
        "tag" => "code",
        "meta" => nil,
        "css_class" => nil,
      })
    end
  end

  describe "#wrappers" do
    it "returns 'pre'" do
      expect(code.wrappers).to eq(["pre"])
    end
  end

  describe "#language" do
    it "returns the language" do
      expect(code.language).to eq("javascript")
    end
  end

  describe "#code" do
    it "returns the code" do
      expect(code.code).to eq("function greetings() {<br/>  console.log('Hi!');<br/>}")
    end
  end

  describe "#render_value" do
    it "returns the code" do
      expect(code.render_value).to eq("function greetings() {<br/>  console.log('Hi!');<br/>}")
    end
  end

  describe "#render" do
    it "returns the html string" do
      expect(code.render).to eq(<<~HTML.strip)
        <pre>
        <code>
        function greetings() {<br/>  console.log('Hi!');<br/>}
        </code>
        </pre>
      HTML
    end
  end
end
