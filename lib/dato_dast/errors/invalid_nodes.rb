module DatoDast
  module Errors
    class InvalidNodes < StandardError
      MESSAGE = <<~MSG.strip
        A node class must have a 'render' instance method.

        The node objects for the following types are invalid:
      MSG

      def initialize(keys)
        super(MESSAGE + " " + keys.join(", "))
      end
    end
  end
end
