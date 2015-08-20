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

          if parsed.is_a?(Parser::AST::Node)
            if parsed.type == :def
              found << parsed
            else
              parsed.children.each do |child|
                found += all(child)
              end
            end
          end

          found
        end

        private

        def parsed
          Parser::Ruby20.parse(contents)
        end
      end
    end
  end
end
