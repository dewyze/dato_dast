require "middleman_dato_dast/nodes/base"
require "middleman_dato_dast/nodes/span"
require "middleman_dato_dast/nodes/generic"
require "middleman_dato_dast/nodes/block"
require "middleman_dato_dast/nodes/attributed_quote"
require "middleman_dato_dast/nodes/blockquote"
require "middleman_dato_dast/nodes/code"
require "middleman_dato_dast/nodes/heading"
require "middleman_dato_dast/nodes/inline_item"
require "middleman_dato_dast/nodes/item_link"
require "middleman_dato_dast/nodes/link"
require "middleman_dato_dast/nodes/list"
require "middleman_dato_dast/nodes/list_item"
require "middleman_dato_dast/nodes/paragraph"
require "middleman_dato_dast/nodes/root"
require "middleman_dato_dast/nodes/thematic_break"


module MiddlemanDatoDast
  module Nodes
    def self.wrap(value)
      # TODO check if type exists

      type = value["type"]
      MiddlemanDatoDast.configuration.types[type]["node"].new(value)
    end
  end
end
