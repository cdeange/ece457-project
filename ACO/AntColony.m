function [ bestSolution bestFitness fitnesses solutions ] = AntColony( courses, rooms, days, timeslots, ...
    numAnts, students, iterations, rho, handle )
% AntColony Algorithm to find best schedule
%
%    courses List(Course)
%      rooms List(Classroom)
%       days Number
%  timeslots Number
%    numAnts Number
%   students List(Student)
% iterations Number
%        rho Number
%
% Returns the best fitness and solutions for the inputs

bestSolution = 0;
bestFitness = Inf;
Q = GetKHard(length(courses), days, length(students));

acoNodes = ACONode.empty(length(courses), 0);
ants = Schedule.empty(numAnts, 0);

% Create the paths(courseMapping) for each course and create the ACONode for each
for i = 1:length(courses)
    acoNodes(i) = generateNodePaths(courses(i), rooms, days, timeslots);
end

% Create pheromones matrix
pheromones = zeros(length(acoNodes), length(rooms) * days * timeslots);

for i = 1:length(acoNodes)
    for j = 1:length(acoNodes(i).pathsToNext)
        pheromones(i, j) = 1;
    end
end


% Find path for each
% Until we get what we want: iteration/termination criteria
for iter = 1:iterations,
    pathsChosenByEachAnt = [];
    for i = 1:numAnts,
        [ antPath pathsChosen ] = getAntSolution(acoNodes, pheromones);
        pathsChosenByEachAnt = [ pathsChosenByEachAnt ; pathsChosen ]; %#ok
        ants(i) = Schedule(antPath, days, timeslots);
    end
    
    % Get best solution
    bestAntFitness = Inf;
    bestAntSol = 0;
    bestAntPath = 0;
    for i = 1:numAnts,
        fitness = GetFitness(ants(i), students);
        if fitness < bestAntFitness,
            bestAntFitness = fitness;
            bestAntSol = ants(i);
            bestAntPath = pathsChosenByEachAnt(1, :);
        end
    end
    
    % Update pheromones
    pheromones = updatePheromones(pheromones, bestAntPath, bestAntFitness, rho, Q);
    
    % See if best from this iteration is better than global best
    if bestAntFitness < bestFitness,
        bestSolution = bestAntSol;
        bestFitness = bestAntFitness;
    end
    
    fitnesses(iter) = bestFitness; %#ok
    solutions(iter) = bestSolution; %#ok
    
    % print the global best fitness after this iteration and update the UI
    fprintf ('iter: %d -- best fitness: %d\n', iter, bestFitness);
    set(handle.Cur_Iter_val,'String', int2str(iter));
    set(handle.Cur_Best_val,'String', int2str(bestFitness));
    drawnow;
    
    if fitnesses(iter) == 0,
        break;
    end
end

end

function [ pheromones ] = updatePheromones( pheromones, bestAntPath, bestFitness, rho, Q )

% Evaporation
pheromones = pheromones * (1 - rho);

% Add to the pheromones for the path of the best
for i = 1:length(bestAntPath)
    pheromones(i, bestAntPath(i)) = pheromones(i, bestAntPath(i)) + (Q / bestFitness);
end

end


function [ acoNode ] = generateNodePaths( course, rooms, days, timeslots )

maxTimeslot = timeslots - course.duration + 1;
paths = CourseMapping.empty((length(rooms) * days * maxTimeslot),0);

pathIter = 1;

% Create all possible solutions for the given course
for day = 1:days,
    for timeslot = 1:maxTimeslot,
        for room = rooms,
            paths(pathIter) = CourseMapping(course, room, day, timeslot);
            pathIter = pathIter + 1;
        end
    end
end

acoNode = ACONode(course, paths);

end

function [ solChosen pathsChosen] = getAntSolution( acoNodes, pheromones )

solChosen = CourseMapping.empty(length(acoNodes), 0);

% Keeps track of the index of the path that the ant took
pathsChosen = zeros(1, length(acoNodes));
for i = 1:length(acoNodes),
    
    % Get the overall value of pheromones for each path we could take
    sumTotal = sum(pheromones(i, :));
    
    % Calculate the percentages
    probabilities = pheromones(i, :) ./ sumTotal;
    for j = 2:length(probabilities),
        probabilities(j) = probabilities(j) + probabilities(j - 1);
    end
    
    % Generate random number for chosen paths
    randNum = rand;
    for j = 1:length(probabilities),
        if randNum <= probabilities(j),
            solChosen(i) = acoNodes(i).pathsToNext(j);
            pathsChosen(i) = j;
            break;
        end
    end
end

end
