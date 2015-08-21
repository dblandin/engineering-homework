module CompareHelper
  def results
    output_io.string.split("\0")
  end

  def output_io
    @output_io ||= StringIO.new
  end
end
