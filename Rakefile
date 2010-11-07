require 'bundler/setup'

SETTINGS = {
  "rsync_server" => "mcgeary.org:~/ryan.mcgeary.org",
  "rsync_options" => "-e ssh -avz --delete"
}

task :default => :watch

desc "Publish to server (edit Rakefile to config)"
task :publish => :build do
  sh "rsync #{SETTINGS['rsync_options']} _site/ #{SETTINGS['rsync_server']}"
end

desc "Build site"
task :build do
  rebuild_sass
  rebuild_jekyll
end

desc "Watch for changes and test the site"
task :watch => :build do
  sh("open http://ryan.mcgeary.local")
  monitor
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
    dirs = dirs.map { |x| "#{x}/**/*" }
    dirs += ['*']
  end
end
