require_relative '../lib/balancer'

 #Define chromosomes
 ch1 = GenAlg::Chromosome.new(13, 35, 74, 0, 14)
 ch2 = GenAlg::Chromosome.new(54, 2, 16, 20, 1)
 ch3 = GenAlg::Chromosome.new(12, 35, 7, 50, 5)
 ch4 = GenAlg::Chromosome.new(53, 62, 6, 8, 9)
 ch5 = GenAlg::Chromosome.new(13, 75, 74, 13, 14)
 ch6 = GenAlg::Chromosome.new(24, 2, 16, 20, 1)

 #Define fitness method
 # should return Fixnum
 fitness_method = Proc.new do |chromo| 
	chromo.each.inject {|sum, value| sum + value}
 end
 
 #Define mutation method
 #Should return Chromosome object
 mutation_method = Proc.new do |chromo|
	res = GenAlg::Chromosome.new()
    chromo.each {|allel| res << allel}
    res[rand(chromo.size) + 1] = rand(100)
    p "Mutation: #{chromo.to_s} --->> #{res.to_s}"
    res
 end
 
 #Define crossover method
 #Should return Array of Chromosome objects
 crossover_method = Proc.new do |chromo1, chromo2|
    cross_point1 = rand(chromo1.size)
	cross_point2 = rand(chromo2.size)
	res1 = GenAlg::Chromosome.new()
	res2 = GenAlg::Chromosome.new()

	chromo1[0..cross_point1 - 1].each {|allel| res1 << allel}
	chromo2[cross_point2..chromo2.size].each {|allel| res1 << allel}
	chromo2[0..cross_point2 - 1].each {|allel| res2 << allel}
	chromo1[cross_point1..chromo1.size].each {|allel| res2 << allel}
    p "Crossover: #{chromo1.to_s}, #{chromo2.to_s} --->> #{res1.to_s}, #{res2.to_s}"
	[res1, res2]
 end

 # Initialize algorithm by defining all params
 algorithm = GenAlg::Algorithm.new(:chromosomes => [ch1, ch2, ch3, ch4, ch5, ch6],
        :mutation => {:method => mutation_method, :percentage => 0.1},
        :crossover => {:method => crossover_method, :percentage => 0.3},
        :selection => {:method => fitness_method, :pop_size => 20},
		:max_iterate => 10)
 #run your own genetic algorithm
 algorithm.iterate do |population|
  p "Population: age: #{population.age}, size: #{population.size}"
  p "Chromosomes: #{population.to_s}"
 end 
