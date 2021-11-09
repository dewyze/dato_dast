module DatoDast
  module Nodes
    class Code < Base
      def language
        @node["language"]
      end

      def code
        @node["code"]
      end

      def render
        if highlighter?
          highlight
        else
          super
        end
      end

      def render_value
        code.gsub(/\n/, "<br/>")
      end

      private

      def highlighter?
        config.highlight && defined?(::Middleman::Syntax::SyntaxExtension)
      end

      def highlight
        Middleman::Syntax::Highlighter.highlight(code, language, {}).html_safe
      end
    end
  end
end
