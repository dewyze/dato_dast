module MiddlemanDatoDast
  module Nodes
    class ItemLink < Link
      def item_id
        @node["item"]
      end

      def item
        @links.find { |link| link[:id] == item_id }
      end

      def url
        item[url_key]
      end

      def item_type
        item[:item_type]
      end

      private

      def url_key
        # TODO if the url key does not exist

        config.item_links[item_type]
      end
    end
  end
end
