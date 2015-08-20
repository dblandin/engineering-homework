require_relative './complexity_score'
require_relative './violation'

module CC
  module Engine
    class Mcclimate
      class FileProcessor < Parser::AST::Processor
        SCORE_REPORT_THRESHOLD ||= 10.freeze

        attr_reader :path, :output_io

        def initialize(path, output_io)
          @path      = path
          @output_io = output_io
        end

        def on_def(method_node)
          score = ComplexityScore.new(method_node).calculate

          if score > SCORE_REPORT_THRESHOLD
            violation = Violation.new(method_node, score, path)

            report_violation(violation)
          end
        end

        def report_violation(violation)
          json = JSON.dump(violation.details)

          output_io.print("#{json}\0")
        end
      end
    end
  end
end
