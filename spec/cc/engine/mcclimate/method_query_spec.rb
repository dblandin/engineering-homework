require 'cc/engine/mcclimate/method_query'
require 'parser/ruby20'

module CC::Engine
  describe Mcclimate::MethodQuery do
    describe '#calculate' do
      it 'returns methods nodes for all parsed contents' do
        parsed = Parser::Ruby20.parse(double_class_body)

        query = Mcclimate::MethodQuery.new(parsed)

        expect(query.all.count).to eq(4)
      end
    end

    private

    def double_class_body
      <<-RUBY
        class Foo
          def one
          end
          def two
          end
          def three
          end
        end

        class Bar
          def one
          end
        end
      RUBY
    end
  end
end
