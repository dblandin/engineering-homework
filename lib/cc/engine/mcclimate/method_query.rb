module CC
  module Engine
    class Mcclimate
      class MethodQuery
        attr_reader :parsed_tree

        def initialize(parsed_tree)
          @parsed_tree = parsed_tree
        end

        def all
          found = []

          found << parsed_tree if method_node?(parsed_tree)

          found + child_methods(parsed_tree)
        end

        private

        def child_methods(node)
          return [] unless node?(node)

          node.children.inject([]) do |found, child|
            if method_node?(child)
              found << child
            else
              found + child_methods(child)
            end
          end
        end

        def node?(node)
          node.is_a? Parser::AST::Node
        end

        def method_node?(node)
          node?(node) && node.type == :def
        end
      end
    end
  end
end
