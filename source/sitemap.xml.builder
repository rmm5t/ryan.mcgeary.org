xml.instruct!
xml.urlset xmlns: "http://www.sitemaps.org/schemas/sitemap/0.9" do
  sitemap.resources.each do |page|
    next unless page.path =~ /\.html$/
    next if page.is_a?(Middleman::Sitemap::AliasResource)
    next if page.is_a?(Middleman::Sitemap::Extensions::Redirects::RedirectResource)
    next if page.data.priority && page.data.priority <= 0
    next if page.metadata[:locals]["page_type"] == "day"
    next if page.metadata[:locals]["page_type"] == "month"
    xml.url do
      xml.loc URI.join(data.site.url, page.url)
      xml.lastmod File.mtime(page.source_file).iso8601 if page.source_file
      xml.changefreq page.data.changefreq || "monthly"
      xml.priority page.data.priority || "0.5"
    end
  end
end
