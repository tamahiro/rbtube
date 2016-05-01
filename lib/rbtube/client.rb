require 'net/http'

module Rbtube
  class Client
    attr_reader :js_code, :filename, :video_url, :http_client
    YOUTUBE_BASE_URL = 'https://www.youtube.com/watch'.freeze

    def initialize(params = {})
      @video_url = params[:video_url]
      @vidoe_uri = URI.parse(@video_url)
      @http_client = nil
    end
  end
end
