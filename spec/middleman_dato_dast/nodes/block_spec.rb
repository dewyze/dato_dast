RSpec.describe MiddlemanDatoDast::Nodes::Block do
  subject(:block) { described_class.new(raw, links, blocks) }

  let(:raw) do
    {
      "type" => "block",
      "item" => "1",
    }
  end
  let(:links) { [] }
  let(:blocks) do
    [image("1")]
  end

  def hero_gallery(id)
    {
      id: id,
      item_type: "hero_gallery",
      hero: hero(id + "1"),
      gallery: gallery(id + "2"),
    }
  end

  def hero(id)
    {
      id: id,
      item_type: "hero",
      title: "This is my hero title",
      subtitle: "And a little subtitle",
      image: dato_image(id + "10"),
    }
  end

  def gallery(id)
    {
      id: id,
      item_type: "gallery",
      title: "My Awesome gallery",
      url: "https://www.datocms.com",
      images: [ image(id + "21"), image(id + "22"), image(id + "23")],
    }
  end

  def image(id)
    {
      id: id,
      item_type: "image",
      caption: "This is not a pipe.",
      image: dato_image(id + "100"),
    }
  end

  def dato_image(id)
    {
      id: id,
      format: "png",
      size: 16529,
      width: 110,
      height: 109,
      alt: nil,
      url: "https://www.datocms-assets.com/#{id}/image.png",
    }
  end

  describe "#type" do
    it "returns 'block'" do
      configure({ "image" => { "structure" => [] } })

      expect(block.type).to eq("block")
    end
  end

  describe "#tag_info" do
    it "returns the tag info" do
      configure({
        "image" => {
          "tag" => "div",
          "meta" => [{ "id" => "data-value", "value" => "1" }],
          "css_class" => "blue",
          "render_value" => ->(_b) { "" },
        },
      })

      expect(block.tag_info).to eq({
        "tag" => "div",
        "meta" => [{ "id" => "data-value", "value" => "1" }],
        "css_class" => "blue",
      })
    end

    it "returns the tag info when procs are provided" do
      configure({
        "image" => {
          "tag" => ->(block) { "h1" },
          "css_class" => ->(block) { block[:item_type] },
          "render_value" => ->(_b) { "" },
        },
      })

      expect(block.tag_info).to eq({
        "tag" => "h1",
        "css_class" => "image",
        "meta" => nil,
      })
    end
  end

  describe "#children" do
    it "returns the children wrapped in a generic type" do
      configure({
        "gallery" => {
          "structure" => [
            {
              "type" => "blocks",
              "field" => "images",
            }
          ],
        },
      })

      raw = { "type" => "block", "item" => "1" }
      gallery = gallery("1")
      blocks = gallery[:images].map do |child|
        { "type" => "block", "item" => child[:id] }
      end
      children = [{
        "type" => "generic",
        "children" => blocks,
      }]

      block = described_class.new(raw, [], [gallery])

      expect(block.children).to eq(children)
    end

    it "throws an error if the structure is not a valid type" do
      configure({
        "gallery" => {
          "structure" => [
            {
              "type" => "foobar",
              "field" => "images",
            }
          ],
        },
      })

      raw = { "type" => "block", "item" => "1" }
      gallery = gallery("1")

      block = described_class.new(raw, [], [gallery])

      expect { block.children }.to raise_error(MiddlemanDatoDast::Errors::InvalidBlockStructureType)
    end
  end

  describe "#render_value" do
    it "calls a block if provided" do
      configure({
        "image" => {
          "render_value" => ->(block) { block[:caption] },
        },
      })

      expect(block.render_value).to eq("This is not a pipe.")
    end
  end

  describe "#render" do
    class TestNode
      def initialize(block); end
      def render
        "<div>Hello world!</div>"
      end
    end

    class InvalidNode
      def initialize(block); end
    end

    it "renders using a node's render method" do
      configure({
        "image" => { "node" => TestNode },
      })

      expect(block.render).to eq("<div>Hello world!</div>")
    end

    it "raises an invalid node error if there is no render method" do
      configure({
        "image" => { "node" => InvalidNode },
      })

      expect { block.render }.to raise_error(MiddlemanDatoDast::Errors::BlockNodeMissingRenderFunction)
    end

    it "raises an block field missing error if the structure type is field" do
      configure({
        "image" => {
          "structure" => {
            "type" => "field",
          },
        },
      })

      expect { block.render }.to raise_error(MiddlemanDatoDast::Errors::BlockFieldMissing)
    end

    it "raises an missing render value method error if the structure type is value" do
      configure({
        "image" => {
          "structure" => {
            "type" => "value",
          },
        },
      })

      expect { block.render }.to raise_error(MiddlemanDatoDast::Errors::MissingRenderValueFunction)
    end

    it "renders children" do
      configure({
        "gallery" => {
          "wrappers" => [{"tag" => "div", "css_class" => "blue"}],
          "structure" => [
            {
              "type" => "blocks",
              "field" => "images",
            }
          ],
        },
        "image" => {
          "render_value" => ->(block) {
            "<img src=\"#{block[:image][:url]}\" />"
          },
        },
      })

      raw = { "type" => "block", "item" => "1" }
      block = described_class.new(raw, [], [gallery("1")])

      expect(block.render).to eq(<<~HTML.strip)
        <div class="blue">
        <img src="https://www.datocms-assets.com/121100/image.png" />
        <img src="https://www.datocms-assets.com/122100/image.png" />
        <img src="https://www.datocms-assets.com/123100/image.png" />
        </div>
      HTML
    end

    it "renders using the render value method" do
      configure({
        "image" => {
          "tag" => "p",
          "css_class" => "blue",
          "meta" => [{ "id" => "data-value", "value" => "1" }],
          "render_value" => ->(block) { block[:caption] },
        },
      })

      expect(block.render).to eq(<<~HTML.strip)
        <p class=\"blue\" data-value=\"1\">
        This is not a pipe.
        </p>
      HTML
    end

    it "renders a display structure" do
      configure({
        "hero_gallery" => {
          "wrappers" => [{
            "tag" => "div",
            "css_class" => ->(block) { block[:item_type] },
            "meta" => [{ "id" => "data-value", "value" => "1" }],
          }],
          "structure" => [
            {
              "type" => "block",
              "field" => "hero",
            },
            {
              "type" => "block",
              "field" => "gallery",
            },
          ],
        },
        "hero" => {
          "wrappers" => [{
            "tag" => "div",
            "css_class" => "hero-wrapper",
            "meta" => [{ "id" => "data-value", "value" => "2" }],
          }],
          "render_value" => ->(block) {
            <<~HTML.strip
            <div style="background-image: url('#{block[:image][:url]}')">
            <h1>#{block[:title]}</h1>
            <h2>#{block[:subtitle]}</h2>
            </div>
            HTML
          },
        },
        "gallery" => {
          "wrappers" => [{
            "tag" => "div",
            "css_class" => "gallery",
            "meta" => [{ "id" => "data-value", "value" => "3" }],
          }],
          "structure" => [
            {
              "type" => "field",
              "field" => "title",
              "tag" => "span",
              "marks" => ["strong"],
              "css_class" => "gallery-title",
              "meta" => [{ "id" => "data-value", "value" => "5" }],
              "wrappers" => [{
                "tag" => "h3",
                "css_class" => "gallery-title-wrapper",
                "meta" => [{ "id" => "data-value", "value" => "4" }],
              }],
            },
            {
              "type" => "value",
              "wrappers" => [{
                "tag" => "div",
                "css_class" => "gallery-link",
                "meta" => [{ "id" => "data-value", "value" => "6" }],
              }],
              "render_value" => ->(block) {
                "<a href=\"#{block[:url]}\">#{block[:title]}</a>"
              },
            },
            {
              "type" => "blocks",
              "field" => "images",
              "tag" => "ul",
              "css_class" => "gallery-image-list",
              "meta" => [{ "id" => "data-value", "value" => "7" }],
            },
          ],
        },
        "image" => {
          "wrappers" => [{
            "tag" => "li",
            "css_class" => "gallery-image",
            "meta" => [{ "id" => "data-value", "value" => "8" }],
          }],
          "render_value" => ->(block) {
            "<img src=\"#{block[:image][:url]}\" />"
          },
        },
      })

      raw = { "type" => "block", "item" => "1" }
      block = described_class.new(raw, [], [hero_gallery("1")])

      expect(block.render).to eq(<<~HTML.strip)
        <div class="hero_gallery" data-value="1">
        <div class="hero-wrapper" data-value="2">
        <div style="background-image: url('https://www.datocms-assets.com/1110/image.png')">
        <h1>This is my hero title</h1>
        <h2>And a little subtitle</h2>
        </div>
        </div>
        <div class="gallery" data-value="3">
        <h3 class="gallery-title-wrapper" data-value="4">
        <strong>
        <span class="gallery-title" data-value="5">
        My Awesome gallery
        </span>
        </strong>
        </h3>
        <div class="gallery-link" data-value="6">
        <a href="https://www.datocms.com">My Awesome gallery</a>
        </div>
        <ul class="gallery-image-list" data-value="7">
        <li class="gallery-image" data-value="8">
        <img src="https://www.datocms-assets.com/1221100/image.png" />
        </li>
        <li class="gallery-image" data-value="8">
        <img src="https://www.datocms-assets.com/1222100/image.png" />
        </li>
        <li class="gallery-image" data-value="8">
        <img src="https://www.datocms-assets.com/1223100/image.png" />
        </li>
        </ul>
        </div>
        </div>
      HTML
    end
  end

  # describe "#render" do
  #   it "returns the html string" do
  #     expect(item_link.render).to eq(<<~HTML.strip)
  #       <a href="/my-cool-page" rel="nofollow" target="_blank">
  #       Matteo Giaccone
  #       </a>
  #     HTML
  #   end
  # end
  def configure(block_config)
    MiddlemanDatoDast.configure do |config|
      config.blocks = block_config
    end
  end
end
