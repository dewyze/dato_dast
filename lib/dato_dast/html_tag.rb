module DatoDast
  class HtmlTag
    EMPTY = ""
    NEWLINE = "\n"

    def self.parse(tag, object = nil)
      case tag
      when String
        new(tag)
      when Hash
        html_tag = tag["tag"]
        css_class = tag["css_class"]
        meta = tag["meta"]

        HtmlTag.new(html_tag, { "css_class" => css_class, "meta" => meta, "object" => object })
      when HtmlTag
        tag
      when nil
        HtmlTag.new(nil)
      else
        nil
      end
    end

    def initialize(tag, options = {})
      @tag = tag
      @css_class = options["css_class"] || ""
      @meta = options["meta"] || {}
      @object = options["object"]
    end

    def open
      return EMPTY unless tag

      "<#{tag}#{css_class}#{meta}>" + NEWLINE
    end

    def close
      return EMPTY unless tag

      NEWLINE + "</#{tag}>"
    end

    private

    def tag
      if @tag.is_a?(Proc)
        @tag.call(@object)
      else
        @tag
      end
    end

    def css_class
      return "" if @css_class.blank?

      klass = @css_class.is_a?(Proc) ? @css_class.call(@object) : @css_class

      " class=\"#{klass}\""
    end

    def meta
      return "" if @meta.blank?

      if @meta.is_a?(Proc)
        " " + @meta.call(@object)
      else
        @meta.reduce("") do |html, pair|
          html + " #{pair["id"]}=\"#{pair["value"]}\""
        end
      end
    end
  end
end
