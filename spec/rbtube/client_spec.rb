require_relative '../spec_helper'
require 'pry'

describe Rbtube::Client do
  let(:client) { Rbtube::Client.new(url) }
  let(:url) { 'https://www.youtube.com/watch?v=AANwFq43Qaw' }

  describe '#initialize' do
    it 'should valid instance variables' do
      client.fetch_data_from_url
    end
  end

  describe '#fetch_data_from_url' do
    # TODO: implement this
  end

  describe '#video_data' do
    # TODO: implement this
  end

  describe '#video_title' do
    # TODO: implement this
  end

  describe '#video_urls' do
    # TODO: implement this
  end

  describe '#stream_map' do
    # TODO: implement this
  end

  describe '#js_url' do
    # TODO: implement this
  end

  describe 'private methods' do
    describe '#_parse_url' do
      # TODO: implement this
    end

    describe '#_json_data' do
      # TODO: implement this
    end

    describe '#_json_offset' do
      # TODO: implement this
    end

    describe '#_parse_stream_map' do
      # TODO: implement this
    end

    describe '#_quality_profile_from_url' do
      # TODO: implement this
    end

    describe '#_get_cipher' do
      # TODO: implement this
    end

    describe '#_js_cache' do
      # TODO: implement this
    end
  end
end
