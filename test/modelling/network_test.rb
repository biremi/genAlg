require_relative "../../lib/modelling"
require "test/unit"
 
class GraphTest < Test::Unit::TestCase
 
  def test_generate
    graph = Modelling::Graph.generate(20, 50)
    assert_equal({}, graph)
  end
end
