set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'

###
# Compass
###

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

###
# Helpers
###

helpers do
  def blog_asset(filename)
    relative_blog_dir = File.basename caller[0].split(":").first.split(".").first
    File.join "/posts", relative_blog_dir, filename
  end

  def time_tag(time, options = {})
    format = options.delete(:format) || "%d %b %Y"
    content_tag(:time, time.strftime(format), options.merge(datetime: time.iso8601))
  end

  def twitter_share(resource)
    link_to "Tweet", "https://twitter.com/share",
            class: "twitter-share-button",
            data: {
              url: URI.join(data.site.url, resource.url),
              text: resource.data.title,
              via: data.site.twitter,
              related: data.site.twitter,
              size: "large",
            }
  end

  def twitter_follow
    link_to "Follow @#{data.site.twitter}", URI.join("https://twitter.com/", data.site.twitter),
            class: "twitter-follow-button",
            data: {
              show: { count: true },
              size: "large",
            }
  end

  def gplus_share(resource)
    content_tag :div, "",
                class: "g-plus",
                data: {
                  action: "share", annotation: "bubble",
                  href: URI.join(data.site.url, resource.url),
                  height: 28,
                }
  end

  # TODO: Investigate why this is raising the following error:
  # Refused to display
  # 'https://apis.google.com/u/0/_/widget/render/follow?...'  in a frame
  # because it set 'X-Frame-Options' to 'SAMEORIGIN'
  def gplus_follow
    # content_tag :div, "",
    #             class: "g-follow",
    #             data: {
    #               rel: "author", annotation: "bubble",
    #               href: "https://plus.google.com/#{data.site.gplus}",
    #               height: 28,
    #             }
  end
end

###
# Blog settings
###

# Time.zone = "UTC"

activate :blog do |blog|
  # This will add a prefix to all links, template references and source paths
  # blog.prefix = "blog"

  # blog.permalink = "{year}/{month}/{day}/{title}.html"
  # Matcher for blog source files
  blog.sources = "posts/{year}-{month}-{day}-{title}.html"
  blog.taglink = "{tag}.html"
  blog.layout = "post"
  # blog.summary_separator = /(READMORE)/
  # blog.summary_length = 250
  # blog.year_link = "{year}.html"
  # blog.month_link = "{year}/{month}.html"
  # blog.day_link = "{year}/{month}/{day}.html"
  blog.default_extension = ".md"

  blog.tag_template = "posts/tag.html"
  blog.calendar_template = "posts/calendar.html"

  # Enable pagination
  blog.paginate = true
  blog.per_page = 10
  blog.page_link = "page/{num}"

  # Template for when `middleman article TITLE` is run
  blog.new_article_template = "source/posts/article.tt"
end

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

activate :directory_indexes # must come after blog config
activate :syntax # syntax highlighting
activate :alias  # for redirecting from old published URLs

# Reload the browser automatically whenever files change
configure :development do
  activate :livereload
end

# Build-specific configuration
configure :build do
  activate :minify_css
  activate :minify_javascript
  # activate :asset_hash # Enable cache buster
  # activate :relative_assets # Use relative URLs
end

set :markdown_engine, :kramdown
set :markdown, input: "GFM", hard_wrap: false, smartypants: true
set :haml, { ugly: true } # to preserve whitespace in code blocks

activate :google_analytics do |ga|
  ga.tracking_id = "UA-604149-3"
  # ga.allow_linker = true
  ga.development = false
end

activate :drafts do |drafts|
  drafts.build = true if ENV["SHOW_DRAFTS"]
end
page "/drafts/*", layout: "post" if ENV["SHOW_DRAFTS"]
ignore "/drafts/*" unless ENV["SHOW_DRAFTS"]

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", layout: false
#
# With alternative layout
# page "/path/to/file.html", layout: :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy pages (https://middlemanapp.com/advanced/dynamic_pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", locals: {
#  which_fake_page: "Rendering a fake page with a local variable" }

proxy "/blog.html", "/posts/tag.html", locals: { page_type: "all", tagname: "all" }
page "/feed.xml", layout: false
page "/sitemap.xml", layout: false, directory_index: false

ignore "/posts/article.tt"
