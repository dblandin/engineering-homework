require 'cc/engine/mcclimate/complexity_processor'
require 'parser/ruby20'

module CC::Engine
  describe Mcclimate::ComplexityProcessor do
    describe '#calculate' do
      it 'calculates the complexity score for a method' do
        tree = Parser::Ruby20.parse(complex_method_body)

        processor = Mcclimate::ComplexityProcessor.new
        processor.process(tree)

        expect(processor.score).to eq(12)
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
  end
end
