module MiddlemanDatoDast
  class HtmlTag
    def initialize(tag, options = {})
      @tag = tag
      @classes = options[:classes] || []
      @meta = options[:meta] || {}
    end

    def open
      "<#{@tag}#{classes}#{meta}>\n"
    end

    def close
      "</#{@tag}>\n"
    end

    def classes
      return "" if @classes.empty?

      " " + @classes.join(" ")
    end

    def meta
      return "" if @meta.empty?

      @meta.inject(" ") do |html, pair|
        html + " #{pair["id"]}=\"#{pair["value"]}\""
      end
    end
  end
end
