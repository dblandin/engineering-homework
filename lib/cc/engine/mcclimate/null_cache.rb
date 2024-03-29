module CC
  module Engine
    class Mcclimate
      class NullCache
        attr_reader :cache_path

        def initialize(cache_path: '')
        end

        def stale?(path, relative_path)
          true
        end

        def record(relative_path, report_details)
        end

        def process(relative_path, output_io)
        end
      end
    end
  end
end
