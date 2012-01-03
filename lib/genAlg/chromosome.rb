class GenAlg::Chromosome
  OBLIGATORY_METHODS = %w(fitness mutation crossover)

  class ObligatoryMethodNotDefined < StandardError; end
  attr_accessor :alleles

  def initialize(alleles=[])
    @alleles = alleles
  end

  def to_s
    alleles.join("-")
  end

  def push(allel)
    alleles << allel
  end

  def each
    alleles.each {|allel| yield allel}
  end

  def <=>(chromo)
    fitness <=> chromo.fitness
  end

  def size
    alleles.size
  end

  def method_missing(method, *args)
    raise ObligatoryMethodNotDefined \
      if OBLIGATORY_METHODS.include?(method)
  end
end
