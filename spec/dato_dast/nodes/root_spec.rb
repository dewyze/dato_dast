RSpec.describe DatoDast::Nodes::Root do
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

  describe "#tag_info" do
    it "returns the tag info" do
      expect(root.tag_info).to eq({
        "tag" => "div",
        "meta" => nil,
        "css_class" => nil,
      })
    end
  end

  describe "#wrappers" do
    it "returns nil" do
      expect(root.wrappers).to be_empty
    end
  end

  describe "#render" do
    it "returns the html string" do
      expect(root.render).to eq(<<~HTML.strip)
        <div>
        <h1>
        Title
        </h1>
        <p>
        A simple paragraph!
        </p>
        </div>
      HTML
    end
  end
end
