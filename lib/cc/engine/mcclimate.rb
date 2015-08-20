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

          found_methods.each do |method|
            score = ComplexityScore.new(method).calculate

            if score > SCORE_REPORT_THRESHOLD
              json = violation_json(method, score, path)

              output_io.print("#{json}\0")
            end
          end
        end

        '---'
      end

      private

      def ruby_files
        paths = Pathname.glob(File.join(code_path, '**', '*.rb'))

        config.fetch(:exclude_paths, []).each do |path|
          paths -= Pathname.glob(File.join(code_path, path))
        end

        paths
      end

      def violation_json(method, score, path)
        relative_path = Pathname.new(path).relative_path_from(code_path)

        Violation.new(method, score, relative_path).to_json
      end
    end
  end
end
