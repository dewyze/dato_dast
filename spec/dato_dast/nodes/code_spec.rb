RSpec.describe DatoDast::Nodes::Code do
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
      expect(code.code).to eq("function greetings() {\n  console.log('Hi!');\n}")
    end
  end

  describe "#render_value" do
    it "returns the code" do
      expect(code.render_value).to eq("function greetings() {<br/>  console.log('Hi!');<br/>}")
    end
  end

  describe "#render" do
    context "with no highlighter defined" do
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

    context "with middleman-syntax defined" do
      class Highlighter
        def self.highlight(code, lang, _options)
          <<~HTML.strip
          <div class="highlight #{lang}">
          #{code}
          </div>
          HTML
        end
      end

      it "calls the highlighter method" do
        stub_const("::Middleman::Syntax::SyntaxExtension", Object)
        stub_const("::Middleman::Syntax::Highlighter", Highlighter)

        expect(code.render).to eq(<<~HTML.strip)
          <div class="highlight javascript">
          function greetings() {
            console.log('Hi!');
          }
          </div>
        HTML
      end

      it "doesn't call the highlighter if configured off" do
        DatoDast.configure { |config| config.highlight = false }

        stub_const("::Middleman::Syntax::SyntaxExtension", Object)

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
end
