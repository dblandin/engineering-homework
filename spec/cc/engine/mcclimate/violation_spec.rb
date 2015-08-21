require 'parser/current'
require 'support/helpers/fixture_helper'
require 'cc/engine/mcclimate/complexity_report'
require 'cc/engine/mcclimate/violation'

module CC::Engine
  describe Mcclimate::Violation do
    include FixtureHelper

    describe '#details' do
      it 'returns violation json for the passed values' do
        method_node = Parser::CurrentRuby.parse_file(test_fixture_path('complex_method_12.rb'))
        report      = Mcclimate::ComplexityReport.new(method_node, 'foo.rb', 12)
        violation   = Mcclimate::Violation.new(report)

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
