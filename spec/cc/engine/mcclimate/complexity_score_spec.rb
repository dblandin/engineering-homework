require 'cc/engine/mcclimate/complexity_processor'
require 'support/helpers/fixture_helper'

module CC::Engine
  describe Mcclimate::ComplexityProcessor do
    include FixtureHelper

    describe '#calculate' do
      it 'calculates the complexity score for a method' do
        tree = parsed_fixture_file('complex_method_12.rb')

        processor = Mcclimate::ComplexityProcessor.new(tree, 'foo.rb')
        processor.process!

        expect(processor.score).to eq(12)
      end
    end
  end
end
