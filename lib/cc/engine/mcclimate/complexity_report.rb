module CC
  module Engine
    class Mcclimate
      class ComplexityReport
        attr_reader :method_node, :path, :score

        def initialize(method_node, path, score)
          @method_node = method_node
          @path        = path
          @score       = score
        end

        def method_name
          method_node.children[0]
        end

        def range
          Range.new(location.first_line, location.last_line)
        end

        private

        def location
          method_node.location
        end
      end
    end
  end
end
