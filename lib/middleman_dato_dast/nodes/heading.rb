module MiddlemanDatoDast
  module Nodes
    class Heading < Base
      def level
        @node["level"]
      end

      def tag
        # TODO: Warn if tag is not present
        return @tag if defined?(@tag)

        # TODO: Lamba for using level?
        base_tag = MiddlemanDatoDast.configuration.node_tags[type]
        @tag = base_tag.gsub(/#/, level.to_s)
      end
    end
  end
end
