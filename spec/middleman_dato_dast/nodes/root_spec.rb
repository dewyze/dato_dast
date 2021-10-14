RSpec.describe MiddlemanDatoDast::Nodes::Root do
  subject(:root) { described_class.new(raw) }

  let(:raw) do
    {
      "type" => "root",
      "children" => [
        {
          "type" => "heading",
          "level" => 1,
          "children" => [
            {
              "type" => "span",
              "value" => "Title"
            }
          ]
        },
        {
          "type" => "paragraph",
          "children" => [
            {
              "type" => "span",
              "value" => "A simple paragraph!"
            }
          ]
        }
      ]
    }
  end

  describe "#type" do
    it "returns 'root'" do
      expect(root.type).to eq("root")
    end
  end

  describe "#tag" do
    it "returns 'root'" do
      expect(root.tag).to eq("div")
    end
  end

  describe "#wrapper_tag" do
    it "returns nil" do
      expect(root.wrapper_tag).to eq(nil)
    end
  end

  describe "#render" do
    it "returns the html string" do
      expect(root.render).to eq(<<~HTML)
        <div>
          <h1>Title</h1>
          <p>A simple paragraph!</p>
        </div>
      HTML
    end
  end
end
