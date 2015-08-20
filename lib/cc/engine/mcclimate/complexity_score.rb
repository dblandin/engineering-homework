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

        def node_score(method_body = method_node)
          score = 0

          method_body.children.each do |child|
            if child.is_a? Parser::AST::Node
              if child.type == :int
                score += 1
              else
                score += node_score(child)
              end
            else
              if MATH_OPERATIONS.include?(child)
                score += 1
              end
            end
          end

          score
        end
      end
    end
  end
end
