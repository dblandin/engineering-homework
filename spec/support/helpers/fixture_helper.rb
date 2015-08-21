module FixtureHelper
  def test_fixture_path(filename)
    File.join('spec/support/fixtures', filename)
  end
end
