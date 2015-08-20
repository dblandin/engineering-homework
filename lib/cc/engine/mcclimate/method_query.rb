module CC
  module Engine
    class Mcclimate
      class MethodQuery
        attr_reader :contents

        def initialize(contents)
          @contents = contents
        end

        def all
          found = []

          found << parsed if method_node?(parsed)

          found + child_methods(parsed)
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

        def parsed
          @parsed ||= Parser::Ruby20.parse(contents)
        end
      end
    end
  end
end
