class GenAlg::Algorithm
  DEFAULT_MAX_GENERATION = 10
  CROSSOVER_OPTIONS = %w(crossover_percentage crossover_method)
  MUTATION_OPTIONS = %w(mutation_percentage mutation_method)

  class NoInitialPopulation < StandardError; end
  attr_accessor :population

  def initialize(params)
    @params = params
  end

  def init_population(population)
    @population = GenAlg::Population.new(
      :chromosomes => population,
      :algorithm_params => @params
    )
  end

  def evolve
    raise NoInitialPopulation unless population
    Logger.info "Starting genetic algorithm ..."
    until termination_condition_reached? do
      Logger.info "Crossover ..."
      population.crossover!
      Logger.info "Mutation ..."
      population.mutation!
      Logger.info "Selection ..."
      population.selection!
      population.age += 1
      yield population
    end
  end

  def termination_condition_reached?
    case termination_condition
    when 'fitness'
      #TODO
      true
    when 'saturation'
      #TODO
      true
    when 'max_generation'
      max_generation_reached?
    else
      Logger.warn "Incorrect termination condition: #{termination_condition}.
                   We will use default condition: max_generation"
      max_generation_reached?
    end
  end

  def termination_condition
    @params[:termination_condition] || 'max_generation'
  end

  def max_generation_reached?
    max_generation = @params[:max_generation] || DEFAULT_MAX_GENERATION
    population.age >= max_generation
  end
end
