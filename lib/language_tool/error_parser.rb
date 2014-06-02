require 'language_tool/error'

module LanguageTool
  class ErrorParser
    def initialize(process)
      @process = process
    end

    def find_errors(text)
      xml = @process.feed(text)
      d = Nokogiri::XML(xml)
      d.css('error').map { |e| Error.new(e) }
    end
  end
end