require 'pathname'
require 'parser/current'
require_relative './mcclimate/file_processor'

module CC
  module Engine
    class Compare
      def initialize(base_report:, compare_report:)
        @base_report    = base_report
        @compare_report = compare_report
      end

      def run
        '---'
      end
    end
  end
end
