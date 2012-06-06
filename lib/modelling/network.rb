module Modelling
  class Network
    class << self
      def generate(number, density)
        network = Graph.new()
        generate_vertices(network, number)
        generate_edges(network, density)
        network
      end

      def read(file_path)
        raise FileNotFound unless File.exists?(file_path)
        network = File.open(file_path) do|file|
          Marshal.load(file)
        end
      end

      private
      def generate_vertices(graph, number)
        number.times do |i|
          vertex = {:id => "#{i}"}
          graph.add_vertex(i, vertex)
        end
      end

      def generate_edges(graph, density)
        graph.vertices.each do |source_id, source_vertex|
          graph.vertices.each do |destination_id, destination_vertex|
            if rand(100) < density
              graph.add_edge(source_id, destination_id, generate_edge)
            end
          end
        end
      end

      def generate_edge
        {
          :weight => rand(100)
        }
      end
    end

    def save!(file_path)
      File.open(file_path,'w') do|file|
        Marshal.dump(self, file)
      end
    end

    #Chekers
    def edge_exists?(source_vertex, destination_vertex)
      @adjacency_matrix[source_vertex][destination_vertex] == 1
    end

    def edge_weight(source_vertex, destination_vertex)
      @edge_weight_matrix[source_vertex][destination_vertex]
    end

    #Generators
    def generate_adjacency_matrix
      @adjacency_matrix = Array.new(size) do |i|
        row = []
        size.times do |j|
          value = rand(100) >= density ? 0 : 1 
          row << value
        end
        row
      end
    end

    def generate_edge_weight_matrix
      @edge_weight_matrix = Array.new(size) do |i|
        row = @adjacency_matrix[i].map do |edge|
          edge == 1 ? rand(100) : 0
        end
      end
    end

    def generate_capacity_matrix
      @capacity_matrix = Array.new(size) do |i|
        row = @adjacency_matrix[i].map do |edge|
          edge == 1 ? rand(100) : 0
        end
      end
    end

    def adjacent_vertices(vertex)
      vertices = []
      @adjacency_matrix[vertex].each_index do |index|
        vertices << index if edge_exists?(vertex, index)
      end
      vertices
    end

    #Path helpers
    def paths(source_vertex, destination_vertex)
      PathHelper.find_paths(self, source_vertex, destination_vertex)
    end

    def path_exists?(source_vertex, destination_vertex)
      paths(source_vertex, destination_vertex).size > 0
    end

    def shortest_path(source_vertex, destination_vertex)
      paths(source_vertex, destination_vertex).min_by do |path|
        path_cost(path)
      end
    end

    def best_paths(vertices, count)
      sorted_paths = paths(*vertices).sort_by do |path|
        path_cost(path)
      end
      sorted_paths[0..count-1]
    end

    def path_cost(path)
      cost = 0
      path.each_index do |index|
        if path[index + 1]
          cost += self.edge_weight(path[index], path[index + 1])
        end
      end
      cost
    end

    def path_edges(path)
      edges = []
      path.each_index do |index|
        if path[index + 1]
          edges << [path[index], path[index + 1]]
        end
      end
      edges
    end
    
    #Flow helpers
    def max_load_percentage(paths_flow)
      load_matrix = calculate_load_matrix(paths_flow)
      load_matrix.flatten.compact.max_by do |l|
        l[:pct]
      end
    end

    def min_load_percentage(paths_flow)
      load_matrix = calculate_load_matrix(paths_flow)
      load_matrix.flatten.compact.min_by do |l|
        l[:pct]
      end
    end

    def calculate_load_matrix(paths_flow)
      load_matrix = []
      paths_flow.each do |options|
        edges = path_edges(options[:path])
        edges.each do |edge|
          capacity = @capacity_matrix[edge.first][edge.last]
          load_params = get_edge_load(load_matrix, [edge.first, edge.last])
          load_params[:value] += options[:flow]
          load_params[:pct] = load_params[:value].to_f / capacity
          load_matrix << load_params
        end
      end
      load_matrix
    end

    def get_edge_load(load_matrix, vertices)
      params = load_matrix.select {|l| l[:vertices] == vertices}
      if params.size > 0
        load_matrix.reject! {|l| l[:vertices] == vertices}
        params.first
      else
        {vertices: vertices, value: 0}
      end
    end
  end

  module PathHelper
    class << self
      def find_paths(network, source, destination)
        marked = [source]
        path = [source]
        pathes = depth_search(network, source, destination, marked, path)
      end

      def depth_search(network, source, destination, marked, path)
        paths = []
        unmarked_adjacent_vertices(network, source, marked).each do |vertex|
          new_path = path + [vertex]
          if vertex == destination
            paths << new_path
            next
          else
            marked << vertex
            paths += depth_search(network, vertex, destination, marked, new_path)
          end
        end
        paths
      end

      def unmarked_adjacent_vertices(network, source, marked)
        network.adjacent_vertices(source).select {|vertex| !marked.include?(vertex)}
      end
    end
  end
end
