module CompareHelper
  def results
    output_io.string.split("\n")
  end

  def output_io
    @output_io ||= StringIO.new
  end
end
