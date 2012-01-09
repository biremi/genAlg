require_relative '../lib/balancer'

size = 10
density = 60
#network = Modelling::Network.generate(size, density)
#network.save!("net_#{size}_#{density}.dmp")

network = Modelling::Network.read("net_#{size}_#{density}.dmp")
p "Network: #{network.inspect}"
p "Adj: #{network.adjacent_vertices(3)}"

# paths = network.paths(3, 4)
# p "Paths: #{paths}"
# paths.each do |path|
#   cost = network.path_cost(path)
#   p "Path = #{path}, Cost: #{cost}"
# end

#p "Shortest path: #{pp = network.shortest_path(3, 4)}"
# p "Best paths: #{network.best_paths([3, 4], 2)}"

requirements_size = 6
#requirement = Modelling::FlowRequirement.generate(network, requirements_size)
#requirement.save!("flow_requirement_#{network.size}_#{requirements_size}")
requirement = Modelling::FlowRequirement.read("flow_requirement_#{network.size}_#{requirements_size}")
flows = []
p "Requirement: #{requirement.flows}"
requirement.each do |f|
  paths = network.best_paths(f[:vertices], 3)
  paths.each do |path|
    flows << {path: path, flow: f[:flow] / paths.size}
  end
end

Logger.info "Max load: #{network.max_load_percentage(flows)}"
Logger.info "Min load: #{network.min_load_percentage(flows)}"
