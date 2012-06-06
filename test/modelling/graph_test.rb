require_relative "../../lib/modelling"
require "test/unit"
 
class GraphTest < Test::Unit::TestCase
 
  def test_initialize
    graph = Modelling::Graph.new()
    assert_equal({}, graph.vertices)
    assert_equal({}, graph.adjacency_list)
  end

  def test_add_vertix
    graph = Modelling::Graph.new()
    vertex = {:name => "Some name"}
    graph.add_vertex(1, vertex)
    assert_equal(vertex, graph.vertices[1])
    assert_equal({}, graph.adjacency_list)
  end
 
  def test_add_vertix_failure
    graph = setup_graph
    vertex = {:name => "Vertex #2"}
    assert_raise(Modelling::Graph::VertexAlreadyExist) do 
      graph.add_vertex(1, vertex)
    end
  end

  def test_add_edge
    graph = setup_graph
    source_id = random_vertice(graph)
    destination_id = random_vertice(graph)
    edge = {:weight => rand(100)}
    graph.add_edge(source_id, destination_id, edge)
    assert_equal(edge, graph.adjacency_list[source_id][destination_id])
  end

  def test_add_edge_not_existing_vertices
    graph = setup_graph
    source_id = random_vertice(graph)
    destination_id = random_vertice(graph) + 100
    edge = {:weight => rand(100)}
    assert_raise(Modelling::Graph::VertexDoesNotExist) do
      graph.add_edge(source_id, destination_id, edge)
    end
  end

  def test_add_edge_already_exist
    graph = setup_graph
    source_id = random_vertice(graph)
    destination_id = random_vertice(graph)
    edge = {:weight => rand(100)}
    graph.add_edge(source_id, destination_id, edge)
    assert_raise(Modelling::Graph::EdgeAlreadyExist) do
      graph.add_edge(source_id, destination_id, edge)
    end
  end

  private
  def setup_graph
    graph = Modelling::Graph.new()
    add_vertices(graph, 10)
    graph
  end

  def add_vertices(graph, number)
    number.times do |i|
      vertex = {:name => "Vertex ##{i}"}
      graph.add_vertex(i, vertex)
    end
  end

  def add_edge(graph)
    source_id = random_vertice(graph)
    destination_id = random_vertice(graph)
    edge = {:weight => rand(100)}
    graph.add_edge(source_id, destination_id, edge)
  end

  def random_vertice(graph)
    id = graph.vertices.keys.sample
  end
end
