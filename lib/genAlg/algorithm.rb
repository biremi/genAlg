module GenAlg
  class Algorithm
    def initialize(params)
      @population = GenAlg::Population.new(:chromosomes => params[:chromosomes])
      @mutation_options = params[:mutation]
      @crossover_options = params[:crossover]
      @selection_options = params[:selection]
      @max_iterations = params[:max_iterate]

    end

    def iterate
      @max_iterations.times do
        p "Starting genetic process ..."
        p "Crossover ..."
        @population.crossover!(@crossover_options) #add mutation method here
        p "Mutation ..."
        @population.mutation!(@mutation_options)
        p "Selection ..."
        @population.selection!(@selection_options)	
        @population.age = @population.age + 1
        yield @population
      end
    end
  end
end
