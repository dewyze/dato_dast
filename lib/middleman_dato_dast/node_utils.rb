module MiddlemanDatoDast
  module NodeUtils
    def wrap(value)
      # TODO check if type exists

      type = value["type"]
      config.nodes[type].new(value)
    end

    def config
      MiddlemanDatoDast.configuration
    end
  end
end
