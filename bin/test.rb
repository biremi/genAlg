require_relative '../lib/balancer'

class RoutingConfig < GenAlg::Chromosome
  def mutate
 #   Logger.info("Mutation: #{self.alleles}")
    result = RoutingConfig.copy(self)
    allel = result.alleles[rand(size)]
    allel.each_index do |i|
      pct_change = rand(100).to_f / 500
      pct_sign = rand(100) > 50 ? "+" : "-"
      if allel[i][:percentage] + pct_change > 1
        allel[i][:percentage] -= pct_change
      elsif allel[i][:percentage] - pct_change < 0
        allel[i][:percentage] += pct_change
      elsif pct_sign == "+"
        allel[i][:percentage] += pct_change
      else
        allel[i][:percentage] -= pct_change
      end
    end
    pct_sum = allel.inject(0) {|sum, path_params| sum + path_params[:percentage]}
    pct_diff = 1.0 - pct_sum
    smpl = allel.sample
    allel.each do |path_params|
      path_params[:percentage] += pct_diff if path_params[:path] == smpl[:path]
    end
    #Logger.info(" ----> #{self}")
    result
  end

  def fitness
    flows = []
    $requirement.each do |f|
      allel = find_allel(f[:vertices])
      allel.each do |path_params|
        flow = {
          path: path_params[:path],
          flow: f[:flow] * path_params[:percentage]
        }
        flows << flow
      end
    end
    fit = $network.max_load_percentage(flows)
    1.0 / fit[:pct]
  end

  def crossover(chromosome)
    [self, chromosome]
  end

  def find_allel(vertices)
    alleles.find do |allel|
      allel.first[:path].first == vertices.first && allel.first[:path].last == vertices.last
    end
  end
end

size = 100
density = 60
#$network = Modelling::Network.generate(size, density)
#$network.save!("data/net_#{size}_#{density}.dmp")
$network = Modelling::Network.read("data/net_#{size}_#{density}.dmp")
requirements_size = 5

#$requirement = Modelling::FlowRequirement.generate($network, requirements_size)
#$requirement.save!("data/flow_requirement_#{$network.size}_#{requirements_size}")
$requirement = Modelling::FlowRequirement.read("data/flow_requirement_#{$network.size}_#{requirements_size}")

initial_population = []

initial_chromo = []
$requirement.each do |f|
  paths = $network.best_paths(f[:vertices], 3)
  allel = []
  paths.each do |path|
    allel << {path: path, percentage: 1.to_f / paths.size}
  end
  initial_chromo << allel
end

chromo = RoutingConfig.new(initial_chromo)
initial_population << chromo

20.times do |i|
  mutation_chromo = chromo.mutate
  initial_population << mutation_chromo
end

algorithm = GenAlg::Algorithm.new(
  :mutation_rate => 0.5,
  :crossover_rate => 0.0,
  :max_size => 30,
  :max_generation => 100
)
algorithm.init_population(initial_population)

algorithm.evolve do |population|
  p "Population: age: #{population.age}, size: #{population.size}, avg_fit: #{population.avg_fitness}, best_fit: #{population.best_fitness}"
  #p "Chromosomes: #{population.to_s}"
end 
