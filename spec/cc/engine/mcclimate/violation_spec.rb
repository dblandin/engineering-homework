require 'parser/current'
require 'cc/engine/mcclimate/violation'
require 'cc/engine/mcclimate/complexity_report'
require 'support/helpers/fixture_helper'

module CC::Engine
  describe Mcclimate::Violation do
    include FixtureHelper

    describe '#details' do
      it 'returns violation json for the passed values' do
        tree      = parsed_fixture_file('complex_method_12.rb')
        report    = Mcclimate::ComplexityReport.new(tree, 'foo.rb', 12)
        violation = Mcclimate::Violation.new(report)

        expect(violation.details).to eq(
          type: 'issue',
          check_name: 'complexity',
          remediation_points: 500,
          description: "'#bar' has a complexity of 12",
          location: {
            path: 'foo.rb',
            lines: {
              begin: 1,
              end: 5
            }
          }
        )
      end
    end
  end
end
