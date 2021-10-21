module MiddlemanDatoDast
  class HtmlTag
    EMPTY = ""
    NEWLINE = "\n"

    def self.parse(tag)
      case tag
      when String
        new(tag)
      when Hash
        html_tag = tag["tag"]
        css_class = tag["css_class"]
        meta = tag["meta"]

        HtmlTag.new(html_tag, { "css_class" => css_class, "meta" => meta })
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
    end

    def open
      return EMPTY unless @tag

      "<#{@tag}#{css_class}#{meta}>" + NEWLINE
    end

    def close
      return EMPTY unless @tag

      NEWLINE + "</#{@tag}>"
    end

    private

    def css_class
      return "" unless @css_class.present?

      " class=\"#{@css_class}\""
    end

    def meta
      return "" if @meta.empty?

      @meta.inject("") do |html, pair|
        html + " #{pair["id"]}=\"#{pair["value"]}\""
      end
    end
  end
end
