require 'cc/engine/compare'
require 'support/helpers/compare_helper'
require 'support/helpers/fixture_helper'

module CC::Engine
  describe Compare do
    include CompareHelper, FixtureHelper

    describe '#run' do
      it 'compares two analysis reports' do
        base_report    = decoded_fixture_file('commit_a.json')
        compare_report = decoded_fixture_file('commit_b.json')

        Compare.new(
          base_report: base_report, compare_report: compare_report, output_io: output_io
        ).run

        expect(results).to include("FIXED: '#bar' has a complexity of 12")
        expect(results).to include("NEW: '#foo' has a complexity of 15")
      end
    end
  end
end
