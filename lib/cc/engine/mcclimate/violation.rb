module CC
  module Engine
    class Mcclimate
      class Violation
        FIXED_ATTRIBUTES ||= {
          type: 'issue',
          check_name: 'complexity',
          remediation_points: 500
        }.freeze

        attr_reader :report

        def initialize(report)
          @report = report
        end

        def details
          FIXED_ATTRIBUTES.merge(
            description: "'##{report.method_name}' has a complexity of #{report.score}",
            location: {
              path: report.path,
              lines: {
                begin: report.range.first,
                end: report.range.last
              }
            }
          )
        end
      end
    end
  end
end
