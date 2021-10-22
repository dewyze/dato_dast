require "middleman-dato-dast"
require "middleman-core"

module MiddlemanDatoDast
  class MiddlemanExtension < Middleman::Extension
    option :types, {}, "Configuration hash for a given block node type"
    option :marks, {}, "Configuration hash for a given mark"
    option :item_links, {}, "Configuration hash item links types and the url field"
    option :blocks, {}, "Configuration hash for blocks"
    option :smart_links, true, "Open Link items in new windows and ItemLinks in the same window"
    option :host, nil, "Host for your site, used in conjunction with 'smart_links' option"

    def after_configuration
      MiddlemanDatoDast.configure do |config|
        config.types = options[:types]
        config.marks = options[:marks]
        config.item_links = options[:item_links]
        config.smart_links = options[:smart_links]
        config.host = options[:host]
        config.blocks = options[:blocks]
      end
    end

    helpers do
      def structured_text(object)
        document = object[:value]["document"]
        links = object[:links]
        blocks = object[:blocks]

        Nodes.wrap(document, links, blocks).render
      end

      # TODO: process links/blocks and ensure there are node definitions
    end
  end
end

::Middleman::Extensions.register(:dato_dast, MiddlemanDatoDast::MiddlemanExtension)
