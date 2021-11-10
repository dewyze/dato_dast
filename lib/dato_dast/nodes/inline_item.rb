module DatoDast
  module Nodes
    class InlineItem < Item
      def item_repo
        @links
      end

      def node_config
        config.inline_items[item_type]
      end
    end
  end
end
