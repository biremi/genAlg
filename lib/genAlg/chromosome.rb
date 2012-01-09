class GenAlg::Chromosome
  OBLIGATORY_METHODS = %w(fitness mutation crossover)

  class <<self
    def copy(chromo)
      copied_chromo = Marshal::load(Marshal.dump(chromo))
    end
  end

  class ObligatoryMethodNotDefined < StandardError; end
  attr_accessor :alleles

  def initialize(data=[])
    @alleles = data
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
