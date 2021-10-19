module MiddlemanDatoDast
  class HtmlTag
    def self.parse(tag)
      case tag
      when String, nil
        new(tag)
      when Hash
        html_tag = tag["tag"]
        classes = tag["class"]
        meta = tag["meta"]

        HtmlTag.new(html_tag, { "class" => classes, "meta" => meta })
      when HtmlTag
        tag
      else
        raise "BOOM"
      end
    end

    def initialize(tag, options = {})
      @tag = tag
      @classes = options["class"] || []
      @meta = options["meta"] || {}
    end

    def open
      "<#{@tag}#{classes}#{meta}>\n"
    end

    def close
      "\n</#{@tag}>"
    end

    private

    def classes
      return "" if @classes.empty?

      " class=\"#{@classes}\""
    end

    def meta
      return "" if @meta.empty?

      @meta.inject("") do |html, pair|
        html + " #{pair["id"]}=\"#{pair["value"]}\""
      end
    end
  end
end
