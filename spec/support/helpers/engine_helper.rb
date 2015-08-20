require 'tmpdir'
require 'json'

module EngineHelper
  def create_source_file(path, content)
    full_path = File.join(code_path, path)

    File.write(full_path, content)
  end

  def code_path
    @code_path ||= Dir.mktmpdir
  end

  def last_issue
    issue = output_io.string.split("\0").last

    JSON.parse(issue)
  end

  def output_io
    @output_io ||= StringIO.new
  end
end
