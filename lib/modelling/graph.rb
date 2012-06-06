module Modelling
  class Graph
    class VertexAlreadyExist < StandardError; end
    class VertexDoesNotExist < StandardError; end
    class EdgeAlreadyExist < StandardError; end

    class << self
      def read(file_path)
        raise FileNotFound unless File.exists?(file_path)
        graph = File.open(file_path) do|file|
          Marshal.load(file)
        end
      end
    end

    def initialize
      @vertices = {}
      @adjacency_list = {}
    end

    def save!(file_path)
      File.open(file_path,'w') do|file|
        Marshal.dump(self, file)
      end
    end

    attr_accessor :adjacency_list, :vertices

    # Graph contruction
    def add_vertex(id, vertex)
      vertix_should_not_exist!(id)
      vertices[id] = vertex
    end

    def remove_vertex(id)
      vertix_should_exist!(id)
      vertices.delete(id)
      remove_adjacency_list_for_vertex(id)
    end

    def add_edge(source_id, destination_id, edge)
      vertices_should_exist!(source_id, destination_id)
      edge_should_not_exist!(source_id, destination_id)
      vertex_adjacency_list(source_id)[destination_id] = edge
    end

    # Guards
    def vertix_should_exist!(id)
      raise VertexDoesNotExist, "Vertex ID: #{id}" unless has_vertex?(id)
    end

    def vertices_should_exist!(*ids)
      ids.each {|id| vertix_should_exist!(id)}
    end

    def vertix_should_not_exist!(id)
      raise VertexAlreadyExist, "Vertex ID: #{id}" if has_vertex?(id)
    end

    def edge_should_not_exist!(source_id, destination_id)
      raise EdgeAlreadyExist, "SRC: #{source_id}, DSC: #{destination_id}" \
        if has_edge?(source_id, destination_id)
    end

    #Chekers
    def has_edge?(source_id, destination_id)
      vertices_should_exist!(source_id, destination_id)
      return false unless adjacency_list.has_key?(source_id)
      adjacency_list[source_id].has_key?(destination_id)
    end

    def has_vertex?(vertex_id)
      vertices.has_key?(vertex_id)
    end

    def adjacent_vertices(id)
      adjacency_list[id]
    end

    private
    def remove_adjacency_list_for_vertex(id)
      adjacency_list.delete(id)
      adjacency_list.each do |edge_list|
        edge_list.delete(id)
      end
    end

    def vertex_adjacency_list(id)
      adjacency_list[id] = {} unless adjacency_list.has_key?(id)
      adjacency_list[id]
    end
  end

  module RouteHelper
    def all_routes(source_id, destination_id)
    end

    private
    def depth_search
    end
  end
end
