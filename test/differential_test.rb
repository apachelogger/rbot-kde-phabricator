require(File.expand_path('test_helper', File.dirname(__FILE__)))

require 'lib/differential'

class DifferentialTest < Test::Unit::TestCase
  def test_get_success
    VCR.use_cassette("#{self.class}/#{__method__}") do
      diff = Conduit::Differential.get(2372)
      assert_equal('Make powerdevil normal executable instead of kded module', diff.title)
    end
  end
end
