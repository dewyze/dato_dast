# => {:value=>{"schema"=>"dast", "document"=>{"type"=>"root", "children"=>[{"item"=>"67125455", "type"=>"block"}, {"type"=>"paragraph", "children"=>[{"type"=>"span", "value"=>""}]}]}},
#  :links=>[],
#  :blocks=>
#   [{:id=>"67125455",
#     :item_type=>"image",
#     :updated_at=>2021-10-21 21:21:47.499 UTC,
#     :created_at=>2021-10-21 21:21:47.496 UTC,
#     :image=>
#      {:id=>"23872879",
#       :format=>"png",
#       :size=>16529,
#       :width=>110,
#       :height=>109,
#       :alt=>nil,
#       :title=>nil,
#       :custom_data=>{},
#       :focal_point=>nil,
#       :url=>"https://www.datocms-assets.com/2479/1631548199-site-logo.png",
#       :copyright=>nil,
#       :tags=>[],
#       :smart_tags=>[],
#       :filename=>"site-logo.png",
#       :basename=>"site-logo",
#       :is_image=>true,
#       :exif_info=>{},
#       :mime_type=>"image/png",
#       :colors=>
#        [{:red=>234, :green=>91, :blue=>59, :rgb=>"rgb(234, 91, 59)", :hex=>"#ea5b3b"},
#         {:red=>180, :green=>205, :blue=>204, :rgb=>"rgb(180, 205, 204)", :hex=>"#b4cdcc"},
#         {:red=>103, :green=>153, :blue=>152, :rgb=>"rgb(103, 153, 152)", :hex=>"#679998"},
#         {:red=>1, :green=>84, :blue=>82, :rgb=>"rgb(1, 84, 82)", :hex=>"#015452"},
#         {:red=>235, :green=>153, :blue=>133, :rgb=>"rgb(235, 153, 133)", :hex=>"#eb9985"},
#         {:red=>51, :green=>117, :blue=>116, :rgb=>"rgb(51, 117, 116)", :hex=>"#337574"}],
#       :blurhash=>"LAQJyC_3%#_3_NkCniof_NWV}[t7",
#       :video=>nil},
#     :caption=>"Arise Logo"}]}
# Similarly to Modular Content fields, you can also embed block records into Structured Text. A block node stores a reference to a DatoCMS block record embedded inside the dast document.
#
# This type of node can only be put as a direct child of the root node.
#
# It does not allow children nodes.
#
# type  "block"  Required
# item  string  Required
# The DatoCMS block record ID
#
# {
#   "type": "block",
#   "item": "1238455312"
# }
module MiddlemanDatoDast
  module Nodes
    class Block < Base
      def block_id
        @node["item"]
      end

      def block
        @blocks.find { |block| block[:id] == block_id }
      end

      def item_type
        block[:item_type]
      end

      def wrappers
        Array(block_config["wrappers"])
      end

      def tag
        block_config["tag"]
      end

      def css_class
        block_config["css_class"]
      end

      def meta
        block_config["meta"]
      end

      def block_config
        config.blocks[item_type]
      end

      def render_value
        block_config["render_value"].call(block)
      end
    end
  end
end
