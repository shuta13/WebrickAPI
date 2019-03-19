require 'webrick'
require 'json'

class WebrickAPI
  def initialize(bind_address: '127.0.0.1', port: 10080)
    @srv = WEBrick::HTTPServer.new(
      BindAddress: bind_address,
      Port: port
    )
    default_mount_proc
    trap('INT') { @srv.shutdown }
  end

  def start
    @srv.start
  end

  private

  def default_mount_proc
    @srv.mount_proc('/') do |req, res|
      log_request(req)
      res.body = {}.to_json
    end
  end

  def log_request(req)
    info = "method=#{req.request_method}, uri=#{req.request_uri}, query=#{req.query}, body=#{req.body}"
    @srv.logger.info(info)
  end
end

srv = WebrickAPI.new()
srv.start
