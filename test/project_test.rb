require_relative 'test_helper'

require 'lib/project'

class ProjectTest < Test::Unit::TestCase
  def test_get_success
    VCR.use_cassette("#{self.class}/#{__method__}") do
      projects = Conduit::Project.find_by_phids(%w(PHID-PROJ-o2ghhdqrnnhccudwekzd PHID-PROJ-ic6son3yl5tcvafnqbn6))
      names = projects.collect(&:name)
      assert_equal(['Neon', 'Neon Jenkins Administrators'].sort, names.sort)
    end
  end
end
