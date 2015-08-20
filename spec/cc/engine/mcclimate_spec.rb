require 'cc/engine/mcclimate'
require 'support/helpers/engine_helper'

module CC::Engine
  describe Mcclimate do
    include EngineHelper

    describe '#run' do
      it 'analyzes source ruby files for complexity' do
        create_source_file('foo.rb', <<-RUBY)
          def foo
            x = 1 + 3
            y = 2 * 4 + 6
            z = x * y / 2
          end
        RUBY

        Mcclimate.new(code_path: code_path, output_io: output_io).run

        expect(issues.count).to eq(1)
        expect(last_issue).to include(
          'description' => "'#foo' has a complexity of 12",
          'location' => {
            'path' => 'foo.rb',
            'lines' => {
              'begin' => 1,
              'end' => 5
            }
          }
        )
      end
    end
  end
end
