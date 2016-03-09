class MyPDFTester < Prawn::Document
  attr_reader :obj, :options, :title

  def initialize(obj, options = {})
    @obj     = obj
    @options = options.symbolize_keys
    super({ page_size: "A4", margin: 20.mm })
  end

  def title
    "Dummy Title"
  end

end

