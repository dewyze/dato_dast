module MiddlemanDatoDast
  module Nodes
    class Link < Base
      def url
        @node["url"]
      end

      def meta
        @node["meta"]
      end

      def href
        " href=\"#{url}\""
      end

      def meta_attributes
        meta.inject("") do |html, pair|
          html + " #{pair["id"]}=\"#{pair["value"]}\""
        end
      end

      def render
        "<#{tag}#{href}#{meta_attributes}>#{render_children}</#{tag}>"
      end
    end
  end
end
