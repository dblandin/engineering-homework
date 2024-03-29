module CC
  module Engine
    class Compare
      NEW_LINE_CHARACTER ||= "\n".freeze
      TEMPLATES ||= {
        new:   'NEW: %{description}',
        fixed: 'FIXED: %{description}'
      }.freeze

      attr_reader :base_report, :compare_report, :output_io

      def initialize(base_report:, compare_report:, output_io: STDOUT)
        @base_report    = base_report
        @compare_report = compare_report
        @output_io      = output_io
      end

      def run
        new_issues.each   { |issue| report(:new, issue['description']) }
        fixed_issues.each { |issue| report(:fixed, issue['description']) }
      end

      private

      def new_issues
        compare_report - base_report
      end

      def fixed_issues
        base_report - compare_report
      end

      def report(type, description)
        message = TEMPLATES[type] % { description: description }

        output_io.print(message + NEW_LINE_CHARACTER)
      end
    end
  end
end
