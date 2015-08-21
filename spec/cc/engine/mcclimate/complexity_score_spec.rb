require 'parser/current'
require 'support/helpers/fixture_helper'
require 'cc/engine/mcclimate/complexity_processor'

module CC::Engine
  describe Mcclimate::ComplexityProcessor do
    include FixtureHelper

    describe '#calculate' do
      it 'calculates the complexity score for a method' do
        method_node = Parser::CurrentRuby.parse_file(test_fixture_path('complex_method_12.rb'))

        processor = Mcclimate::ComplexityProcessor.new(method_node, 'foo.rb')
        processor.process!

        expect(processor.score).to eq(12)
      end
    end
  end
end
