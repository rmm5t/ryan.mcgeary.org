require 'bundler/setup'

SETTINGS = {
  "rsync_server" => "mcgeary.org:~/ryan.mcgeary.org",
  "rsync_options" => "-e ssh -avz --delete"
}

task :default => :watch

desc "Publish to server and ping services(edit Rakefile to config)"
task :publish => [:build, :sync, :ping]

task :sync do
  sh "rsync #{SETTINGS['rsync_options']} _site/ #{SETTINGS['rsync_server']}"
end

task :ping do
  ping "http://feedburner.google.com/fb/a/pingSubmit?bloglink=http%3A%2F%2Ffeeds.feedburner.com%2Fryanmcgeary"
  ping "http://rubycorner.com/ping/xmlrpc/fa66e0188d1914df45fdfe84036d1d4b068a61ec"
end

desc "Build site"
task :build => :sanity_check do
  rebuild_sass
  rebuild_jekyll
end

desc "Watch for changes and test the site"
task :watch => :build do
  sh("open http://ryan.mcgeary.dev/blog/")
  monitor
end

task :sanity_check do
  unless system("which pygmentize")
    STDERR.puts "Pygments is missing. Please install it first (see README)."
    exit 1
  end
end

def ping(url)
  require 'open-uri'
  print "\nPinging #{url[0..30]}... "
  io = open(url)
  puts io.status[0]
end

def rebuild_sass(base = nil, relative = nil)
  @compiler ||= compass_compiler
  if file = @compiler.out_of_date?
    puts ">>> Change detected to: #{file}"
    @compiler.run
  end
end

def rebuild_jekyll(base = nil, relative = nil)
  @site ||= jekyll_site
  puts ">>> Change detected to: #{relative}" if relative
  @site.process
end

def monitor
  require "fssm"
  puts ">>> Monitoring for changes. Press Ctrl-C to Stop."
  FSSM.monitor do
    path "_sass" do
      glob "*.s[ac]ss"
      update &method(:rebuild_sass)
      delete &method(:rebuild_sass)
      create &method(:rebuild_sass)
    end
    path "." do
      glob jekyll_glob(".")
      update &method(:rebuild_jekyll)
      delete &method(:rebuild_jekyll)
      create &method(:rebuild_jekyll)
    end
  end
end

def compass_compiler(options = {})
  require 'compass'
  require 'compass/logger'
  Compass.add_project_configuration
  Compass.configure_sass_plugin!
  Compass.compiler
end

def jekyll_site
  require "jekyll"
  Jekyll::Site.new(Jekyll.configuration({}))
end

def jekyll_glob(source)
  Dir.chdir(source) do
    dirs = Dir['*'].select { |x| File.directory?(x) }
    dirs -= ['_site']
    dirs -= ['_sass']
    dirs -= ['public']
    dirs = dirs.map { |x| "#{x}/**/*" }
    dirs += ['*']
  end
end
