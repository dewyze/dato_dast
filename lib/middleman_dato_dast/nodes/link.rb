module MiddlemanDatoDast
  module Nodes
    class Link < Base
      def url
        @node["url"]
      end

      def meta
        @node["meta"] || {}
      end

      def href
        " href=\"#{url}\""
      end

      def meta_attributes
        meta.inject(href) do |html, pair|
          html + " #{pair["id"]}=\"#{pair["value"]}\""
        end
      end

      def render
        <<~HTML.chomp
        <#{tag}#{meta_attributes}>
        #{render_children}
        </#{tag}>
        HTML
      end
    end
  end
end
