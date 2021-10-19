RSpec.describe MiddlemanDatoDast::Nodes::Link do
  subject(:link) { described_class.new(raw) }

  let(:raw) do
    {
      "type" => "link",
      "url" => "https://www.datocms.com/",
      "meta" => [
        { "id" => "rel", "value" => "nofollow" },
        { "id" => "target", "value" => "_blank" },
      ],
      "children" => [
        {
          "type" => "span",
          "value" => "The best CMS in town"
        }
      ]
    }
  end

  describe "#type" do
    it "returns 'link'" do
      expect(link.type).to eq("link")
    end
  end

  describe "#tag" do
    it "returns 'a'" do
      expect(link.tag).to eq("a")
    end
  end

  describe "#url" do
    it "returns the url" do
      expect(link.url).to eq("https://www.datocms.com/")
    end
  end

  describe "#meta" do
    it "returns the meta fields" do
      meta=  [
        { "id" => "rel", "value" => "nofollow" },
        { "id" => "target", "value" => "_blank" },
      ]

      expect(link.meta).to eq(meta)
    end
  end

  describe "#wrapper_tags" do
    it "returns nil" do
      expect(link.wrapper_tags).to be_empty
    end
  end

  describe "#render" do
    it "returns the html string" do
      expect(link.render).to eq(<<~HTML.strip)
        <a href="https://www.datocms.com/" rel="nofollow" target="_blank">
        The best CMS in town
        </a>
      HTML
    end
  end
end
