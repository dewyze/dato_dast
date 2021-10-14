module MiddlemanDatoDast
  module NodeUtils
    def wrap(value)
      # TODO check for custom type

      type = value["type"]
      node_class(type).new(value)
    end

    def config
      MiddlemanDatoDast.configuration
    end

    private

    def node_class(type)
      "MiddlemanDatoDast::Nodes::#{type.camelize}".constantize
    end
  end
end
