RSpec.describe DatoDast::Nodes::Link do
  subject(:link) { described_class.new(raw) }

  let(:raw) do
    {
      "type" => "link",
      "url" => "https://www.datocms.com/link",
      "meta" => [],
      "children" => [
        {
          "type" => "span",
          "value" => "The best CMS in town"
        }
      ]
    }
  end
  let(:meta_fields) do
    [
      { "id" => "rel", "value" => "nofollow" },
      { "id" => "target", "value" => "_blank" },
    ]
  end
  let(:external_url) { "https://www.google.com/link" }
  let(:internal_url) { "https://www.datocms.com/link" }
  let(:local_url) { "link" }

  def attributes(link)
    [{ "id" => "href", "value" => link }]
  end

  def new_window_attributes(link)
    attributes(link) + meta_fields
  end

  describe "#type" do
    it "returns 'link'" do
      expect(link.type).to eq("link")
    end
  end

  describe "#tag_info" do
    it "returns the tag info" do
      expect(link.tag_info).to eq({
        "tag" => "a",
        "meta" => new_window_attributes(internal_url),
        "css_class" => nil,
      })
    end
  end

  describe "#url" do
    it "returns the url value" do
      expect(link.url).to eq("https://www.datocms.com/link")
    end
  end

  describe "#path" do
    context "with smart links with a host value" do
      before do
        DatoDast.configure do |config|
          config.smart_links = true
          config.host = "https://www.datocms.com/"
        end
      end

      it "returns an absolute path for an external url" do
        raw["url"] = external_url
        link = described_class.new(raw)

        expect(link.path).to eq("https://www.google.com/link")
      end

      it "returns a local path for a local absolute url" do
        raw["url"] = internal_url
        link = described_class.new(raw)

        expect(link.path).to eq("/link")
      end

      it "returns a local path for a local url" do
        raw["url"] = local_url
        link = described_class.new(raw)

        expect(link.path).to eq("/link")
      end

      it "returns an email link for an email address with 'mailto'" do
        raw["url"] = "mailto:user@example.com"
        link = described_class.new(raw)

        expect(link.path).to eq("mailto:user@example.com")
      end

      it "returns an email link for an email address without 'mailto'" do
        raw["url"] = "user@example.com"
        link = described_class.new(raw)

        expect(link.path).to eq("mailto:user@example.com")
      end

      it "returns a telephone link for a telephone address with 'tel:'" do
        raw["url"] = "tel:1-234-567-8910"
        link = described_class.new(raw)

        expect(link.path).to eq("tel:1-234-567-8910")
      end
    end

    context "with smart links without a host value" do
      before do
        DatoDast.configure do |config|
          config.smart_links = true
        end
      end

      it "returns an absolute path for an external url" do
        raw["url"] = external_url
        link = described_class.new(raw)

        expect(link.path).to eq("https://www.google.com/link")
      end

      it "returns an absolute path for a local absolute url" do
        raw["url"] = internal_url
        link = described_class.new(raw)

        expect(link.path).to eq("https://www.datocms.com/link")
      end

      it "returns a local path for a local url" do
        raw["url"] = local_url
        link = described_class.new(raw)

        expect(link.path).to eq("/link")
      end
    end

    context "without smart links" do
      before do
        DatoDast.configure do |config|
          config.smart_links = false
        end
      end

      it "returns an absolute path for an external url" do
        raw["url"] = external_url
        link = described_class.new(raw)

        expect(link.path).to eq("https://www.google.com/link")
      end

      it "returns an absolute path for a local absolute url" do
        raw["url"] = internal_url
        link = described_class.new(raw)

        expect(link.path).to eq("https://www.datocms.com/link")
      end

      it "returns a local path for a local url" do
        raw["url"] = local_url
        link = described_class.new(raw)

        expect(link.path).to eq("/link")
      end
    end
  end


  describe "#meta" do
    context "with smart links with a host value" do
      before do
        DatoDast.configure do |config|
          config.smart_links = true
          config.host = "https://www.datocms.com/"
        end
      end

      it "returns new window fields for an external url" do
        raw["url"] = external_url
        link = described_class.new(raw)

        expect(link.meta).to eq(new_window_attributes(raw["url"]))
      end

      it "returns new window fields if they are explicit" do
        raw["url"] = internal_url
        raw["meta"] = meta_fields
        link = described_class.new(raw)

        expect(link.meta).to eq([
          { "id" => "href", "value" => "/link" },
          { "id" => "rel", "value" => "nofollow" },
          { "id" => "target", "value" => "_blank" },
        ])
      end

      it "does not return new window fields for absolute local url" do
        raw["url"] = internal_url
        link = described_class.new(raw)

        expect(link.meta).to eq([{ "id" => "href", "value" => "/link" }])
      end

      it "does not return new window fields for a local url" do
        raw["url"] = local_url
        link = described_class.new(raw)

        expect(link.meta).to eq([{ "id" => "href", "value" => "/link" }])
      end
    end

    context "with smart links without a host value" do
      before do
        DatoDast.configure do |config|
          config.smart_links = true
        end
      end

      it "returns new window fields for an external url" do
        raw["url"] = external_url
        link = described_class.new(raw)

        expect(link.meta).to eq([
          { "id" => "href", "value" => "https://www.google.com/link" },
          { "id" => "rel", "value" => "nofollow" },
          { "id" => "target", "value" => "_blank" },
        ])
      end

      it "returns new window fields if they are explicit" do
        raw["url"] = internal_url
        raw["meta"] = meta_fields
        link = described_class.new(raw)

        expect(link.meta).to eq([
          { "id" => "href", "value" => "https://www.datocms.com/link" },
          { "id" => "rel", "value" => "nofollow" },
          { "id" => "target", "value" => "_blank" },
        ])
      end

      it "returns new window fields for absolute local url" do
        raw["url"] = internal_url
        link = described_class.new(raw)

        expect(link.meta).to eq([
          { "id" => "href", "value" => "https://www.datocms.com/link" },
          { "id" => "rel", "value" => "nofollow" },
          { "id" => "target", "value" => "_blank" },
        ])
      end

      it "does not return new window fields for a local url" do
        raw["url"] = local_url
        link = described_class.new(raw)

        expect(link.meta).to eq([{ "id" => "href", "value" => "/link" }])
      end
    end

    context "without smart links" do
      before do
        DatoDast.configure do |config|
          config.smart_links = false
        end
      end

      it "returns new window fields for an external url" do
        raw["url"] = external_url
        link = described_class.new(raw)

        expect(link.meta).to eq([{ "id" => "href", "value" => "https://www.google.com/link" }])
      end

      it "returns new window fields if they are explicit" do
        raw["url"] = internal_url
        raw["meta"] = meta_fields
        link = described_class.new(raw)

        expect(link.meta).to eq([
          { "id" => "href", "value" => "https://www.datocms.com/link" },
          { "id" => "rel", "value" => "nofollow" },
          { "id" => "target", "value" => "_blank" },
        ])
      end

      it "returns new window fields for absolute local url" do
        raw["url"] = internal_url
        link = described_class.new(raw)

        expect(link.meta).to eq([{ "id" => "href", "value" => "https://www.datocms.com/link" }])
      end

      it "does not return new window fields for a local url" do
        raw["url"] = local_url
        link = described_class.new(raw)

        expect(link.meta).to eq([{ "id" => "href", "value" => "/link" }])
      end
    end
  end

  describe "#wrappers" do
    it "are empty" do
      expect(link.wrappers).to be_empty
    end
  end

  describe "#render" do
    before do
      DatoDast.configure do |config|
        config.smart_links = false
      end
    end

    it "returns the html string" do
      raw["meta"] = [{ "id" => "data-value", "value" => "1" }]
      link = described_class.new(raw)

      expect(link.render).to eq(<<~HTML.strip)
        <a href="https://www.datocms.com/link" data-value="1">
        The best CMS in town
        </a>
      HTML
    end
  end
end
