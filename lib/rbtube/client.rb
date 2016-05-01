require 'net/http'
require 'json'

module Rbtube
  class Client
    attr_reader :js_code, :filename, :video_uri, :http_client
    YOUTUBE_BASE_URL = 'https://www.youtube.com/watch'.freeze
    JSON_START_PATTERN = 'ytplayer.config = '.freeze
    JSON_START_LENGTH = 18

    def initialize(url)
      @video_uri, @video_key = _parse_url(url)
      @http_client = Net::HTTP
    end

    def fetch_data_from_url
      video_urls.each.with_index(1) do |url, index|
        itag, quality_profile = _quality_profile_from_url(url)
        next if quality_profile
      end
    end

    def video_data
      unless @video_data
        response = http_client.get_response(video_uri)
        json_data = _json_data(response.body)
        encoded_fmt_stream_map = json_data['args']['url_encoded_fmt_stream_map']
        json_data['args']['stream_map'] =
          _parse_stream_map(encoded_fmt_stream_map)
        @video_data = json_data
      else
        @video_data
      end
    end

    def video_title
      video_data['args']['title']
    end

    def video_urls
      video_data['args']['stream_map']['url']
    end

    def stream_map
      video_data['args']['stream_map']
    end

    def js_url
      "http:#{video_data['assets']['js']}"
    end

    private

    def _parse_url(url)
      if url && url.match(/\A#{YOUTUBE_BASE_URL}/)
        uri = URI.parse(url)
        math_video_key = uri.query.match(/v=(.+)/)
        [uri, math_video_key && math_video_key[1]]
      else
        raise('Invalid url params. Please set a url like: '\
				      'https://www.youtube.com/watch?v=AANwFq43Qaw .')
      end
    end

    def _json_data(origin_html)
      pattern_index = origin_html.index(/#{JSON_START_PATTERN}/)
      start_position = pattern_index + JSON_START_LENGTH
      tmp_html = origin_html[start_position..-1]
      offset_position = _json_offset(tmp_html)
      JSON.parse(tmp_html[0..offset_position])
    end

    def _json_offset(target_html)
      unmatched_brackets_num = 0
      offset_num = 0
      index = 0
      char_count = target_html.size

      target_html.each_char.with_index do |char, i|
        case char
        when '{'
          unmatched_brackets_num += 1
        when '}'
          unmatched_brackets_num -= 1
          if unmatched_brackets_num.zero?
            index = i
            break
          end
        end
        raise('Couldn\'t define json offset.') if char_count == (i + 1)
      end

      offset_num + index
    end

    def _parse_stream_map(blob)
      hash = Hash.new { |h, k| h[k] = [] }
      videos = blob.split(',').map { |video| video.split('&') }
      videos.each do |video|
        video.each do |key_value_string|
          key, value = key_value_string.split('=')
          hash[key] << URI.decode(value)
        end
      end

      hash
    end

    def _quality_profile_from_url(url)
      binding.pry
    end
  end
end
