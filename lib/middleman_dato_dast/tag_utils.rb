module MiddlemanDatoDast
  module TagUtils
    SELF_CLOSING_TAGS = %w(hr img)

    def self.self_closing?(tag)
      SELF_CLOSING_TAGS.include?(tag)
    end
  end
end
