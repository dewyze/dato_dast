# frozen_string_literal: true

require "active_support/core_ext/array"
require "active_support/core_ext/string"
require "active_support/core_ext/object"
require "active_support/concern"
require_relative "dato_dast/version"
require_relative "dato_dast/html_tag"
require_relative "dato_dast/errors"
require_relative "dato_dast/marks"
require_relative "dato_dast/nodes"
require_relative "dato_dast/configuration"

module DatoDast
  def self.configuration
    @configuration ||= DatoDast::Configuration.new
  end

  def self.configure
    yield configuration
  end

  def self.reset_configuration
    @configuration = DatoDast::Configuration.new
  end

  def self.structured_text(item, config = nil)
    object = item.to_hash
    document = object[:value]["document"]
    links = object[:links]
    blocks = object[:blocks]

    Nodes.wrap(document, links, blocks, config).render
  end
end

if defined?(Middleman)
  require "dato_dast/extensions/middleman"
end
