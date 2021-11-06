# frozen_string_literal: true

require "active_support/core_ext/array"
require "active_support/core_ext/string"
require "active_support/concern"
require_relative "middleman_dato_dast/version"
require_relative "middleman_dato_dast/html_tag"
require_relative "middleman_dato_dast/errors"
require_relative "middleman_dato_dast/marks"
require_relative "middleman_dato_dast/nodes"
require_relative "middleman_dato_dast/configuration"
require_relative "middleman_dato_dast/middleman_extension"

module MiddlemanDatoDast
  def self.configuration
    @configuration ||= MiddlemanDatoDast::Configuration.new
  end

  def self.configure
    yield configuration
  end

  def self.reset_configuration
    @configuration = MiddlemanDatoDast::Configuration.new
  end
end
