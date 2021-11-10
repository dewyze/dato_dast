module DatoDast
  module Errors
    class FieldMissing < StandardError
      MESSAGE = <<~MSG.strip
        A structure type of 'field' requires the block to have the specified field.

        The following configuration is invalid:
      MSG

      def initialize(item_type)
        super(MESSAGE + " " + item_type)
      end
    end
  end
end
