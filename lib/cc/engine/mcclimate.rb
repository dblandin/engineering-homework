require 'pathname'
require 'parser/current'
require_relative './mcclimate/file_processor'
require_relative './mcclimate/null_cache'

module CC
  module Engine
    class Mcclimate
      attr_reader :code_path, :config, :output_io, :cache

      def initialize(code_path:, config: {}, output_io: STDOUT, cache: NullCache.new)
        @code_path = Pathname.new(code_path)
        @config    = config
        @output_io = output_io
        @cache     = cache
      end

      def run
        ruby_files.each do |path|
          tree          = Parser::CurrentRuby.parse_file(path)
          relative_path = Pathname.new(path).relative_path_from(code_path)

          if cache.stale?(path, relative_path)
            processor = FileProcessor.new(relative_path, output_io)

            processor.process(tree)

            cache.record(relative_path, output_io)
          else
            cache.process(relative_path, output_io)
          end
        end
      end

      private

      def ruby_files
        Pathname.glob(File.join(code_path, '**', '*.rb')) - excluded_ruby_files
      end

      def excluded_ruby_files
        config.fetch(:exclude_paths, []).map do |path|
          Pathname.glob(File.join(code_path, path))
        end.flatten
      end
    end
  end
end
