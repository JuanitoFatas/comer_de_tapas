require 'test_helper'

class CliTest < ComerDeTapas::Test
  def setup
    @cli = ComerDeTapas::CLI.new
  end

  def test_cli_version
    out, _ = capture_io { @cli.version }
    assert_match %r(\d.\d.\d), out
  end
end