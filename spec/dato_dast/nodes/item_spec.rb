RSpec.describe DatoDast::Nodes::Item do
  subject(:item) { DatoDast::Nodes::Block.new(raw, links, items) }

  let(:raw) do
    {
      "type" => "block",
      "item" => "1",
    }
  end
  let(:links) { [] }
  let(:items) do
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

  describe "#tag_info" do
    it "returns the tag info" do
      configure_blocks({
        "image" => {
          "tag" => "div",
          "meta" => [{ "id" => "data-value", "value" => "1" }],
          "css_class" => "blue",
          "render_value" => ->(_b) { "" },
        },
      })

      expect(item.tag_info).to eq({
        "tag" => "div",
        "meta" => [{ "id" => "data-value", "value" => "1" }],
        "css_class" => "blue",
      })
    end

    it "returns the tag info when procs are provided" do
      configure_blocks({
        "image" => {
          "tag" => ->(item) { "h1" },
          "css_class" => ->(item) { item[:item_type] },
          "render_value" => ->(_b) { "" },
        },
      })

      expect(item.tag_info).to eq({
        "tag" => "h1",
        "css_class" => "image",
        "meta" => nil,
      })
    end
  end

  describe "#children" do
    it "returns the children wrapped in a generic type" do
      configure_blocks({
        "gallery" => {
          "structure" => [
            {
              "type" => "items",
              "field" => "images",
            }
          ],
        },
      })

      raw = { "type" => "block", "item" => "1" }
      gallery = gallery("1")
      item = DatoDast::Nodes::Block.new(raw, [], [gallery])

      items = gallery[:images].map do |child|
        { "type" => "block", "item" => child[:id] }
      end
      children = [{
        "type" => "generic",
        "children" => items,
      }]


      expect(item.children).to eq(children)
    end

    it "throws an error if the structure is not a valid type" do
      configure_blocks({
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

      item = DatoDast::Nodes::Block.new(raw, [], [gallery])

      expect { item.children }.to raise_error(DatoDast::Errors::InvalidStructureType, /block->gallery/)
    end
  end

  describe "#render_value" do
    it "calls a block if provided" do
      configure_blocks({
        "image" => {
          "render_value" => ->(item) { item[:caption] },
        },
      })

      expect(item.render_value).to eq("This is not a pipe.")
    end
  end

  describe "#render" do
    class TestNode
      def initialize(item); end
      def render
        "<div>Hello world!</div>"
      end
    end

    class InvalidNode
      def initialize(item); end
    end

    it "renders using a node's render method" do
      configure_blocks({
        "image" => { "node" => TestNode },
      })

      expect(item.render).to eq("<div>Hello world!</div>")
    end

    it "raises an invalid node error if there is no render method" do
      configure_blocks({
        "image" => { "node" => InvalidNode },
      })

      expect { item.render }.to raise_error(DatoDast::Errors::MissingRenderFunction, /block->image/)
    end

    it "raises an field missing error if the structure type is field" do
      configure_blocks({
        "image" => {
          "structure" => {
            "type" => "field",
          },
        },
      })

      expect { item.render }.to raise_error(DatoDast::Errors::FieldMissing, /block->image/)
    end

    it "raises an missing render value method error if the structure type is value" do
      configure_blocks({
        "image" => {
          "structure" => {
            "type" => "value",
          },
        },
      })

      expect { item.render }.to raise_error(DatoDast::Errors::MissingRenderValueFunction, /block->image/)
    end

    it "raises an missing item configuration error if the configuration is missing" do
      expect { item.render }.to raise_error(DatoDast::Errors::MissingItemConfiguration, /block->image/)
    end

    it "renders children" do
      configure_blocks({
        "gallery" => {
          "wrappers" => [{"tag" => "div", "css_class" => "blue"}],
          "structure" => [
            {
              "type" => "items",
              "field" => "images",
            }
          ],
        },
        "image" => {
          "render_value" => ->(item) {
            "<img src=\"#{item[:image][:url]}\" />"
          },
        },
      })

      raw = { "type" => "block", "item" => "1" }
      item = DatoDast::Nodes::Block.new(raw, [], [gallery("1")])

      expect(item.render).to eq(<<~HTML.strip)
        <div class="blue">
        <img src="https://www.datocms-assets.com/121100/image.png" />
        <img src="https://www.datocms-assets.com/122100/image.png" />
        <img src="https://www.datocms-assets.com/123100/image.png" />
        </div>
      HTML
    end

    it "renders children for inline items" do
      configure_inline_items({
        "gallery" => {
          "wrappers" => [{"tag" => "div", "css_class" => "blue"}],
          "structure" => [
            {
              "type" => "items",
              "field" => "images",
            }
          ],
        },
        "image" => {
          "render_value" => ->(item) {
            "<img src=\"#{item[:image][:url]}\" />"
          },
        },
      })

      raw = { "type" => "inlineItem", "item" => "1" }
      item = DatoDast::Nodes::InlineItem.new(raw, [gallery("1")], [])

      expect(item.render).to eq(<<~HTML.strip)
        <div class="blue">
        <img src="https://www.datocms-assets.com/121100/image.png" />
        <img src="https://www.datocms-assets.com/122100/image.png" />
        <img src="https://www.datocms-assets.com/123100/image.png" />
        </div>
      HTML
    end

    it "renders using the render value method" do
      configure_blocks({
        "image" => {
          "tag" => "p",
          "css_class" => "blue",
          "meta" => [{ "id" => "data-value", "value" => "1" }],
          "render_value" => ->(item) { item[:caption] },
        },
      })

      expect(item.render).to eq(<<~HTML.strip)
        <p class=\"blue\" data-value=\"1\">
        This is not a pipe.
        </p>
      HTML
    end

    it "renders a display structure" do
      configure_blocks({
        "hero_gallery" => {
          "wrappers" => [{
            "tag" => "div",
            "css_class" => ->(item) { item[:item_type] },
            "meta" => [{ "id" => "data-value", "value" => "1" }],
          }],
          "structure" => [
            {
              "type" => "item",
              "field" => "hero",
            },
            {
              "type" => "item",
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
          "render_value" => ->(item) {
            <<~HTML.strip
            <div style="background-image: url('#{item[:image][:url]}')">
            <h1>#{item[:title]}</h1>
            <h2>#{item[:subtitle]}</h2>
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
              "render_value" => ->(item) {
                "<a href=\"#{item[:url]}\">#{item[:title]}</a>"
              },
            },
            {
              "type" => "items",
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
          "render_value" => ->(item) {
            "<img src=\"#{item[:image][:url]}\" />"
          },
        },
      })

      raw = { "type" => "block", "item" => "1" }
      item = DatoDast::Nodes::Block.new(raw, [], [hero_gallery("1")])

      expect(item.render).to eq(<<~HTML.strip)
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

  def configure_blocks(item_config)
    DatoDast.configure do |config|
      config.blocks = item_config
    end
  end

  def configure_inline_items(item_config)
    DatoDast.configure do |config|
      config.inline_items = item_config
    end
  end
end
