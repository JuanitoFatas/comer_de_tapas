require_relative '../lib/comer_de_tapas'

require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

# ensures  using the gem, and not the built-in.
gem 'minitest'
require 'minitest/autorun'

module ComerDeTapas
  class Test < Minitest::Test
  end
end

