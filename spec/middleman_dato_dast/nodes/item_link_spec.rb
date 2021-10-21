RSpec.describe MiddlemanDatoDast::Nodes::ItemLink do
  subject(:item_link) { described_class.new(raw, links) }

  let(:raw) do
    {
      "type" => "itemLink",
      "item" => "38945648",
      "meta" => [
        { "id" => "rel", "value" => "nofollow" },
        { "id" => "target", "value" => "_blank" }
      ],
      "children" => [
        {
          "type" => "span",
          "value" => "Matteo Giaccone"
        }
      ]
    }
  end

  let(:links) { [{ id: "38945648", slug: "my-cool-page", item_type: "page" }] }

  before do
    MiddlemanDatoDast.configure do |config|
      config.item_links = { "page" => :slug }
    end
  end

  describe "#type" do
    it "returns 'itemLink'" do
      expect(item_link.type).to eq("itemLink")
    end
  end

  describe "#tag" do
    it "returns 'a'" do
      expect(item_link.tag).to eq("a")
    end
  end

  describe "#url" do
    it "returns the url" do
      expect(item_link.url).to eq("my-cool-page")
    end
  end

  describe "#path" do
    it "returns a relative path" do
      expect(item_link.path).to eq("/my-cool-page")
    end
  end

  describe "#meta" do
    it "returns the meta fields" do
      meta=  [
        { "id" => "rel", "value" => "nofollow" },
        { "id" => "target", "value" => "_blank" },
      ]

      expect(item_link.meta).to eq(meta)
    end
  end

  describe "#wrapper_tags" do
    it "returns nil" do
      expect(item_link.wrapper_tags).to be_empty
    end
  end

  describe "#render" do
    it "returns the html string" do
      expect(item_link.render).to eq(<<~HTML.strip)
        <a href="/my-cool-page" rel="nofollow" target="_blank">
        Matteo Giaccone
        </a>
      HTML
    end
  end
end
