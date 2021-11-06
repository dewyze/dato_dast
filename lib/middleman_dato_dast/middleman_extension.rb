require "middleman-dato-dast"
require "middleman-core"

module MiddlemanDatoDast
  class MiddlemanExtension < Middleman::Extension
    option :blocks, {}, "Configuration hash for blocks"
    option :host, nil, "Host for your site, used in conjunction with 'smart_links' option"
    option :highlight, true, "Toggle whether to attempt to higlight code blocks"
    option :item_links, {}, "Configuration hash item links types and the url field"
    option :marks, {}, "Configuration hash for a given mark"
    option :smart_links, true, "Open Link items in new windows and ItemLinks in the same window"
    option :types, {}, "Configuration hash for a given block node type"

    def after_configuration
      MiddlemanDatoDast.configure do |config|
        config.blocks = options[:blocks]
        config.highlight = options[:highlight]
        config.host = options[:host]
        config.item_links = options[:item_links]
        config.marks = options[:marks]
        config.smart_links = options[:smart_links]
        config.types = options[:types]
      end
    end

    helpers do
      def structured_text(object, config = nil)
        document = object[:value]["document"]
        links = object[:links]
        blocks = object[:blocks]

        Nodes.wrap(document, links, blocks, config).render
      end
    end
  end
end

::Middleman::Extensions.register(:dato_dast, MiddlemanDatoDast::MiddlemanExtension)
