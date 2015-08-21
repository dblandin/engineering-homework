require 'support/helpers/engine_helper'
require 'support/helpers/fixture_helper'
require 'cc/engine/mcclimate'
require 'cc/engine/mcclimate/issue_cache'

module CC::Engine
  describe Mcclimate do
    include EngineHelper, FixtureHelper

    describe '#run' do
      it 'analyzes source ruby files for method complexity', :focus do
        copy_fixture_file('complex_12.rb', 'foo.rb')

        Mcclimate.new(code_path: code_path, output_io: output_io).run

        expect(issues.count).to eq(1)
        expect(last_issue).to include(
          'description' => "'#bar' has a complexity of 12",
          'location' => {
            'path' => 'foo.rb',
            'lines' => {
              'begin' => 2,
              'end' => 6
            }
          }
        )
      end

      it 'uses a cache for file reports' do
        cache_path  = Dir.mktmpdir
        cached_path = File.join(cache_path, 'foo.rb.json')

        FileUtils.cp(test_fixture_path('cached_report.json'), cached_path)
        FileUtils.touch(cached_path, mtime: Time.now + 100)

        copy_fixture_file('complex_12.rb', 'foo.rb')

        cache = Mcclimate::IssueCache.new(cache_path: cache_path)

        Mcclimate.new(code_path: code_path, output_io: output_io, cache: cache).run

        expect(issues.count).to eq(1)
        expect(last_issue).to include(
          'description' => "'#bar' has a complexity of 11",
          'location' => {
            'path' => 'foo.rb',
            'lines' => {
              'begin' => 3,
              'end' => 8
            }
          }
        )
      end

      it 'should not report issues for methods with a complexity score <= 10' do
        copy_fixture_file('complex_4.rb', 'foo.rb')

        Mcclimate.new(code_path: code_path, output_io: output_io).run

        expect(issues).to be_empty
      end

      it 'honors the exclude_paths configuration option' do
        copy_fixture_file('complex_12.rb', 'foo.rb')

        config = { 'exclude_paths' => ['foo.rb'] }

        Mcclimate.new(code_path: code_path, config: config, output_io: output_io).run

        expect(issues).to be_empty
      end

      it 'does not blow up when encountering empty source files' do
        copy_fixture_file('empty_file.rb', 'foo.rb')

        Mcclimate.new(code_path: code_path, output_io: output_io).run

        expect(issues).to be_empty
      end
    end
  end
end
