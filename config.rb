###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

# General configuration

config[:images_dir] = 'assets/images'
config[:css_dir] = 'assets/dist/stylesheets'
config[:js_dir] = 'assets/dist/javascripts'

# # ignore css and js, b/c we're handling with external pipeline
ignore 'assets/stylesheets/*'
ignore 'assets/javascripts/*'

# explicitly set the markdown engine to Kramdown
set :markdown_engine, :kramdown

###
# Helpers
###

# Methods defined in the helpers block are available in templates
helpers do
    # build an array of the chapters from blog article frontmatter
    def get_chapters
        chapters = []
        data.chapters.each do |chapter|
            chapters.push(chapter)
        end
        return chapters
    end

    def find_chapter_index(chapter)
        chapters = get_chapters
        if chapters.include?(chapter)
            return chapters.index(chapter)
        else
            return false
        end
    end

    def next_chapter(chapter)
        # find next chapter in TOC
        if find_chapter_index(chapter) < (get_chapters.length - 1)
            return get_chapters[find_chapter_index(chapter) + 1]
        else
            return false
        end
    end

    def prev_chapter(chapter)
        # find previous chapter in TOC
        if find_chapter_index(chapter) > 0
            return get_chapters[find_chapter_index(chapter) - 1]
        else
            return false
        end
    end

    def current_page?(url)
        if current_page.url == url then
            return true
        else
            return false
        end
    end
end

# Generate proxy pages from the blog articles' "chapter" frontmatter
data.chapters.each do |chapter|
    proxy "#{chapter.urlize}/index.html", "/chapter.html", :locals => {
        title: chapter
    }, :ignore => true
end

# activate :directory_indexes
# page "README.md", :directory_index => false
# page "LICENSE", :directory_index => false
# page "404.html", :directory_index => false

activate :relative_assets

# Reload the browser automatically whenever files change
configure :development do
    activate :external_pipeline,
        name: :npm,
        command: 'npm start',
        source: "source/assets/dist",
        latency: 1

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
