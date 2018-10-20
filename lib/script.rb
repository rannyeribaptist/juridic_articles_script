require 'pdf-reader'

# se encontrar Arts. 187 a 191.
# o próximo artigo se torna 191 + 1

class Script

  def reading
    book = PDF::Reader.new('nucci.pdf')

    art_count = 0

    next_article = 1

    book.pages.each do |page|
      percentage = (page.number * 100) / book.page_count
      puts percentage.to_s + "%"

      if page.text.include?("Art. ")
        puts "========================================"
        puts "Art. Confirmed"
        puts "page:" + page.number.to_s
        page_content = page.text.to_s

        if page.number == 779
          puts ""
          puts ""
          puts page.text
          puts ""
          puts ""
        end

        page_content.split('').each_with_index do |char, i|
          pattern = i + 8

          if page_content[i..pattern].include?("Art. " + next_article.to_s) or page_content[i..pattern].include?("Art. " + (next_article+1).to_s)

            puts "current article: " + next_article.to_s
            next_article += 1
            art_count += 1

            puts "articles: " + art_count.to_s
            puts "next article: " + next_article.to_s
          end
        end
        puts "========================================"
      end
    end

    return art_count
  end

end
