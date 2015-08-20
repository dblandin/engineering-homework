require 'cc/engine/mcclimate'
require 'support/helpers/engine_helper'

module CC::Engine
  describe Mcclimate do
    include EngineHelper

    describe '#run' do
      it 'analyzes source ruby files for method complexity' do
        create_source_file('foo.rb', complex_method_body)

        Mcclimate.new(code_path: code_path, output_io: output_io).run

        expect(issues.count).to eq(1)
        expect(last_issue).to include(
          'description' => "'#foo' has a complexity of 12",
          'location' => {
            'path' => 'foo.rb',
            'lines' => {
              'begin' => 2,
              'end' => 6
            }
          }
        )
      end

      it 'should not report issues for methods with a complexity score <= 10' do
        create_source_file('foo.rb', not_complex_method_body)

        Mcclimate.new(code_path: code_path, output_io: output_io).run

        expect(issues).to be_empty
      end

      it 'honors the exclude_paths configuration option' do
        create_source_file('foo.rb', complex_method_body)

        config = { exclude_paths: ['foo.rb'] }

        Mcclimate.new(code_path: code_path, config: config, output_io: output_io).run

        expect(issues).to be_empty
      end
    end

    private

    def complex_method_body
      # complexity score of 12 (1 + 5 operands + 6 integers)
      <<-RUBY
        class Foo
          def foo
            x = 1 + 3
            y = 2 * 4 + 6
            z = x * y / 2
          end
        end
      RUBY
    end

    def not_complex_method_body
      # complexity score of 4 (1 + 1 operand + 2 integers)
      <<-RUBY
        def foo
          x = 1 + 3
        end
      RUBY
    end
  end
end
