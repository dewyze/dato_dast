# An itemLink node is similar to a link node node, but instead of linking a portion of text to a URL, it links the document to another record present in the same DatoCMS project.
#
# It might optionally contain a number of additional custom information under the meta key.
#
# If you want to link to a DatoCMS record without having to specify some inner content, then please use the inlineItem node.
#
# It allows the following children nodes : span.
#
# type  "itemLink"  Required
# item  string  Required
# The linked DatoCMS record ID
#
# children  Array<object>  Required
# Show objects format inside array
# meta  Array<object>  Optional
# Array of tuples containing custom meta-information for the link.
#
# Show objects format inside array
# {
#   "type": "itemLink",
#   "item": "38945648",
#   "meta": [
#     { "id": "rel", "value": "nofollow" },
#     { "id": "target", "value": "_blank" }
#   ],
#   "children": [
#     {
#       "type": "span",
#       "value": "Matteo Giaccone"
#     }
#   ]
# }
