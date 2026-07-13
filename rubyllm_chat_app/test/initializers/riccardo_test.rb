require 'test_helper'

class RiccardoInitializerTest < ActiveSupport::TestCase
  setup do
    # Define Rainbow constant but not the method to simulate the production environment
    # where the gem is not loaded, but something else defines the constant.
    Object.const_set(:Rainbow, Module.new) unless Object.const_defined?(:Rainbow)
  end

  test "loading riccardo initializer does not raise NoMethodError for Rainbow" do
    assert_nothing_raised do
      load Rails.root.join('config/initializers/riccardo.rb')
    end
  end
end
