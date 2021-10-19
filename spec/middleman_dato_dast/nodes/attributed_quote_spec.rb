RSpec.describe MiddlemanDatoDast::Nodes::AttributedQuote do
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

  describe "#wrapper_tags" do
    it "returns 'figure'" do
      expect(blockquote.wrapper_tags).to be_empty
    end
  end

  describe "#render" do
    it "returns the html string" do
      expect(blockquote.render).to eq(<<~HTML)
      <figure>
      <blockquote>
      <p>
      Be yourself; everyone else is taken.
      </p>
      </blockquote>
      <figcaption>
      Oscar Wilde
      </figcaption>
      </figure>
      HTML
    end
  end
end
