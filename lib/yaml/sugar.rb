require 'yaml/sugar_impl'

# YamlSugar module
module YamlSugar
  attr_reader :config

  def self.new
    SugarImpl.new
  end

  def self.clear
    @config = nil
  end

  def self.method_missing(method_sym, *args)
    @config ||= SugarImpl.new
    @config.send method_sym, *args
  end

  def self.load(dir, args = {})
    @config ||= SugarImpl.new
    @config.load(dir, args)
  end
end
