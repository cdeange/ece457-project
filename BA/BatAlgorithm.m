function [ bestFitness bestSolution ] = BatAlgorithm( ...
    numDays, numTimeslots, courses, rooms, students )
% BatAlgorithm Algorithm to find best schedule
% (Adapted from X-S Yang, Cambridge University)
%
%      numDays Number
% numTimeslots Number
%      courses List(Course)
%        rooms List(Classroom)
%     students List(Student)
%
% Returns the best fitness and solutions for the inputs

np    = 20;      % Population size
N_gen = 100;     % Number of generations
A     = 0.7;     % Loudness (constant or decreasing)
r     = 0.5;     % Pulse rate (constant or decreasing)

Qmin = 0;        % Frequency minimum
Qmax = 4;        % Frequency maximum

Q = zeros(np, 1); % Frequency
v = zeros(np, 1); % Velocities

% Initialize the population/solutions
solutions = Schedule.empty(np, 0);
fitnesses = zeros(1, np);
for i = 1:np,
    solutions(i) = GenerateInitialSolution(numDays, numTimeslots, courses, rooms);
    fitnesses(i) = GetFitness(solutions(i), students);
end

% Find the initial best solution
[bestFitness, I] = min(fitnesses);
bestSolution = solutions(I);

% Start the iterations
for t = 1:N_gen,
    
    % Loop over all bats/solutions
    for i = 1:np,
        Q(i) = Qmin + (Qmin - Qmax) * rand;
        
        f1 = GetFitness(solutions(i), students);
        f2 = GetFitness(bestSolution, students);
        
        v(i) = v(i) + (f1 - f2) * Q(i);
        S(i) = Alter(solutions(i), v(i), rooms);
        
        % Pulse rate
        if rand < r,
            S(i) = Alter(bestSolution, 1, rooms); %#ok
        end
        
        % Evaluate new solutions
        fitnessnew = GetFitness(S(i), students);
        
        % Update if the solution improves, or not too loud
        if (fitnessnew <= fitnesses(i)) && (rand < A),
            solutions(i) = S(i);
            fitnesses(i) = fitnessnew;
        end
        
        % Update the global best solution
        if fitnessnew <= bestFitness,
            bestSolution = S(i);
            bestFitness = fitnessnew;
        end
    end
    
end

end


function s = Alter(p, v, rooms)

s = p;
for i = 1:v,
    s = GetRandomNeighbour(s, rooms);
end

end
