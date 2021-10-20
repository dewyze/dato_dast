module MiddlemanDatoDast
  module NodeUtils
    def wrap(value)
      # TODO check if type exists

      type = value["type"]
      config.types[type]["node"].new(value)
    end

    def config
      MiddlemanDatoDast.configuration
    end
  end
end
