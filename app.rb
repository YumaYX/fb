# frozen_string_literal: true

require "mechanize"

def title_of(url)
  return url
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

require 'fileutils'
FileUtils.mkdir("_site")
File.write("_site/index.md", doc)
