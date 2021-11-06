# Middleman::Dato::Dast

`MiddlemanDatoDast` is a gem that provides a `structured_text(...)` rendering method and configuration options for rendering a [DatoCMS Dast](https://www.datocms.com/docs/structured-text/dast) document.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'middleman-dato-dast'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install middleman-dato-dast

In your `config.rb` then you can do the following:

```ruby
activate :dato_dast
```

Or you can provide configuration

```ruby
activate :dato_dast do |config|
    # See "Configuration" Below
end
```

## Usage

The simplest use is the `structured_text` helper, which can be used in view renderer.

```erb
# page => DatoCMS Object
# page.content => structured text field
<%= structured_text(page.content) %>
```

## Configuration Options

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
MiddlemanDatoDast.configure do |config|
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
MiddlemanDatoDast.configure do |config|
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
  "heading" => { "tag" => "h#", "node" => Nodes::Heading },
  "itemLink" => { "tag" => "a", "node" => Nodes::ItemLink, "url_key" => :slug },
  "link" => { "tag" => "a", "node" => Nodes::Link },
  "list" => {
    "bulleted" => { "tag" => "ul", "node" => Nodes::List },
    "numbered" => { "tag" => "ol", "node" => Nodes::List },
  },
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

Marks, Types, and Blocks all supports configuring a `wrappers` field.

The wrappers are rendered from the outside in, so the first wrapper will wrap the following wrappers.

A wrapper is made up of 3 parts: `tag`, `css_class`, and `meta`.

- `tag`: **Required**. The default html tag to use, or a proc that receive a node or block.
- `css_class`: **Optional**. This is a string that is used in the `class=""` attribute of the tag, or a proc that receive a node or block.
- `meta`: **Optional**. This is an array of hashes matching the dast meta
structure. E.g. Found in the [`link`](https://www.datocms.com/docs/structured-text/dast#link) node, or a proc that receive a node or block.
  - The structure is `{ "id" => "data-value", "value" => "1"}` renders as `<div data-value="1">`

## Nodes

All parts of the [DatoCMS Dast](https://www.datocms.com/docs/structured-text/dast) spec are rendered using a `Node` object. The default nodes are of the namespace `MiddlemanDatoDast::Nodes`.

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

Additionally, the `block` type has a specific render method for the complex rendering that blocks entail.

</details>

## Blocks

Blocks are the most powerful parts of structured text. We can take objects and render them in a specific way.

Blocks can take the same values as nodes. One difference with blocks is that the block object is provided to the proc instead of the node when a Proc is provided.

- `tag`
- `css_class`
- `meta`

The block configuration takes `item_type` value and you must provide one of three methods for rendering:

- `node`
- `render_value`
- `structure`

### `node`

If you supply the `node` key, you must provide a class that takes the block hash as the only argument for `initialize` and has a `render` function.

<details>

For example:

```ruby
# Let's say we have an (abbreviated) Photo block that has a dato cms image under ":image" and a ":caption" string
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

MiddlemanDatoDast.configure do |config|
  config.blocks = {
    "photo" => { "node" => photo },
  }
end
```

This node would render the following html:

```html
<img alt="My Logo" src="https://www.datocms-assets.com/100/logo.png" />
```

</details>

### `render_value`

`render_value` is a simpler form where you can supply a lamba that takes the hash object and it will render the lambda by calling it with the block hash.

<details>

```ruby
# Using the following block hash
# {
#   :id=>"1",
#   :item_type=>"photo",
#   :image => {
#     :id=>"2",
#     ...
#     :url=>"https://www.datocms-assets.com/100/logo.png",
#   }
# }

MiddlemanDatoDast.configure do |config|
  config.blocks = {
    "photo" => {
      "render_value" => ->(block) { "<img src='#{block[:url]}' />" },
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

The most powerful part of `MiddlemanDatoDast` is the `structure` tools for rendering blocks.

The `structure` configuration can be used on nested blocks or relationships to construct multiple tags.

The `structure` format is an array of hashes each with a "type" field. The "type" can be one of four values:

- `"field"`
- `"value"`
- `"block"`
- `"blocks"`

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
MiddlemanDatoDast.configure do |config|
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

When the type is `"value"`, then you also must provide a `"render_value"` function that takes the block hash as an argument and returns a string.

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
MiddlemanDatoDast.configure do |config|
  config.blocks = {
    "photo" => {
      "wrappers" => [{ "tag" => "div", "css_class" => "caption" }],
      "structure" => [
        {
          "type" => "value",
          "tag" => "span",
          "css_class" => "blue",
          "render_value" => ->(block) { block[:caption] },
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

### `block`

<details>

When the type is `"block"`, then you also must provide a `"field"` value that specifies the field which contains another block. That block will the be rendered using the some block configuration.

```ruby
# Let's imagine a card object with photo block relationship and caption
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
MiddlemanDatoDast.configure do |config|
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
          "type" => "block",
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
      "render_value" => ->(block) { "<img src='#{block[:url]}' />" }
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

### `blocks`

<details>

When the type is `"blocks"`, then you also must provide a `"field"` value that specifies the field which contains an array of blocks. That block will the be rendered using the some block configuration.

```ruby
# Let's imagine a card object with photo block relationship and caption
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
MiddlemanDatoDast.configure do |config|
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
          "type" => "block",
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
      "render_value" => ->(block) { "<img src='#{block[:url]}' />" }
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

Bug reports and pull requests are welcome on GitHub at https://github.com/[dewyze]/middleman-dato-dast.
