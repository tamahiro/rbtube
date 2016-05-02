require_relative '../spec_helper'
require 'pry'

describe Rbtube::JSInterpreter do
  let(:jsi) { Rbtube::JSInterpreter.new(code) }
  let(:code) { 'hoge' }

  describe '#initialize' do
    it 'should valid instance variables' do
      # TODO: implement this
    end
  end

  describe '#interpret_statement' do
    # TODO: implement this
  end

  describe '#interpret_expression' do
    # TODO: implement this
  end

  describe '#extract_object' do
    # TODO: implement this
  end

  describe '#extract_function' do
    # TODO: implement this
  end

  describe '#call_function' do
    # TODO: implement this
  end

  describe '#build_function' do
    # TODO: implement this
  end
end
