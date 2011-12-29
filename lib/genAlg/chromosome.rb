module GenAlg
  class Chromosome < Array

    def initialize(*args)
      block_given? ? super(*args) : super(args)
    end

    def fitness(proc)
      proc.call(self)
    end

    def to_s
      self.join("-")
    end

    def <=>(chromo)
      self.fitness <=> chromo.fitness
    end
  end
end
