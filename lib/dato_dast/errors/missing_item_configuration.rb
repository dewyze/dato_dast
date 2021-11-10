module DatoDast
  module Errors
    class MissingItemConfiguration < StandardError
      MESSAGE = <<~MSG.strip
        An configuration must be provided for every item type.

        The configuration for the following item type is invalid:
      MSG

      def initialize(key)
        super(MESSAGE + " " + key)
      end
    end
  end
end
