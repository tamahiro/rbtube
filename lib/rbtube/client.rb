require 'net/http'
require 'json'

module Rbtube
  class Client
    attr_reader :js_code, :filename, :video_uri, :http_client
    YOUTUBE_BASE_URL = 'https://www.youtube.com/watch'.freeze
    JSON_START_PATTERN = 'ytplayer.config = '.freeze
    JSON_START_LENGTH = 18
    QUALITY_PROFILES = {
      # flash
      5 => %w(flv 240p Sorenson\ H.263 N/A 0.25 MP3 64),
      # 3gp
      17 => %w(3gp 144p MPEG-4\ Visual Simple 0.05 AAC 24),
      36 => %w(3gp 240p MPEG-4\ Visual Simple 0.17 AAC 38),

      # webm
      43 => %w(webm 360p VP8 N/A 0.5 Vorbis 128),
      100 => %w(webm 360p VP8 3D N/A Vorbis 128),

      # mpeg4
      18 => %w(mp4 360p H.264 Baseline 0.5 AAC 96),
      22 => %w(mp4 720p H.264 High 2-2.9 AAC 192),
      82 => %w(mp4 360p H.264 3D 0.5 AAC 96),
      83 => %w(mp4 240p H.264 3D 0.5 AAC 96),
      84 => %w(mp4 720p H.264 3D 2-2.9 AAC 152),
      85 => %w(mp4 1080p H.264 3D 2-2.9 AAC 152)
    }.freeze

    QUALITY_PROFILE_KEYS = %w(extension resolution video_codec profile
                              video_bitrate audio_codec audio_bitrate).freeze

    def initialize(url)
      @video_uri, @video_key = _parse_url(url)
      @http_client = Net::HTTP
    end

    def fetch_data_from_url
      video_urls.each.with_index do |url, index|
        begin
          itag, quality_profile = _quality_profile_from_url(url)
          next unless quality_profile
        rescue => e
          puts [e.class, e.messgae, e.backtrace.join('\n')]
          next
        end

        unless url =~ /signature=/
          signature = _get_cipher(stream_map['s'][index], js_url)
          url += "&signature=#{signature}"
        end

        #self._add_video(url, self.filename, **quality_profile)
      end
    end

    def video_data
      if @video_data
        @video_data
      else
        response = http_client.get_response(video_uri)
        json_data = _json_data(response.body)
        encoded_fmt_stream_map = json_data['args']['url_encoded_fmt_stream_map']
        json_data['args']['stream_map'] =
          _parse_stream_map(encoded_fmt_stream_map)
        @video_data = json_data
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
      itags = url.scan(/itag=(\d+)/)

      if itags && itags.flatten!.size == 1
        itag = itags.first.to_i
        quality_profile = QUALITY_PROFILES[itag]
        if quality_profile
          [itag, QUALITY_PROFILE_KEYS.zip(quality_profile).to_h]
        else
          [itag, nil]
        end
      else
        raise('Condn\'t get encoding profile. ')
      end
    end

    def _get_cipher(signature, url)
      js_cache = _js_cache(url)
      func_name = js_cache.scan(/\.sig\|\|([a-zA-Z0-9$]+)\(/).flatten.first
      jsi = JSInterpreter.new(js_cache)
      initial_function = jsi.extract_function(func_name)
      initial_function.call([signature])
    end

    def _js_cache(url)
      @_js_cache ||=
        http_client.get_response(URI.parse(url)).body
    end
  end
end
