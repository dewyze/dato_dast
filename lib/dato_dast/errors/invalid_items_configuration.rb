module DatoDast
  module Errors
    class InvalidItemsConfiguration < StandardError
      MESSAGE = <<~MSG.strip
        An item configuration requires exactly one of the following keys:
        - "node"
        - "render_value"
        - "structure"

        The following configurations are invalid:
      MSG

      def initialize(keys)
        super(MESSAGE + " " + keys.join(", "))
      end
    end
  end
end
