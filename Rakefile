require "bundler/setup"
require "middleman-gh-pages"

desc "Opens the development preview in your default browser"
task :open do
  sh "mkdir -p tmp && touch tmp/restart.txt"
  base = File.open(".powder").read.strip
  sh "open http://#{base}.dev/"
end

desc "Opens the development preview in your default browser"
multitask :default => [:open]

# Ensure builds are skipped when pushing to the gh-pages branch
ENV["COMMIT_MESSAGE_SUFFIX"] = "[skip ci]"
