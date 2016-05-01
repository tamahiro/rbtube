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
end
