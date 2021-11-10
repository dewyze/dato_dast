module DatoDast
  module Nodes
    class Block < Item
      def item_repo
        @blocks
      end

      def node_config
        config.blocks[item_type]
      end
    end
  end
end
