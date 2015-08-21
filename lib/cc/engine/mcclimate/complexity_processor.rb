require 'parser'
require_relative './complexity_report'

module CC
  module Engine
    class Mcclimate
      class ComplexityProcessor < Parser::AST::Processor
        INITIAL_SCORE   ||= 1.freeze
        MATH_METHODS ||= %i[+ - / *].freeze

        attr_reader :method_node, :path, :score

        def initialize(method_node, path)
          @method_node = method_node
          @path        = path
          @score       = INITIAL_SCORE
        end

        def process!
          process(method_node)
        end

        def report
          ComplexityReport.new(method_node, path, score)
        end

        def on_send(node)
          method_name = node.children[1]

          super

          @score += 1 if MATH_METHODS.include?(method_name)
        end

        def on_int(node)
          @score += 1
        end

        def on_float(node)
          @score += 1
        end
      end
    end
  end
end
