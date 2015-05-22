xml.instruct!
xml.feed "xmlns" => "http://www.w3.org/2005/Atom" do
  xml.title data.site.name
  xml.subtitle "Brain Dumps by Ryan"
  xml.id URI.join(data.site.url, blog.options.prefix.to_s)
  xml.link "href" => URI.join(data.site.url, blog.options.prefix.to_s)
  xml.link "href" => URI.join(data.site.url, current_page.path), "rel" => "self"
  xml.updated(blog.articles.first.date.to_time.iso8601) unless blog.articles.empty?
  xml.author do
    xml.name data.site.name
    xml.email data.site.email
  end

  blog.articles[0..100].each do |article|
    xml.entry do
      xml.title article.title
      xml.link "rel" => "alternate", "href" => URI.join(data.site.url, article.url)
      xml.link "rel" => "enclosure", "type" => "audio/mpeg", "href" => article.data.mp3 if article.data.mp3
      xml.link "rel" => "enclosure", "type" => "audio/ogg",  "href" => article.data.ogg if article.data.ogg
      xml.id URI.join(data.site.url, article.url)
      xml.published article.date.to_time.iso8601
      xml.updated File.mtime(article.source_file).iso8601
      xml.author { xml.name "Article Author" }
      # xml.summary article.summary, "type" => "html"
      xml.content article.body, "type" => "html"
    end
  end
end
