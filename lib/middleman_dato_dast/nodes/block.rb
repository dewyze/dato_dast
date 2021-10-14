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
