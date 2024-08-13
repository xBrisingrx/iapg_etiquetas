class Person < ApplicationRecord

  def self.generate_print
    HexaPDF::Composer.create('ocg.pdf', page_size: [0, 0, 300, 100]) do |composer|
      composer.text("This text can be toggled via the 'Text' layer.",
                    properties: {"optional_content" => 'Text'})
      composer.document.optional_content.ocg('Text').add_to_ui
    end
    # doc = HexaPDF::Document.new
    # page = doc.pages.add
    # page.page_size = [0, 0, 300, 100]
    # canvas = page.canvas
    # canvas.font('Helvetica', size: 50).fill_color(0, 128, 255)
    # canvas.text("Hello World", at: [150, 396])
    # doc.write("hello-world.pdf")
  end

end
