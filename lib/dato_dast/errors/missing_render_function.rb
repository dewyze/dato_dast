module DatoDast
  module Errors
    class MissingRenderFunction < StandardError
      MESSAGE = <<~MSG.strip
        A node class provided for an item must have a 'render' method.

        The node object for the following item type is invalid:
      MSG

      def initialize(keys)
        super(MESSAGE + " " + keys.join(", "))
      end
    end
  end
end
