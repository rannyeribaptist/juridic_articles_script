require 'pdf-reader'
require 'prawn'

pdf = PDF::Reader.new("article_1.pdf")

pdf.pages.each do |page|
  puts '============='
  text = page.to_s.split('')
  i = 0

  puts text[10..150000000]
end
