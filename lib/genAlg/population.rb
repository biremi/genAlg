module GenAlg
  class Population
    attr_accessor :age

    def initialize(params)
      @age = 0
      @chromosomes = params[:chromosomes]
    end

    # Mutation method
    # Parameters: 
    #  mutation percentage - percentage of chromosomes in population to change
    def mutation!(params)
      mutation_percent = params[:percentage]
      mutation_method = params[:method]
      (@chromosomes.size * mutation_percent).to_i.times do
        @chromosomes << mutation_method.call(@chromosomes[rand(@chromosomes.size)])
      end				
    end

    def crossover!(params)
      crossover_percent = params[:percentage]
      crossover_method = params[:method]
      (@chromosomes.size * crossover_percent).to_i.times do
        crossover_method.call(@chromosomes[rand(@chromosomes.size)], @chromosomes[rand(@chromosomes.size)]).each {|chromo| @chromosomes << chromo}
      end
    end

    def selection!(params)
      fitness_method = params[:method]
      max_chromosomes = params[:pop_size]
      @chromosomes.sort! {|a, b| b.fitness(fitness_method) <=> a.fitness(fitness_method)}
      @chromosomes.slice!(max_chromosomes..@chromosomes.size) if @chromosomes.size > max_chromosomes
    end

    def best_fit(params)
      fitness_method = params[:method]
      @chromosomes.max {|a, b| b.fitness(fitness_method) <=> a.fitness(fitness_method)}
    end

    def to_s
      @chromosomes.each.inject {|str, val| str.to_s + "||" +  val.to_s}
    end

    def size
      @chromosomes.size
    end
  end
end
