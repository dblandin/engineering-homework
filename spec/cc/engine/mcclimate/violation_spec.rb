require 'cc/engine/mcclimate/violation'
require 'parser/current'

module CC::Engine
  describe Mcclimate::Violation do
    describe '#details' do
      it 'returns violation json for the passed values' do
        node = Parser::CurrentRuby.parse(method_body)

        violation = Mcclimate::Violation.new(node, 20, 'foo.rb')

        expect(violation.details).to eq(
          type: 'issue',
          check_name: 'complexity',
          remediation_points: 500,
          description: "'#foo' has a complexity of 20",
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

    private

    def method_body
      <<-RUBY
        def foo
          x = 1 + 3
          y = 2 * 4 + 6
          z = x * y / 2
        end
      RUBY
    end
  end
end
