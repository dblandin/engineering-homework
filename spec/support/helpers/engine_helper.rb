require 'json'
require 'tmpdir'

module EngineHelper
  def copy_fixture_file(fixture_filename, target_filename)
    src  = test_fixture_path(fixture_filename)
    dest = File.join(code_path, target_filename)

    FileUtils.cp(src, dest)
  end

  def code_path
    @code_path ||= Dir.mktmpdir
  end

  def last_issue
    issues.last
  end

  def issues
    output_io.string.split("\0").map { |json| JSON.parse(json) }
  end

  def output_io
    @output_io ||= StringIO.new
  end
end
