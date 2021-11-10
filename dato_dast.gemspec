# frozen_string_literal: true

require_relative "lib/dato_dast/version"

Gem::Specification.new do |spec|
  spec.name          = "dato_dast"
  spec.version       = DatoDast::VERSION
  spec.authors       = ["John DeWyze"]
  spec.email         = ["john@dewyze.dev"]

  spec.summary       = "Gem for converting DatoCMS Structured Text to Html"
  spec.description   = "This gem provides a way to convert DatoCMS structured text to Html, as well as an extension for Middleman."
  spec.homepage      = "https://github.com/dewyze/dato_dast"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.4.0")

  spec.metadata["homepage_uri"] = "https://github.com/dewyze/dato_dast"
  spec.metadata["source_code_uri"] = "https://github.com/dewyze/dato_dast"
  spec.metadata["changelog_uri"] = "https://github.com/dewyze/dato_dast/blob/main/CHANGELOG.md."

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport"
  spec.add_development_dependency "pry-byebug"
end
