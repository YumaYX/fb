# frozen_string_literal: true

require "mechanize"

def title_of(url)
  page = Mechanize.new.get(url)
  page.title.gsub(/\|/,'\|')
rescue StandardError => e
  ""
end

doc = String.new
urls = File.readlines('urls.txt').map(&:chomp).reject(&:empty?)
urls.each do |url|
  title = title_of(url)
  next if title.empty?
  doc = doc + "- [#{title}](#{url})\n"
end

File.write("index.md", doc)
