module DatoDast
  module Errors
    class InvalidMarksConfiguration < StandardError
      MESSAGE = <<~MSG.strip
        A mark configuration requires only the "tag" key.

        The following mark configurations are invalid:
      MSG

      def initialize(keys)
        super(MESSAGE + " " + keys.join(", "))
      end
    end
  end
end
