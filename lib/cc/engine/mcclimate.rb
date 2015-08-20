require 'parser/ruby20'
require 'pathname'
require_relative './mcclimate/violation'
require_relative './mcclimate/method_query'
require_relative './mcclimate/complexity_score'

module CC
  module Engine
    class Mcclimate
      MATH_OPERATIONS        ||= %i[+ - / *].freeze
      SCORE_REPORT_THRESHOLD ||= 10.freeze

      attr_reader :code_path, :config, :output_io

      def initialize(code_path:, config: {}, output_io: STDOUT)
        @code_path = Pathname.new(code_path)
        @config    = config
        @output_io = output_io
      end

      def run
        ruby_files.each do |path|
          contents      = File.read(path)
          found_methods = MethodQuery.new(contents).all

          found_methods.each do |method_node|
            score = ComplexityScore.new(method_node).calculate

            if score > SCORE_REPORT_THRESHOLD
              relative_path = Pathname.new(path).relative_path_from(code_path)
              violation     = Violation.new(method_node, score, relative_path)

              report_violation(violation)
            end
          end
        end
      end

      private

      def ruby_files
        Pathname.glob(File.join(code_path, '**', '*.rb')) - excluded_ruby_files
      end

      def excluded_ruby_files
        config.fetch(:exclude_paths, []).map { |path| Pathname.glob(File.join(code_path, path)) }.flatten
      end

      def report_violation(violation)
        output_io.print("#{violation.to_json}\0")
      end
    end
  end
end
