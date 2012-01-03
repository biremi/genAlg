require_relative '../lib/balancer'

class BinChromo < GenAlg::Chromosome
  def mutate
    #Logger.info("Mutation: #{self}")
    alleles[rand(size) + 1] = rand(100)
    #Logger.info(" ----> #{self}")
    self
  end

  def fitness
    alleles.each.inject {|sum, value| sum + value}
  end

  def crossover(chromosome)
    cross_point1 = rand(size)
    cross_point2 = rand(chromosome.size)
    res1 = BinChromo.new()
    res2 = BinChromo.new()

    alleles[0..cross_point1 - 1].each {|allel| res1.push(allel)}
    chromosome.alleles[cross_point2..chromosome.size].each {|allel| res1.push(allel)}
    chromosome.alleles[0..cross_point2 - 1].each {|allel| res2.push(allel)}
    alleles[cross_point1..size].each {|allel| res2.push(allel)}
    #Logger.info "Crossover: #{to_s}, #{chromosome.to_s} --->> #{res1.to_s}, #{res2.to_s}"
    [res1, res2]
  end
end

 #Define chromosomes
 ch1 = BinChromo.new([13, 35, 74, 0, 14])
 ch2 = BinChromo.new([54, 2, 16, 20, 1])
 ch3 = BinChromo.new([12, 35, 7, 50, 5])
 ch4 = BinChromo.new([53, 62, 6, 8, 9])
 ch5 = BinChromo.new([13, 75, 74, 13, 14])
 ch6 = BinChromo.new([24, 2, 16, 20, 1])

 
 # Initialize algorithm by defining all params
 algorithm = GenAlg::Algorithm.new(
   :mutation_rate => 0.1,
   :crossover_rate => 0.3,
   :max_size => 20,
   :max_generrtion => 2
 )
 algorithm.init_population([ch1, ch2, ch3, ch4, ch5, ch6])
 #run your own genetic algorithm
 algorithm.evolve do |population|
  p "Population: age: #{population.age}, size: #{population.size}, avg_fit: #{population.avg_fitness}, best_fit: #{population.best_fitness}"
  #p "Chromosomes: #{population.to_s}"
 end 
