require "bundler/setup"
require "middleman-gh-pages"

desc "Opens the development preview in your default browser"
task :open do
  sh "mkdir -p tmp && touch tmp/restart.txt"
  base = File.open(".powder").read.strip
  sh "open http://#{base}.dev/"
end

desc "Ping relevant services after new content is published."
task :ping do
  ping "http://feedburner.google.com/fb/a/pingSubmit?bloglink=http%3A%2F%2Ffeeds.feedburner.com%2Fryanmcgeary"
  ping "http://rubycorner.com/ping/xmlrpc/fa66e0188d1914df45fdfe84036d1d4b068a61ec"
end

desc "Opens the development preview in your default browser"
multitask :default => [:open]

def ping(url)
  require 'open-uri'
  print "\nPinging #{url[0..30]}... "
  io = open(url)
  puts io.status[0]
end

# Ensure builds are skipped when pushing to the gh-pages branch
ENV["COMMIT_MESSAGE_SUFFIX"] = "[skip ci]"
