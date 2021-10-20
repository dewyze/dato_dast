require "middleman-dato-dast"
require "middleman-core"

module MiddlemanDatoDast
  class MiddlemanExtension < Middleman::Extension
    option :types, {}, "Configuration hash for a given block node type"
    option :item_links, {}, "Configuration hash item links types and the url field"
    option :marks, {}, "Configuration hash for a given mark"

    def after_configuration
      MiddlemanDatoDast.configure do |config|
        config.types = options[:types]
        config.marks = options[:marks]
        config.item_links = options[:item_links]
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
