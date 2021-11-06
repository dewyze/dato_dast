module MiddlemanDatoDast
  module Errors
    class InvalidBlocksConfiguration < StandardError
      MESSAGE = <<~MSG.strip
        A block configuration requires exactly one of the following keys:
        - "node"
        - "render_value"
        - "structure"

        The following block configurations are invalid:
      MSG

      def initialize(keys)
        super(MESSAGE + " " + keys.join(", "))
      end
    end
  end
end
