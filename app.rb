# frozen_string_literal: true

require "net/http"
require "json"

data = {
  '978-4-7917-6555-3' => 'http://www.seidosha.co.jp/book/index.php?id=1779',
  '978-4-334-95293-8' => 'https://www.kobunsha.com/shelf/book/isbn/9784334952938',
  '978-4-478-06659-1' => 'https://www.diamond.co.jp/book/9784478066591.html'
}

def to_markdown(isbn, p_url)
  isbn = isbn.gsub(/-/, "")
  url = "https://api.openbd.jp/v1/get?isbn=#{isbn}"
  uri = URI(url)
  response = Net::HTTP.get(uri)
  books = JSON.parse(response)

  book_info = books.first
  book_sum = book_info['summary']

  <<~MARKDOWN
    ### [#{book_sum['title']}](#{p_url})

    | 著者 | #{book_sum['author']} |
    | 出版社 | #{book_sum['publisher']} |
    | 出版日 | #{book_sum['pubdate']} |
    | ISBN| #{book_sum['isbn']} |

  MARKDOWN
end

doc = String.new
data.sort.each { |isbn, url| doc += to_markdown(isbn, url) }
File.write('index.md', doc)
