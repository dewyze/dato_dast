RSpec.describe DatoDast::Nodes::Blockquote do
  subject(:blockquote) { described_class.new(raw) }

  let(:raw) do
    {
      "type" => "blockquote",
      "attribution" => "Oscar Wilde",
      "children" => [
        {
          "type" => "paragraph",
          "children" => [
            {
              "type" => "span",
              "value" => "Be yourself; everyone else is taken."
            }
          ]
        }
      ]
    }
  end

  describe "#type" do
    it "returns 'blockquote'" do
      expect(blockquote.type).to eq("blockquote")
    end
  end

  describe "#tag_info" do
    it "returns the tag info" do
      expect(blockquote.tag_info).to eq({
        "tag" => "blockquote",
        "meta" => nil,
        "css_class" => nil,
      })
    end
  end

  describe "#wrappers" do
    it "returns 'figure'" do
      expect(blockquote.wrappers).to be_empty
    end
  end

  describe "#render" do
    it "returns the html string" do
      expect(blockquote.render).to eq(<<~HTML.strip)
      <blockquote>
      <p>
      Be yourself; everyone else is taken.
      </p>
      </blockquote>
      HTML
    end
  end
end
