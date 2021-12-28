# DatoDast

`DatoDast` is a gem that provides a `structured_text(...)` rendering method and configuration options for rendering a [DatoCMS Dast](https://www.datocms.com/docs/structured-text/dast) document.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dato_dast'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install dato_dast

## Usage

The simplest use is the `DatoDast.structured_text` method, which can be used in view renderer.

```erb
# page => DatoCMS Object
# page.content => structured text field
<%= DatoDast.structured_text(page.content) %>
```

This will used the configuration object as defined below which can be put it in an initializer or a unique configuration can be provided to the structured_text method.

## Extensions

Currently the only extension supported is Middleman. You can include it by installing the gem and adding this to your `config.rb`:

```ruby
activate :dato_dast
```

Or you can provide configuration

```ruby
activate :dato_dast do |config|
    # See "Configuration Options" Below
end
```

## Configuration Options

You can configure DatoDast in something like an initializer:

```ruby
# initializers/dato_dast.rb

DatoDast.configure do |config|
  # configuration here
end
```

Or you can create a configuration object and pass it to the structured text method.

```ruby
config = DastDast::Configuration.new
# Set your configuration
DatoDast.structured_text(item, config)
```

### `DatoDast.configuration.duplicate`

If you want to temporarily override the existing configuration, you can
duplicate the current configuration and this method will return a configuration
object you can pass to `DatoDast.structured_text(text, configuration)` as the
configuration.

An example below:

```ruby
DatoDast.configure do |config|
  config.host = "https://example.com"
end

new_config = DatoDast.congfiguration.duplicate do |config|
  config.highlight = false
end

DatoDast.configuration.host # => example.com
DatoDast.configuration.highlight # => true

new_config.host # => example.com
new_config.highlight # => false
```

The configuration options are:

### `config.highlight`, default: `true`

Toggle whether to attempt to higlight code blocks. If the `middleman-syntax` gem is present, it is used by default to highlight a [`code`](https://www.datocms.com/docs/structured-text/dast#code) node in the structured text.

### `config.smart_links`, default: `true`

Smart links, in conjunction with the `host` option, will attempt to always open internal links in the same window with a relative url and external links in a new window.

### `config.host`, default: `nil`

Host for your site, used in conjunction with 'smart_links' option.

### `config.item_links`, default: `{},`

<details>

If you are using [`itemLinks`](https://www.datocms.com/docs/structured-text/dast#itemLink), you can use this configuration hash to define which field to call on the item to determine the url. For example, if you have a `page` model and a `slug` field that contains the url, you would use:

```ruby
DatoDast.configure do |config|
  config.item_links = {
    "page" => "slug",
  }
end
```

See [`itemLink`](#itemlink) for more details.

</details>

### `config.marks`

<details>

There are [six marks](`strong`, `code`, `emphasis`, `underline`, `strikethrough` and `highlight`) defined in the DatoCMS Dast spec.

The `config.marks` option allows you to customize the mark that is used, as well as add [`wrappers`](#wrappers) for a given tag.

The default configuration is:

```ruby
{
  "code" => { "tag" => "code" },
  "emphasis" => { "tag" => "em" },
  "highlight" => { "tag" => "mark" },
  "strikethrough" => { "tag" => "strike" },
  "strong" => { "tag" => "strong" },
  "underline" => { "tag" => "u" },
}
```

If you had a [`span`](https://www.datocms.com/docs/structured-text/dast#span) object that looked like this:

```json
{
  "type": "span",
  "marks": ["highlight", "emphasis"],
  "value": "Some random text here, move on!"
}
```

It would normally render as:

```html
<highlight>
  <emphasis>Some random text here, move on!</emphasis>
</highlight>
```

If we used the following configuration:

```ruby
DatoDast.configure do |config|
  config.marks = {
    "emphasis" => { "tag" => "i", "wrappers" => [{ "tag" => "div", "css_class" => "blue" }],
  }
end
```

This would use the `<i>` tag instead of `<emphasis>` and wrap that `<i>` tag with a `<div class="blue">` tag.

```html
<highlight>
  <div class="blue">
    <i>Some random text here, move on!</i>
  </div>
</highlight>
```

</details>

### `config.blocks`

The blocks configuration is a hash with a block `item_type` key and the block configuration. See the [Blocks And Inline Items](#blocks_and_inline_items) section for specific details on block configuration.

### `config.inline_items`

The inline items configuration is a hash with an inline_item `item_type` key and the inline_item configuration. See the [Blocks And Inline Items](#blocks_and_inline_items) section for specific details on block configuration.

### `config.types`

<details>

This is the configuration use for all of the default types. Each type configuration consists of the type key and a [`Node`](#nodes) value. Most of them have an html `tag` defined as well, and can take a [wrapper](#wrappers).

The default configuration is:

```ruby
TYPE_CONFIG = {
  "block" => { "node" => Nodes::Block },
  "blockquote" => { "tag" => "blockquote", "node" => Nodes::AttributedQuote },
  "code" => { "tag" => "code", "node" => Nodes::Code, "wrappers" => ["pre"] },
  "generic" => { "node" => Nodes::Generic },
  "heading" => { "tag" => ->(node) { "h#{node.level}" }, "node" => Nodes::Heading },
  "inlineItem" => { "node" => Nodes::InlineItem },
  "itemLink" => { "tag" => "a", "node" => Nodes::ItemLink, "url_key" => :slug },
  "link" => { "tag" => "a", "node" => Nodes::Link },
  "list" => { "tag" => ->(node) { node.style == "bulleted" ? "ul" : "ol" }, "node" => Nodes::List },
  "listItem" => { "tag" => "li", "node" => Nodes::ListItem },
  "paragraph" => { "tag" => "p", "node" => Nodes::Paragraph },
  "root" => { "tag" => "div", "node" => Nodes::Root },
  "span" => { "node" => Nodes::Span },
  "thematicBreak" => { "tag" => "hr", "node" => Nodes::ThematicBreak },
}
```

Each type configuration takes the following keys:
- `tag`: The default html tag to use. `nil` can be used to not use a key. Additionally you can provide a lambda that takes the Node object.
- `node`: This represents the Node object used for rendering. See [Nodes](#nodes) for more details.
- `css_class`: This is a string that is used in the `class=""` attribute of the tag. Additionally you can provide a lambda that takes the Node object.
- `meta`: This is an array of hashes matching the dast meta structure. E.g. Found in the [`link`](https://www.datocms.com/docs/structured-text/dast#link) node. Additionally you can provide a lamdbda that takes the Node object.
  - The structure is `{ "id" => "data-value", "value" => "1"}` renders as `<div data-value="1">`
- `wrappers`: This represents additional wrappers use to surrounded the given node type. See [Wrappers](#wrappers) for more details.

Some types have specific additional values.

See the individual [type configuration](#types) for each type.

</details>

## Types

Each node type may have its own configuration values and render in a unique way. Additionally, each type can override the [node](#nodes) with custom rendering functions. Below is a description of each type and its default rendering.

### `block`

<details>

Represents the [DatoCMS `block`](https://www.datocms.com/docs/structured-text/dast#block) node.

Blocks should be configured on a per-block basis. See the [Block](#blocks) section on how to configure specific blocks.

</details>

### `blockquote`

<details>

Represents the [DatoCMS `blockquote`](https://www.datocms.com/docs/structured-text/dast#blockquote) node.

With the following dast node:

```json
{
  "type": "blockquote",
  "attribution": "Oscar Wilde",
  "children": [
    {
      "type": "paragraph",
      "children": [
        {
          "type": "span",
          "value": "Be yourself; everyone else is taken."
        }
      ]
    }
  ]
}
```

This would be rendered using the `AttributedQuote` node, which would render as:

```html
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
```

This follows the [recommendation](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/blockquote) for blockquotes tags to only include the quote itself, and separate out the attribution.

If you want to use the basic `Blockquote` node, it would render as:
```html
<blockquote>
<p>
Be yourself; everyone else is taken.
</p>
</blockquote>
```

</details>

### `code`

<details>

Represents the [DatoCMS `code`](https://www.datocms.com/docs/structured-text/dast#code) node.

With the following dast node:

```json
{
  "type": "code",
  "language": "javascript",
  "highlight": [1],
  "code": "function greetings() {\n  console.log('Hi!');\n}"
}
```

If the `config.highlight` option is set to true, AND the `middleman-syntax` gem is present, it will use that highlighter and its default configuration to render the code.

If `config.highlight` is false OR the `middleman-syntax` gem is not preset, this would use the `Code` node which wraps a `<code>` line with a `<pre>` wrapper and would render as:

```html
<pre>
  <code>
    function greetings() {<br/>  console.log('Hi!');<br/>}
  </code>
</pre>
```

</details>

### `generic`

<details>

This node is not a part of the [DatoCMS Dast](https://www.datocms.com/docs/structured-text/dast) spec. Instead, it used a helper behind the scenes.

</details>

### `heading`

<details>

Represents the [DatoCMS `heading`](https://www.datocms.com/docs/structured-text/dast#heading) node.

With the following dast node:

```json
{
  "type": "heading",
  "level": 2,
  "children": [
    {
      "type": "span",
      "value": "An h2 heading!"
    }
  ]
}
```

This would be rendered using the `Heading` node, which would render as:

```html
<h2>
  An h2 heading!
</h2>
```

One note about the `Heading` node, is that it accepts a tag with a `#` symbol which it will use `gsub` on to replace with the `"level"` value.

</details>

### `inlineItem`

<details>

Represents the [DatoCMS `inlineItem`](https://www.datocms.com/docs/structured-text/dast#inlineItem) node.

Inline items should be configured on a per-item basis. See the [Block and Inline Items](#blocks_and_inline_items) section on how to configure specific inline items.

</details>

### `itemLink`

<details>

Represents the [DatoCMS `itemLink`](https://www.datocms.com/docs/structured-text/dast#itemLink) node.

The `itemLink` node requires a configuration to specify what field value should be called on the itemLink object to generate the url. It defaults to `slug` as the is the default name DatoCMS gives that field, but can be configured to anything.

With the following dast node:

```json
{
  "type": "itemLink",
  "item": "38945648",
  "meta": [
    { "id": "rel", "value": "nofollow" },
    { "id": "target", "value": "_blank" }
  ],
  "children": [
    {
      "type": "span",
      "value": "Matteo Giaccone"
    }
  ]
}
```

And an `links` array of:

```javascript
[{ id: "38945648", slug: "my-cool-page", item_type: "page" }]
```

This would be rendered using the `itemLink` node, which would render as:

```html
<a href="/my-cool-page" rel="nofollow" target="_blank">
  Matteo Giaccone
</a>
```

</details>

### `link`

<details>

Represents the [dato `link`](https://www.datocms.com/docs/structured-text/dast#link) node.

With the following dast node:

```json
{
  "type": "link",
  "url": "https://www.datocms.com/"
  "meta": [
    { "id": "rel", "value": "nofollow" },
    { "id": "target", "value": "_blank" }
  ],
  "children": [
    {
      "type": "span",
      "value": "The best CMS in town"
    }
  ]
}
```

This would be rendered using the `link` node, which would render as:

```html
<a href="https://www.datocms.com/link" rel="nofollow" target="_blank">
  The best CMS in town
</a>
```

</details>

#### Emails

Given the DatoCMS Structured text link does not have an option to input an email
address, this library will also compare the path against the
URI::MailTo::EMAIL_REGEXP and if it is a match, will prepend the `mailto:`
prefix.

### `list`

<details>

Represents the [DatoCMS `list`](https://www.datocms.com/docs/structured-text/dast#list) node.

The `list` node is special in that it has two subkeys of `bulleted` or `ordered` and each of those has its own node configuration.

With the following dast node:

```json
{
  "type": "list",
  "style": "bulleted",
  "children": [
    {
      "type": "listItem",
      "children": [
        {
          "type": "paragraph",
          "children": [
            {
              "type": "span",
              "value": "This is a list item!"
            }
          ]
        }
      ]
    }
  ]
}
```

This would be rendered using the `List` node, which would render as:

```html
<ul>
  <li>
    <p>
      This is a list item!
    </p>
  </li>
</ul>
```

</details>

### `listItem`

<details>

Represents the [DatoCMS `listItem`](https://www.datocms.com/docs/structured-text/dast#listItem) node.

With the following dast node:

```json
{
  "type": "listItem",
  "children": [
    {
      "type": "paragraph",
      "children": [
        {
          "type": "span",
          "value": "This is a list item!"
        }
      ]
    }
  ]
}
```

This would be rendered using the `ListItem` node, which would render as:

```html
<li>
  <p>
    This is a list item!
  </p>
</li>
```

</details>

### `paragraph`

<details>

Represents the [DatoCMS `paragraph`](https://www.datocms.com/docs/structured-text/dast#paragraph) node.

With the following dast node:

```json
{
  "type": "paragraph",
  "children": [
    {
      "type": "span",
      "value": "A simple paragraph!"
    }
  ]
}
```

This would be rendered using the `Paragraph` node, which would render as:

```html
<p>
  A simple paragraph!
</p>
```

</details>

### `root`

<details>

Represents the [DatoCMS `root`](https://www.datocms.com/docs/structured-text/dast#root) node.

With the following dast node:

```json
{
  "type": "root",
  "children": [
    {
      "type": "heading",
      "level": 1,
      "children": [
        {
          "type": "span",
          "value": "Title"
        }
      ]
    },
    {
      "type": "paragraph",
      "children": [
        {
          "type": "span",
          "value": "A simple paragraph!"
        }
      ]
    }
  ]
}
```

This would be rendered using the `Root` node, which would render as:

```html
<div>
  <h1>
    Title
  </h1>
  <p>
    A simple paragraph!
  </p>
</div>
```

</details>

### `span`

<details>

Represents the [DatoCMS `span`](https://www.datocms.com/docs/structured-text/dast#span) node.

With the following dast node:

```json
{
  "type": "span",
  "marks": ["highlight", "emphasis"],
  "value": "Some random text here, move on!"
}
```

This would be rendered using the `attributedquote` node, which would render as:

```html
<mark>
  <em>
    Some random text here, move on!
  </em>
</mark>
```

</details>

### `thematicBreak`

<details>

Represents the [DatoCMS `blockquote`](https://www.datocms.com/docs/structured-text/dast#block) node.

With the following dast node:

```json
{
  "type": "thematicBreak"
}
```

This would be rendered using the `ThematicBreak` node, which would render as:

```html
<hr/>
```

</details>

## Wrappers

Marks, Types, Inline Items, and Blocks all supports configuring a `wrappers` field.

The wrappers are rendered from the outside in, so the first wrapper will wrap the following wrappers.

A wrapper is made up of 3 parts: `tag`, `css_class`, and `meta`.

- `tag`: **Required**. The default html tag to use, or a proc that receive a node or block.
- `css_class`: **Optional**. This is a string that is used in the `class=""` attribute of the tag, or a proc that receive a node or block.
- `meta`: **Optional**. This is an array of hashes matching the dast meta
structure. E.g. Found in the [`link`](https://www.datocms.com/docs/structured-text/dast#link) node, or a proc that receive a node or block.
  - The structure is `{ "id" => "data-value", "value" => "1"}` renders as `<div data-value="1">`

## Nodes

All parts of the [DatoCMS
Dast](https://www.datocms.com/docs/structured-text/dast) spec are rendered using
a `Node` object. The default nodes are of the namespace `DatoDast::Nodes`.

A node must implement one of two methods:

- `render_value`
- `render`

### `render_value`

<details>

The render value method is used most commonly for the `Span` and `Code` nodes. It will still use the tags and wrappers defined in the configuration.

For example, the `Code` node, defines this as:

```ruby
def render_value
  @node["code"].gsub(/\n/, "<br/>")
end
```

So the rendered code replaces newlines with html line breaks, but it is still wrapped with a `<pre>` and `<code>` tag.

Additionally, for objects that have `children` according to the Dast specification, the `render_value` method just iterates over the children rendering each one.

</details>

### `render`

<details>

The default render method will render wrappers, the configured tag, and the `render_value` method. If you override the render method, you are taking responsibility for the complete rendering of a dast node and any of its children.

For example, the `ThematicBreak` node's render function is defined as:

```ruby
def render
  "<#{tag}/>\n"
end
```

As a result, the thematic break node can't be wrapped nor does it apply a specific tag.

Additionally, the `block` and `inlineItem` types have a specific render method for the complex rendering that items entail.

</details>

## Blocks and Inline Items

Blocks and Inline Items are the most powerful parts of structured text. We can take DatoCMS objects and render them in a specific way.

We refer to both blocks and inline items as "items". In the DatoCMS api, objects have an `item_type` and they are referred to instructured texts as `items` so the name seems a good fit.

**Configuration**

Blocks and Inline Items take the exact type of configuration, just under a different key:

```ruby
config = {...}
DatoDast.configure do |config|
  config.block = config
  config.inline_items = config
end
```

This is a valid configuration setup. However, blocks are typically a DatoCMS block, while Inline Items are typically a model. Additionally, inline items are rendered...well...inline, so you may want to render something different when it's in block form vs inline.

Items can take the same values as nodes. (One difference with items is that the item object is provided to the proc instead of the node when a Proc is provided.)

- `tag`: The default html tag to use. `nil` can be used to not use a key. Additionally you can provide a lambda that takes the Node object.
- `css_class`: This is a string that is used in the `class=""` attribute of the tag. Additionally you can provide a lambda that takes the Node object.
- `meta`: This is an array of hashes matching the dast meta structure. E.g. Found in the [`link`](https://www.datocms.com/docs/structured-text/dast#link) node. Additionally you can provide a lamdbda that takes the Node object.
  - The structure is `{ "id" => "data-value", "value" => "1"}` renders as `<div data-value="1">`
- `wrappers`: This represents additional wrappers use to surrounded the given node type. See [Wrappers](#wrappers) for more details.

The item configuration takes `item_type` value and you must provide one of three methods for rendering:

- `node`: This represents the Node object used for rendering. See [Nodes](#nodes) for more details.
- `render_value` : This represents a lambda that takes the item as an argument and returns the result of the lambda.
- `structure`: This is a hash structure for rendering complex setups without needing to use nodes.

### `node`

If you supply the `node` key, you must provide a class that takes the item hash as the only argument for `initialize` and has a `render` function.

<details>

For example:

```ruby
# Let's say we have an (abbreviated) Photo item that has a dato cms image under ":image" and a ":caption" string
# {
#   :id=>"1",
#   :item_type=>"photo",
#   :image => {
#     :id=>"2",
#     ...
#     :alt=>nil,
#     :url=>"https://www.datocms-assets.com/100/logo.png",
#   }
#   :caption=>"My Logo",
# }

class Photo
  def initialize(photo)
    @photo = photo
  end

  def alt
    @photo[:alt]
  end

  def url
    @photo[:url]
  end

  def caption
    @photo[:caption]
  end

  def render
    <<~HTML
    <img alt='#{alt}' src='#{url}' />
    <h3>#{caption}</h3>
    HTML
  end
end

DatoDast.configure do |config|
  config.blocks = {
    "photo" => { "node" => Photo },
  }
end
```

This node would render the following html:

```html
<img alt="My Logo" src="https://www.datocms-assets.com/100/logo.png" />
```

</details>

### `render_value`

`render_value` is a simpler form where you can supply a lamba that takes the hash object and it will render the lambda by calling it with the item hash.

<details>

```ruby
# Using the following item hash
# {
#   :id=>"1",
#   :item_type=>"photo",
#   :image => {
#     :id=>"2",
#     ...
#     :url=>"https://www.datocms-assets.com/100/logo.png",
#   }
# }

DatoDast.configure do |config|
  config.inline_items = {
    "photo" => {
      "render_value" => ->(item) { "<img src='#{item[:url]}' />" },
    }
  }
end
```

This would render the following html:

```html
<img src="https://www.datocms-assets.com/100/logo.png" />
```

</details>

### `structure`

The most powerful part of `DatoDast` is the `structure` tools for rendering items.

The `structure` configuration can be used on nested items or relationships to construct multiple tags.

The `structure` format is an array of hashes each with a "type" field. The "type" can be one of four values:

- `"field"`
- `"value"`
- `"item"`
- `"items"`

### `field`

<details>

When the type is `"field"`, then you also must provide a `"field"` value representing the field that you want to render. This would be used for fields that clearly implement the `to_s` method (strings, symbols, etc.).

```ruby
# With the object
# {
#   :id=>"1",
#   :item_type=>"photo",
#   :image => {
#     :id=>"100",
#     ...
#     :alt=>nil,
#     :url=>"https://www.datocms-assets.com/100/logo.png",
#   }
#   :caption=>"My Logo",
# }
DatoDast.configure do |config|
  config.blocks = {
    "photo" => {
      "wrappers" => [{ "tag" => "div", "css_class" => "caption" }],
      "structure" => [
        {
          "type" => "field",
          "field" => "caption",
          "tag" => "h1",
        },
      ],
    },
  }
end
```

Would render the following html:

```html
<div class="css_caption">
  <h1>My Logo</h1>
</div>
```

</details>

### `value`

<details>

When the type is `"value"`, then you also must provide a `"render_value"` function that takes the item hash as an argument and returns a string.

```ruby
# With the object
# {
#   :id=>"1",
#   :item_type=>"photo",
#   :image => {
#     :id=>"100",
#     ...
#     :alt=>nil,
#     :url=>"https://www.datocms-assets.com/100/logo.png",
#   }
#   :caption=>"My Logo",
# }
DatoDast.configure do |config|
  config.blocks = {
    "photo" => {
      "wrappers" => [{ "tag" => "div", "css_class" => "caption" }],
      "structure" => [
        {
          "type" => "value",
          "tag" => "span",
          "css_class" => "blue",
          "render_value" => ->(item) { item[:caption] },
        },
      ],
    },
  }
end
```

Would render the following html:

```html
<div class="css_caption">
  <span class="blue">My Logo</span>
</div>
```
</details>

### `item`

<details>

When the type is `"item"`, then you also must provide a `"field"` value that specifies the field which contains another item. That item will the be rendered using the same item configuration.

```ruby
# Let's imagine a card object with photo item relationship and caption
# {
#   :id=>"2",
#   :item_type => "card",
#   :photo => {
#     :id=>"1",
#     :item_type=>"photo",
#     :image => {
#       :id=>"100",
#       ...
#       :alt=>nil,
#       :url=>"https://www.datocms-assets.com/100/logo.png",
#     }
#   }
#   :caption=>"My Logo",
# }
DatoDast.configure do |config|
  config.inline_items = {
    "card" => {
      "wrappers" => {
        "tag" => "div",
        "css_class" => "card",
        "meta" => [{
          "id" => "data-card",
          "value" => "1",
        }],
      },
      "structure" => [
        {
          "type" => "item",
          "field" => "photo",
        },
        {
          "type" => "field",
          "field" => "caption",
          "tag" => "h2",
        },
      ],
    },
    "photo" => {
      "tag" => "div",
      "css_class" => "img",
      "render_value" => ->(item) { "<img src='#{item[:url]}' />" }
    }
  }
end
```

Would render the following html:

```html
<div class="card" data-card="1">
  <div class="img">
    <img src="https://www.datocms-assets.com/100/logo.png" />
  </div>
  <h2>My Logo</h2>
</div>
```

</details>

### `items`

<details>

When the type is `"items"`, then you also must provide a `"field"` value that specifies the field which contains an array of items. That item will the be rendered using the some item configuration.

```ruby
# Let's imagine a card object with photo item relationship and caption
# {
#   :id=>"2",
#   :item_type => "card",
#   :gallery => [
#     {
#       :id=>"1",
#       :item_type=>"photo",
#       :image => {
#         :id=>"100",
#         ...
#         :alt=>nil,
#         :url=>"https://www.datocms-assets.com/100/logo.png",
#       },
#     },
#     {
#       :id=>"3",
#       :item_type=>"photo",
#       :image => {
#         :id=>"300",
#         ...
#         :alt=>nil,
#         :url=>"https://www.datocms-assets.com/300/logo.png",
#       },
#     },
#   ],
#   :caption=>"My Logo",
# }
DatoDast.configure do |config|
  config.blocks = {
    "card" => {
      "wrappers" => {
        "tag" => "div",
        "css_class" => "card",
        "meta" => [{
          "id" => "data-card",
          "value" => "1",
        }],
      },
      "structure" => []
        {
          "type" => "items",
          "field" => "gallery",
          "tag" => "div",
          "css_class" => "gallery",
        },
        {
          "type" => "field",
          "field" => "caption",
          "tag" => "h2",
        },
      ],
    },
    "photo" => {
      "tag" => "div",
      "css_class" => "img",
      "render_value" => ->(item) { "<img src='#{item[:url]}' />" }
    }
  }
end
```

Would render the following html:

```html
<div class="card" data-card="1">
  <div class="gallery">
    <div class="img">
      <img src="https://www.datocms-assets.com/100/logo.png" />
    </div>
    <div class="img">
      <img src="https://www.datocms-assets.com/100/logo.png" />
    </div>
  </div>
  <h2>My Logo</h2>
</div>
```

</details>

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dewyze/dato_dast.
