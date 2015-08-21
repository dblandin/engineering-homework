require 'pathname'

module CC
  module Engine
    class Mcclimate
      class IssueCache
        attr_reader :cache_path

        def initialize(cache_path: '/cache')
          @cache_path = cache_path
        end

        def stale?(path, relative_path)
          cached_report_path = Pathname.new(File.join(cache_path, relative_path) + '.json')

          if File.exists?(cached_report_path)
            cached_report_path.mtime < path.mtime
          else
            true
          end
        end

        def report(relative_path)
          File.read(File.join(cache_path, relative_path) + '.json')
        end

        def record(relative_path, reports)
          cached_report_path = Pathname.new(File.join(cache_path, relative_path) + '.json')

          File.open(cached_report_path, 'w+') { |file| file.write(JSON.dump(reports)) }
        end

        def process(relative_path, output_io)
          output_io.print(report(relative_path))
        end
      end
    end
  end
end
