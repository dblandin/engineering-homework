module CC
  module Engine
    class Mcclimate
      class ComplexityScore
        INITIAL_SCORE   ||= 1.freeze
        MATH_OPERATIONS ||= %i[+ - / *].freeze

        attr_reader :method_node

        def initialize(method_node)
          @method_node = method_node
        end

        def calculate
          INITIAL_SCORE + node_score
        end

        private

        def node_score(node = method_node)
          node.children.inject(0) do |score, child|
            if child.is_a? Parser::AST::Node
              number_value?(child) ? score + 1 : score + node_score(child)
            else
              operand_value?(child) ? score + 1 : 0
            end
          end
        end

        def number_value?(child)
          child.type == :int
        end

        def operand_value?(child)
          MATH_OPERATIONS.include?(child)
        end
      end
    end
  end
end
