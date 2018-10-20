require "pdf-reader"
require "prawn"

# Select file to create comments
nucci = PDF::Reader.new('nucci.pdf')

# Set some usefull variables, such as the pattern to look for
pattern = "Art."
already_in_article = false
finish = false
pdf = nil
stop = nil
article_number = 1
new_article = false

# Starts to count all the pages of the file
nucci.pages.each_with_index do |page, i|
  # The file's pages starts with 1, so the counter must start at 1, not 0
  i += 1

  # Just to know in what page it is...
  puts "Runing in page " + i.to_s

  # Here it sets the current_article he is saving, and define the next article
  # to look for already. Like that he can identify when he need to stop saving
  # to the current article and starts to save for the next one
  next_article = pattern + " " + (article_number.to_i + 1).to_s + "."
  current_article = pattern + " " + article_number.to_s + "."

  # Making sure the script wont read a blank page
  if not page.text == ""
    puts "Current lookin for: " + current_article.to_s
    puts "Next article to find: "+ next_article.to_s
    puts "article number: " + article_number.to_s

    puts ""

    # Checking if this is the page to start saving
    if page.text.include?(current_article) || already_in_article == true
      puts "Found the " + current_article.to_s + ", Started saving the info"

      # Verify if it is the first article's comments page, to open the file
      if not already_in_article == true
        finish = false
        already_in_article = true
        pdf = Prawn::Document.new
        pdf.font_families.update("OpenSans" => {
          :normal => "app/assets/fonts/OpenSans-Regular.ttf",
          :italic => "app/assets/fonts/OpenSans-Regular.ttf",
          :bold => "app/assets/fonts/OpenSans-Regular.ttf",
          :bold_italic => "app/assets/fonts/OpenSans-Regular.ttf"
        })
        pdf.font("OpenSans")
        puts "Opened file"
      end

      # Checking out if this page has the next article, to stop saving to the current_article
      # and start saving for the next one
      if page.text.include?(next_article)
        new_article = false
        puts "Found the " + next_article.to_s + ". Preparing to make the switch"

        puts ""

        # These variables are to salve the last words in the page before
        # The next article starts
        words = page.text.split(" ")
        add_words = ""

        # Counting all the words in the last page
        words.each_with_index do |word, i|
          puts "Counting words..."

          article_in_line = word.to_s + " " + words[i+1].to_s
          article_in_line = article_in_line[0...-1]

          if article_in_line == next_article || new_article == true
            if not new_article == true
              pdf.text(add_words)
              pdf.render_file("articles/article_"+article_number.to_s+".pdf")
              puts "File saved to " + current_article.to_s

              article_number += 1

              pdf = Prawn::Document.new
              pdf.font_families.update("OpenSans" => {
                :normal => "app/assets/fonts/OpenSans-Regular.ttf",
                :italic => "app/assets/fonts/OpenSans-Regular.ttf",
                :bold => "app/assets/fonts/OpenSans-Regular.ttf",
                :bold_italic => "app/assets/fonts/OpenSans-Regular.ttf"
              })
              pdf.font("OpenSans")
              add_words = ""
              add_words = add_words + word + " "

              puts "Opened new file, starting to save words to the " + next_article.to_s
            else
              puts "Saving last words into the file..."
              add_words = add_words + word + " "
            end

          else
            puts "Preparing word to save"
            add_words = add_words + word + " "
          end
        end

        pdf.text(add_words)
        # article_number += 1
        finish = true
        puts ""
        puts "---------------------------------------------------------"

      # If this is not the page with the next article, just save all the content
      else
        pdf.text(page.text)
        puts "Saving info in the file..."
      end
    end
  end
end
