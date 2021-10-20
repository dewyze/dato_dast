require "middleman-dato-dast"
require "middleman-core"

module MiddlemanDatoDast
  class MiddlemanExtension < Middleman::Extension
    option :types, {}, "Configuration hash for a given block node type"
    option :marks, {}, "Configuration hash for a given mark"

    def after_configuration
      MiddlemanDatoDast.configure do |config|
        config.types = options[:types]
        config.marks = options[:marks]
      end
    end

    helpers do
      def structured_text(object)
        Nodes.wrap(object[:value]["document"]).render
      end

      # TODO: process links/blocks and ensure there are node definitions
    end
  end
end

::Middleman::Extensions.register(:dato_dast, MiddlemanDatoDast::MiddlemanExtension)
