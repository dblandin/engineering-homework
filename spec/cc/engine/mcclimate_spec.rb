require 'cc/engine/mcclimate'
require 'tmpdir'

module CC::Engine
  describe Mcclimate do
    describe '#run' do
      it 'analyzes source ruby files for complexity' do
        code_path = Dir.mktmpdir
        output_io = StringIO.new

        Mcclimate.new(code_path: code_path, output_io: output_io).run

        results = output_io.string

        expect(results.length).not_to be_zero
      end
    end
  end
end
