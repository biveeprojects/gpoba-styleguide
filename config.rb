###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

# With alternative layout
# page "/path/to/file.html", layout: :otherlayout

# General configuration

config[:images_dir] = 'assets/images'
config[:css_dir] = 'stylesheets'
config[:js_dir] = 'javascripts'

# ignore css and js, b/c we're handling with external pipeline
ignore 'assets/stylesheets/*'
ignore 'assets/javascripts/*'

activate :external_pipeline,
    name: :npm,
    command: build? ? 'npm run build' : 'npm start',
    source: ".tmp/dist",
    latency: 1

# Set up the blogging extensions
activate :blog do |blog|
  blog.name = "chapters"
  blog.sources = "chapters/{chapter_weight}-{chapter}/{title}.html"

  # blog.custom_collections = {
  #   chapter: {
  #       link: "{chapter_weight}/{chapter}.html",
  #       template: "chapter.html"
  #   }
  # }
end

activate :directory_indexes

###
# Helpers
###

# Methods defined in the helpers block are available in templates
helpers do
    # instead of using blog collections, we need to extract chapter data from blog article frontmatter for our proxy pages (see below)
    def build_chapters(articles)
        chapters = []
        articles.each do |article|
            chapter = article.metadata[:page]['chapter']
            chapters.push(chapter) unless chapters.include? chapter
        end
        return chapters
    end

    def active_link_to(caption, url, options = {})
        if current_page.url == "#{url}/"
            options[:class] = "main_nav-item is-active"
        end

        link_to(caption, url, options)
    end
end

# Generate proxy pages from the blog articles' "chapter" frontmatter
build_chapters(blog("chapters").articles.sort_by()).each do |chapter| {
    proxy "/#{chapter}.html", "/template-file.html", locals: {
        which_fake_page: "Rendering a fake page with a local variable"
    } :ignore => true
}

# Reload the browser automatically whenever files change
configure :development do
    activate :livereload
end

# Build-specific configuration
configure :build do
    # Minify CSS on build
    # activate :minify_css

    # Minify Javascript on build
    # activate :minify_javascript
end

# For heroku use https else default to http
ENV['RACK_ENV'] == 'production' ? http = 'https' : http = 'http'

# For Heroku Builds
set :url_root, "#{http}://#{ENV['APP_DOMAIN'] ? ENV['APP_DOMAIN'] : 'localhost:4567'}"
