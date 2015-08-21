require 'pathname'
require 'parser/current'
require_relative './mcclimate/file_processor'

module CC
  module Engine
    class Compare
      NEW_TEMPLATE   ||= 'NEW: %{description}'.freeze
      FIXED_TEMPLATE ||= 'FIXED: %{description}'.freeze

      attr_reader :base_report, :compare_report, :output_io

      def initialize(base_report:, compare_report:, output_io: STDOUT)
        @base_report    = base_report
        @compare_report = compare_report
        @output_io      = output_io
      end

      def run
        new_issues.each   { |issue| report_new(issue) }
        fixed_issues.each { |issue| report_fixed(issue) }
      end

      private

      def new_issues
        compare_report - base_report
      end

      def fixed_issues
        base_report - compare_report
      end

      def report_new(issue)
        output_io.print(NEW_TEMPLATE % { description: issue['description'] } + "\0")
      end

      def report_fixed(issue)
        output_io.print(FIXED_TEMPLATE % { description: issue['description'] } + "\0")
      end
    end
  end
end
