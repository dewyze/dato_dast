RSpec.describe DatoDast do
  class StructuredTextMock
    def initialize(value)
      @value = value
    end

    def to_hash
      {
        value: @value,
        links: [],
        blocks: [],
      }
    end
  end

  let(:document) do
    {
      "schema" => "dast",
      "document" => {
        "type" => "root",
        "children" => [
          {
            "type" => "span",
            "value" => "A simple paragraph!",
          },
        ],
      }
    }
  end

  describe "#structured_text" do
    it "renders a structured text field" do
      text = StructuredTextMock.new(document)

      expect(DatoDast.structured_text(text)).to eq(<<~HTML.strip)
      <div>
      A simple paragraph!
      </div>
      HTML
    end
  end
end
