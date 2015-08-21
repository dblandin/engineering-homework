require 'cc/engine/mcclimate/violation'

module CC::Engine
  describe Mcclimate::Violation do
    describe '#details' do
      it 'returns violation json for the passed values' do
        violation = Mcclimate::Violation.new('bar', (1..5), 'foo.rb', 12)

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
