require "dato_dast/nodes/base"
require "dato_dast/nodes/item"
require "dato_dast/nodes/span"
require "dato_dast/nodes/generic"
require "dato_dast/nodes/block"
require "dato_dast/nodes/attributed_quote"
require "dato_dast/nodes/blockquote"
require "dato_dast/nodes/code"
require "dato_dast/nodes/heading"
require "dato_dast/nodes/inline_item"
require "dato_dast/nodes/link"
require "dato_dast/nodes/item_link"
require "dato_dast/nodes/list"
require "dato_dast/nodes/list_item"
require "dato_dast/nodes/paragraph"
require "dato_dast/nodes/root"
require "dato_dast/nodes/thematic_break"
require "dato_dast/nodes/block"


module DatoDast
  module Nodes
    def self.wrap(value, links = [], blocks = [], config = nil)
      type = value["type"]
      configuration = config || DatoDast.configuration
      node_class = value["node"] || configuration.types[type]["node"]
      node_class.new(value, links, blocks, config)
    end
  end
end
