require 'ostruct'

module LanguageTool
  attrs = [:fromx, :fromy, :toy, :tox, :ruleId, :subId, :url, :msg, :replacements, :context, :contextoffset, :offset, :errorlength, :category, :locqualityissuetype]

  class Error < Struct.new(*attrs)
    def initialize(e)
      e.attributes.each do |k,attr|
        self.send("#{k}=", attr.value)
      end
    end
  end
end