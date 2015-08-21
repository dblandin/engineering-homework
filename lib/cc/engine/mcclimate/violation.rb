module CC
  module Engine
    class Mcclimate
      class Violation
        FIXED_ATTRIBUTES ||= {
          type: 'issue',
          check_name: 'complexity',
          remediation_points: 500
        }.freeze

        attr_reader :method_name, :range, :path, :score

        def initialize(method_name, range, path, score)
          @method_name = method_name
          @range       = range
          @path        = path
          @score       = score
        end

        def details
          FIXED_ATTRIBUTES.merge(
            description: "'##{method_name}' has a complexity of #{score}",
            location: {
              path: path,
              lines: {
                begin: range.first,
                end: range.last
              }
            }
          )
        end
      end
    end
  end
end
