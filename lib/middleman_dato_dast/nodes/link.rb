module MiddlemanDatoDast
  module Nodes
    class Link < Base
      NEW_WINDOW_META = [
        { "id" => "rel", "value" => "nofollow" },
        { "id" => "target", "value" => "_blank" },
      ].freeze

      def url
        @node["url"]
      end

      def meta
        fields = @node["meta"].dup || []
        fields.prepend({ "id" => "href", "value" => path })

        new_window? ? (fields + NEW_WINDOW_META).uniq : fields
      end

      def path
        local_url || uri.to_s
      end

      private

      def uri
        @uri ||= URI(url)
      end

      def smart_links?
        config.smart_links
      end

      def new_window?
        smart_links? && !local_url
      end

      def local_url
        return @local_url if defined?(@local_url)

        @local_url = if uri.host.nil?
          "/#{uri.to_s}"
        elsif smart_links? && uri.host == config.host
          uri.path
        end
      end
    end
  end
end
