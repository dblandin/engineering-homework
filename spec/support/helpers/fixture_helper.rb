module FixtureHelper
  def test_fixture_path(filename)
    File.join('spec/support/fixtures', filename)
  end

  def fixture_file(filename)
    File.read(test_fixture_path(filename))
  end

  def decoded_fixture_file(filename)
    JSON.parse(fixture_file(filename))
  end
end
