# An inlineItem, similarly to itemLink, links the document to another record but does not specify any inner content (children).
#
# It can be used in situations where it is up to the frontend to decide how to present the record (ie. a widget, or an <a> tag pointing to the URL of the record with a text that is the title of the linked record).
#
# It does not allow children nodes.
#
# type  "inlineItem"  Required
# item  string  Required
# The DatoCMS record ID
#
# {
#   "type": "inlineItem",
#   "item": "74619345"
# }
