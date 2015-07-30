function [ bestFitness bestSolution fitnesses solutions ] = Genetic( courses, students, rooms, days, timeslots )
% Genetic Algorithm to find best schedule
%
%   courses List(Course)
%  students List(Student)
%     rooms List(Classroom)
%      days Number
% timeslots Number
%
% Returns the best fitness and solutions for the inputs

% Anonymous function to get the last index of a matrix
last = @(A) A(end);

% Initializing the parameters
popsize = 40; % Population size
MaxGen = 200; % Max number of generations
pc = 0.6; % Crossover probability
pm = 0.2; % Mutation probability

% Generating the initial population/fitness
popnew = Schedule.empty(popsize, 0);
for i = 1:popsize,
    popnew(i) = GenerateInitialSolution(days, timeslots, courses, rooms);
end

fitness = repmat(-Inf, 1, popsize);
fitnesses = zeros(1, MaxGen);
solutions = Schedule.empty(MaxGen, 0);

% Start the evolution loop
for i = 1:MaxGen,
    % Record the history
    fitold = fitness;
    pop = popnew;
    
    for j = 1:popsize,
        
        if rand < pc,
            % Crossover
            ii = floor(popsize * rand) + 1;
            jj = floor(popsize * rand) + 1;
            
            [ popnew(ii), popnew(jj) ] = Crossover(pop(ii), pop(jj), rooms);
            [ fitness, popnew ] = evolve(ii, pop, popnew, fitness, fitold, students);
            [ fitness, popnew ] = evolve(jj, pop, popnew, fitness, fitold, students);
            
        else
            % Mutation
            kk = floor(popsize * rand) + 1;
            
            popnew(kk) = Mutate(pop(kk), pm, rooms);
            [ fitness, popnew ] = evolve(kk, pop, popnew, fitness, fitold, students);
        end
        
    end
    
    % Record the current best
    fitnesses(i) = max(fitness);
    solutions(i) = last(popnew(fitnesses(i) == fitness));
end

bestFitness = max(fitnesses);
bestSolution = last(solutions(fitnesses == bestFitness));

end


% Evolving the new generation
function [ fitness, popnew ] = evolve( i, pop, popnew, fitness, fitold, students )

newFitness = -GetFitness(popnew(i), students);
if newFitness >= fitold(i),
    % Child replaces parent
    fitness(i) = newFitness;
else
    % Parent stays
    fitness(i) = fitold(i);
    popnew(i) = pop(i);
end

end
