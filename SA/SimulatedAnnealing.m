function [ bestFitness bestSolution fitnesses solutions ] = SimulatedAnnealing( schedule, rooms, students, maxRej, maxRun, maxAccepts, inAlpha, handle )
%SIMULATEDANNEALING Summary of this function goes here
%   Detailed explanation goes here
%   Simulated Annealing (Adapted from X-S Yang, Cambridge University)

% Initializing parameters and settings
T_min = 1;       % Final stopping temperature
F_min = 0;       % Min value of the function
max_rej = maxRej;  % Maximum number of rejections
max_run = maxRun;   % Maximum number of runs
max_accept = maxAccepts; % Maximum number of accept
k = 1;           % Boltzmann constant
alpha = inAlpha;     % Cooling factor
guess = schedule;% Initial guess

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
    
    set(handle.Cur_Iter_val,'String', int2str(iter));
    set(handle.Cur_Temp_val,'String', num2str(T));
    set(handle.Cur_Best_val,'String', int2str(min(fitnesses)));
    drawnow;
    
    iter = iter + 1;
end

bestFitness = min(fitnesses);
bestSolutions = find(fitnesses == bestFitness);
bestSolution = solutions(bestSolutions(end));

% Display the final results
fprintf('Evaluations:    %d\n', iter);
fprintf('Best Objective: %d\n', max(fitnesses));

end
