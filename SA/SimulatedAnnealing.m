function [ bestFitness bestSolution fitnesses solutions ] = SimulatedAnnealing( schedule, rooms, students )
% SimulatedAnnealing Algorithm to find best schedule
% (Adapted from X-S Yang, Cambridge University)
% 
% schedule Schedule
%    rooms List(Classroom)
% students List(Student)
% 
% Returns the best fitness and solutions for the inputs

% Initializing parameters and settings
T_min = 1;        % Final stopping temperature
F_min = 0;        % Min value of the function
max_rej = 1000;   % Maximum number of rejections
max_run = 250;    % Maximum number of runs
max_accept = 15;  % Maximum number of accept
k = 1;            % Boltzmann constant
alpha = 0.9;      % Cooling factor
guess = schedule; % Initial guess

% Initializing the counters i,j etc
i = 0;
j = 0;
accept = 0;

% Initializing various values
E_init = GetFitness(guess, students);
T_init = E_init; % Initial temperature is initial fitness
T = T_init;
E_old = E_init;
E_new = E_old;
T_iteration = 1;
iter = 1;

% Starting the simulated annealling
while (T > T_min) && (j <= max_rej) && (E_new > F_min),
    i = i + 1;

    % Check if max numbers of run/accept are met
    if (i >= max_run) || (accept >= max_accept),

        % Cooling according to a cooling schedule
        T = T_init * (alpha ^ T_iteration);
        T_iteration = T_iteration + 1;

        % Reset the counters
        i = 1;
        accept = 1;
    end

    % Function evaluations at new locations
    nextGuess = GetRandomNeighbour(guess, rooms);
    E_new = GetFitness(nextGuess, students);
    % Decide to accept the new solution
    DeltaE = E_new - E_old;
    
    % Accept if improved
    if DeltaE < 0,
        guess = nextGuess;
        E_old = E_new;
        accept = accept + 1;
        j = 0;
    end

    % Accept with a small probability if not improved
    if (DeltaE >= 0) && (exp(-DeltaE / (k * T)) > rand),
        guess = nextGuess;
        E_old = E_new;
        accept = accept + 1;
    else
        j = j + 1;
    end

    solutions(iter) = guess; %#ok
    fitnesses(iter) = E_old; %#ok
    
    iter = iter + 1;
end

bestFitness = min(fitnesses);
bestSolutions = find(fitnesses == bestFitness);
bestSolution = solutions(bestSolutions(end));

% Display the final results
fprintf('Evaluations:    %d\n', iter);
fprintf('Best Objective: %d\n', max(fitnesses));

end
