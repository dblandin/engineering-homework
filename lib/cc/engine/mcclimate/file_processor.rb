require 'parser'
require_relative './complexity_processor'
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
          processor = ComplexityProcessor.new(method_node, path)
          processor.process!

          if processor.score > SCORE_REPORT_THRESHOLD
            violation   = Violation.new(processor.report)

            report_violation(violation)
          end
        end

        private

        def report_violation(violation)
          json = JSON.dump(violation.details)

          output_io.print("#{json}\0")
        end
      end
    end
  end
end
