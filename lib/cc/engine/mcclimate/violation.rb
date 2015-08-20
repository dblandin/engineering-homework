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

        attr_reader :method_node, :score, :path

        def initialize(method_node, score, path)
          @method_node = method_node
          @score       = score
          @path        = path
        end

        def details
          FIXED_ATTRIBUTES.merge(
            description: "'##{method_name}' has a complexity of #{score}",
            location: {
              path: path,
              lines: {
                begin: expression.first_line,
                end: expression.last_line
              }
            }
          )
        end

        private

        def method_name
          method_node.children[0]
        end

        def expression
          method_node.location.expression
        end
      end
    end
  end
end
