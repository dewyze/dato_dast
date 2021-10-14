RSpec.describe MiddlemanDatoDast::Nodes::Blockquote do
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

  describe "#tag" do
    it "returns 'blockquote'" do
      expect(blockquote.tag).to eq("blockquote")
    end
  end

  describe "#attribution" do
    it "returns the attribution" do
      expect(blockquote.attribution).to eq("Oscar Wilde")
    end
  end

  describe "#wrapper_tag" do
    it "returns 'figure'" do
      expect(blockquote.wrapper_tag).to eq("figure")
    end
  end

  describe "#attribution_tag" do
    it "returns 'figcaption'" do
      expect(blockquote.attribution_tag).to eq("figcaption")
    end
  end

  describe "#render" do
    it "returns the html string" do
      expect(blockquote.render).to eq(<<~HTML)
      <figure>
        <blockquote>
          <p>Be yourself; everyone else is taken.</p>
        </blockquote>
        <figcaption>Oscar Wilde</figcaption>
      </figure>
      HTML
    end
  end
end
