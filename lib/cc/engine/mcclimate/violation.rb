require 'pathname'
require 'json'

module CC
  module Engine
    class Mcclimate
      class Violation
        FIXED_ATTRIBUTES ||= {
          type: 'issue',
          check_name: 'complexity',
          remediation_points: 500
        }.freeze

        attr_reader :parsed_method, :score, :path

        def initialize(parsed_method, score, path)
          @parsed_method = parsed_method
          @score         = score
          @path          = path
        end

        def to_json
          FIXED_ATTRIBUTES.merge(
            description: "'##{method_name}' has a complexity of #{score}",
            location: {
              path: path,
              lines: {
                begin: expression.first_line,
                end: expression.last_line
              }
            },
          ).to_json
        end

        private

        def method_name
          parsed_method.children[0]
        end

        def expression
          parsed_method.location.expression
        end
      end
    end
  end
end
