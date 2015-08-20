require 'cc/engine/mcclimate'

module CC::Engine
  describe Mcclimate do
    describe '#run' do
      it 'analyzes source ruby files for complexity' do
        engine = Mcclimate.new

        output = engine.run

        expect(output).to be_truthy
      end
    end
  end
end
