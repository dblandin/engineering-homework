require 'parser'
require 'pathname'

module CC
  module Engine
    class Mcclimate
      attr_reader :code_path, :config, :output_io

      def initialize(code_path:, config: {}, output_io: STDOUT)
        @code_path = code_path
        @config    = config
        @output_io = output_io
      end

      def run
        '---'
      end
    end
  end
end
