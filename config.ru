#\ -s puma
require 'rack'
require 'rack/contrib/try_static'
require 'rack/deflater'
require 'rack/cache'

ONE_WEEK = 604_800

use Rack::Auth::Basic, "Restricted Area" do |u, p|
  [u, p] == [ENV['HTTP_AUTH_USER'], ENV['HTTP_AUTH_PASS']]
end

# Serve files from the build directory
use Rack::TryStatic,
    root: 'build',
    urls: %w[/],
    try: %w(.html index.html /index.html),
    header_rules: [
        [
            %w(css js png jpg woff html),
            { 'Cache-Control' => "public, max-age=#{ONE_WEEK}" }
        ]
    ]

# Forces SSL on all requests
unless ENV['RACK_ENV'] == 'development'
  require 'rack/ssl'
  use Rack::SSL
end

# 404 Support
run lambda { |env|
      four_oh_four_page = File.expand_path('../build/404.html', __FILE__)
      [
          404,
          {'Content-Type'  => 'text/html', 'Cache-Control' => "public, max-age=#{ONE_WEEK}"},
          [ File.read(four_oh_four_page) ]
      ]
    }

#==== MIDDLEMAN DEFAULTS ====

# require 'middleman-core'
# require 'middleman-core/rack'
# require 'middleman-core/load_paths'
# ::Middleman.setup_load_paths

# require 'fileutils'
# FileUtils.mkdir('log') unless File.exist?('log')
# ::Middleman::Logger.singleton("log/#{ENV['RACK_ENV']}.log")

# app = ::Middleman::Application.new

# run ::Middleman::Rack.new(app).to_app
