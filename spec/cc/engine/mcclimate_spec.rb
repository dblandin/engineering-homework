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

        expect(output_io.string).not_to eq('')
        expect(last_issue['description']).to eq("'#foo' has a complexity of 12")
      end
    end
  end
end
