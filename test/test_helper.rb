require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/reporters'
Minitest::Reporters.use!

require File.expand_path(File.dirname(__FILE__) + '/../lib/gandy_dancer')