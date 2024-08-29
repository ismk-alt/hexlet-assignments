# frozen_string_literal: true

require_relative 'test_helper'
require_relative '../lib/stack'

class StackTest < Minitest::Test
  # BEGIN
  def setup
    @stack = Stack.new
  end

  def test_push
    @stack.push!('ruby')
    refute @stack.empty?
  end
  
  def test_pop
    @stack.push!('ruby')
    value = @stack.pop!
    assert_equal 'ruby', value
    assert @stack.empty?
  end
  
  def test_clear
    @stack.push!('ruby')
    value = @stack.clear!
    assert_empty @stack
  end
  
  def test_empty
    @stack.empty?
  end
  # END
end

test_methods = StackTest.new({}).methods.select { |method| method.start_with? 'test_' }
raise 'StackTest has not tests!' if test_methods.empty?
