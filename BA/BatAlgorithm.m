function [ bestFitness bestSolution fitnesses solutions ] = BatAlgorithm( ...
    numDays, numTimeslots, courses, rooms, students, ...
    popSize, maxIterations, loudness, pulseRate, handle)
% BatAlgorithm Algorithm to find best schedule
% (Adapted from X-S Yang, Cambridge University)
%
%       numDays Number
%  numTimeslots Number
%       courses List(Course)
%         rooms List(Classroom)
%      students List(Student)
%       popSize Number
% maxIterations Number
%      loudness Number
%     pulseRate Number
%        handle Object Handles
%
% Returns the best fitness and solutions for the inputs

np      = popSize;          % Population size
maxIter = maxIterations;    % Number of generations
A       = loudness;         % Loudness (constant or decreasing)
r       = pulseRate;        % Pulse rate (constant or decreasing)

Qmin = 0;         % Frequency minimum
Qmax = 1;         % Frequency maximum

v = zeros(np, 1); % Velocities

% Initialize the population/solutions
sols = Schedule.empty(np, 0);
fits = zeros(1, np);
for i = 1:np,
    sols(i) = GenerateInitialSolution(numDays, numTimeslots, courses, rooms);
    fits(i) = GetFitness(sols(i), students);
end

% Find the initial best solution
[bestFitness, I] = min(fits);
bestSolution = sols(I);

% Containers to measure the best solution per iteration
solutions = Schedule.empty(maxIter, 0);
fitnesses = zeros(1, maxIter);

% Start the iterations
for iteration = 1:maxIter,
    
    % Loop over all bats/solutions
    for i = 1:np,
        
        Q = Qmin + (Qmax - Qmin) * rand;
        v(i) = (fits(i) - bestFitness) * Q;
        
        % Pulse rate
        if rand < r,
            S = Alter(bestSolution, 1, rooms);
        else
            S = Alter(sols(i), max(1, ceil(log10(abs(v(i))))), rooms);
        end
        
        % Evaluate new solutions
        fitnessnew = GetFitness(S, students);
        
        % Update if the solution improves, and not too loud
        if (fitnessnew <= fits(i)) && (rand < A),
            sols(i) = S;
            fits(i) = fitnessnew;
        end
        
        % Update the global best solution
        if fitnessnew <= bestFitness,
            bestSolution = S;
            bestFitness = fitnessnew;
            
            fprintf('iter = %4d; fitness = %d\n', iteration, bestFitness);
        end
    end
    
    [bestFit, bestFitIndex] = min(fits);
    fitnesses(iteration) = bestFit;
    solutions(iteration) = sols(bestFitIndex);

    % update the UI with the global best fitness after this iteration 
    set(handle.Cur_Iter_val,'String', int2str(iteration));
    set(handle.Cur_Best_val,'String', int2str(bestFitness));
    drawnow;
    
end

end


function s = Alter(p, v, rooms)

s = p;
for i = 1:v,
    s = GetRandomNeighbour(s, rooms);
end

end
