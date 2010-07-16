SETTINGS = {
  "rsync_server" => "mcgeary.org:~/ryan.mcgeary.org",
  "rsync_options" => "-e ssh -avz --delete"
}

task :default => :test

desc "Build site"
task :build do
  sh "jekyll --no-auto"
end

desc "Preview site"
task :preview => :build do
  sh "open http://eyestreet.local/"
end

desc "Test site"
task :test => :preview do
  sh "jekyll"
end

desc "Publishes to server (edit Rakefile to config)"
task :publish => :build do
  sh "rsync #{SETTINGS['rsync_options']} _site/ #{SETTINGS['rsync_server']}"
end
