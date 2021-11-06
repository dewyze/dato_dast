module MiddlemanDatoDast
  module Errors
    class BlockNodeMissingRenderFunction < StandardError
      MESSAGE = <<~MSG.strip
        A node class provided for a block must have a 'render' method.

        The node object for the following block item type is invalid:
      MSG

      def initialize(keys)
        super(MESSAGE + " " + keys.join(", "))
      end
    end
  end
end
