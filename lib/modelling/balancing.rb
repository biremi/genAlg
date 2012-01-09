module Modelling
  class FlowRequirement
    class FileNotFound < StandardError; end

    class << self
      def generate(network, count)
        requirement = FlowRequirement.new()
        count.times do
          random_flow = generate_random_flow(network)
          requirement << random_flow if random_flow
        end
        requirement
      end

      def read(file_path)
        raise FileNotFound unless File.exists?(file_path)
        requirement = FlowRequirement.new()
        requirement = File.open(file_path) do|file|
          Marshal.load(file)
        end
      end

      def generate_random_flow(network)
        source, destination = random_vertices(network)
        if network.path_exists?(source, destination)
          {vertices: [source, destination], flow: rand(10)}
        end
      end

      def random_vertices(network)
        [rand(network.size), rand(network.size)]
      end
    end

    attr_accessor :flows

    def initialize
      @flows = []
    end

    def <<(flow)
      flows << flow unless has_flow?(flow)
    end

    def each
      flows.each {|allel| yield allel}
    end

    def has_flow?(vertices)
      flows.any? do |flow|
        flow[:vertices] == vertices
      end
    end

    def save!(file_path)
      File.open(file_path,'w') do|file|
        Marshal.dump(self, file)
      end
    end
  end
end
