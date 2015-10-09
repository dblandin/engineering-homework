require 'json'

module CC
  module Engine
    class Mcclimate
      class IssueCache
        attr_reader :cache_path

        def initialize(cache_path: '/cache')
          @cache_path = cache_path
        end

        def stale?(path, relative_path)
          cached_report_path = File.join(cache_path, relative_path) + '.json'

          if File.exists?(cached_report_path)
            File.mtime(cached_report_path) < File.mtime(path)
          else
            true
          end
        end

        def record(relative_path, report_details)
          cached_report_path = File.join(cache_path, relative_path) + '.json'

          File.open(cached_report_path, 'w+') do |file|
            file.write(JSON.dump(report_details))
          end
        end

        def process(relative_path, output_io)
          output_io.print(cached_report(relative_path))
        end

        private

        def cached_report(relative_path)
          File.read(File.join(cache_path, relative_path) + '.json')
        end
      end
    end
  end
end
