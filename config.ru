require "bundler/setup"
require "middleman-core/load_paths"

Middleman.setup_load_paths

require "middleman-core"
require "middleman-core/preview_server"

class Middleman::PreviewServer
  def self.preview_in_rack
    @server_information = ServerInformation.new
    @options = { latency: 0.25  }
    @app = new_app
    start_file_watcher
  end
end

Middleman::PreviewServer.preview_in_rack
run Middleman::PreviewServer.app.class.to_rack_app
