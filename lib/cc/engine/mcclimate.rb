require 'parser/ruby20'
require 'pathname'
require 'json'

module CC
  module Engine
    class Mcclimate
      MATH_OPERATIONS ||= %i[+ - / *].freeze

      attr_reader :code_path, :config, :output_io

      def initialize(code_path:, config: {}, output_io: STDOUT)
        @code_path = code_path
        @config    = config
        @output_io = output_io
      end

      def run
        ruby_files = File.join(code_path, '**', '*.rb')

        Dir.glob(ruby_files).each do |path|
          contents      = File.read(path)
          parsed        = Parser::Ruby20.parse(contents)
          found_methods = found_methods(parsed)

          found_methods.each do |method|
            score = calculate_score(method) + 1

            if score > 10
              method_name = method.children[0]
              json        = violation_json(method_name, score)

              output_io.print("#{json}\0")
            end
          end
        end

        '---'
      end

      private

      def found_methods(parsed)
        methods = []

        if parsed.is_a?(Parser::AST::Node)
          if parsed.type == :def
            methods << parsed
          else
            parsed.children.each do |child|
              methods += found_methods(child)
            end
          end
        end

        methods
      end

      def calculate_score(method_body)
        score = 0

        method_body.children.each do |child|
          if child.is_a? Parser::AST::Node
            if child.type == :int
              score += 1
            else
              score += calculate_score(child)
            end
          else
            if MATH_OPERATIONS.include?(child)
              score += 1
            end
          end
        end

        score
      end

      def violation_json(method_name, score)
        {
          type: 'issue',
          check_name: 'complexity',
          description: "'##{method_name}' has a complexity of #{score}",
          categories: ['Complexity'],
          remediation_points: 500,
          location: {
            path: 'foo.rb',
            lines: {
              begin: 1,
              end: 2
            }
          },
        }.to_json
      end
    end
  end
end
