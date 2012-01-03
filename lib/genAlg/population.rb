class GenAlg::Population
  attr_accessor :age

  def initialize(params)
    @age = 0
    @chromosomes = params[:chromosomes]
    @algorithm_params = params[:algorithm_params]
  end

  def add_chromosome(chromosome)
    @chromosomes << chromosome
  end

  def add_chromosomes(chromosomes)
    chromosomes.each {|chromosome| add_chromosome(chromosome)}
  end

  def mutation!
    (size * mutation_rate).to_i.times do
      add_chromosome(random_chromosome.mutate)
    end				
  end

  def crossover!
    (size * crossover_rate).to_i.times do
      new_chromosomes = random_chromosome.crossover(random_chromosome)
      add_chromosomes(new_chromosomes)
    end
  end

  def selection!
    @chromosomes.sort! do |a, b|
      b.fitness <=> a.fitness
    end
    @chromosomes.slice!(max_size .. size) \
      if size > max_size
  end

  def best_fitness
    @chromosomes.max do |a, b|
      a.fitness <=> b.fitness
    end.fitness
  end

  def avg_fitness
    @chromosomes.inject(0) {|sum, chromo| sum + chromo.fitness} / size
  end

  def to_s
    @chromosomes.each.inject {|str, val| str.to_s + "||" +  val.to_s}
  end

  def size
    @chromosomes.size
  end

  def random_chromosome
    @chromosomes[rand(size)]
  end

  def mutation_rate
    @algorithm_params[:mutation_rate]
  end

  def crossover_rate
    @algorithm_params[:crossover_rate]
  end

  def max_size
    @algorithm_params[:max_size]
  end
end
