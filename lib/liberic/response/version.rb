module Liberic
  module Response
    class Version
      VERSION_NS = 'http://www.elster.de/EricXML/1.0/EricVersion'

      attr_reader :response_xml, :response_dom
      attr_reader :libs

      def initialize(response_xml)
        @response_xml = response_xml
        @response_dom = Nokogiri::XML(@response_xml)
        @libs = @response_dom.xpath('//version:Bibliothek', version: VERSION_NS).map do |lib|
          fields = Hash[
            {file: 'Name',
             product_version: 'Produktversion',
             file_version: 'Dateiversion'}.map do |key, german_field|
              [key, lib.xpath("version:#{german_field}", version: VERSION_NS).text]
            end
          ]

          fields[:name] = fields[:file].split('.').first

          [:product_version, :file_version].each do |version_type|
            fields[version_type] = fields[version_type].split(',').map(&:strip).join('.')
          end
          fields
        end
      end

      def for_library(name)
        (
          @libs.find { |lib| lib[:name] == name } ||
          (raise LibraryNotFound.new("Library #{name} could not be found in this ERiC installation"))
        )[:product_version]
      end
    end
  end
end
