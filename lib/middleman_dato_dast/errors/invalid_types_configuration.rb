module MiddlemanDatoDast
  module Errors
    class InvalidTypesConfiguration < StandardError
      MESSAGE = <<~MSG.strip
        A type configuration requires the "node" key.

        The following type configurations are invalid:
      MSG

      def initialize(keys)
        super(MESSAGE + " " + keys.join(", "))
      end
    end
  end
end
