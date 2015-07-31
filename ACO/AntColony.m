function [ bestSolution bestFitness ] = AntColony( courses, rooms, days, timeslots, numAnts, students, iterations, Khard, Ksoft, rho, handle )

    bestSolution = 0;
    bestFitness = inf;
    Q = Khard;
    
    acoNodes = ACONode.empty(length(courses), 0);
    ants = Schedule.empty(numAnts,0);
    
    %create the paths(courseMapping) for each course
    % and create the ACONode for each
    for i = 1:length(courses)
         acoNodes(i) = generateNodePaths(courses(i), rooms, days, timeslots);
    end
        
    %create pheromones matrix
    pheromones = zeros(length(acoNodes),length(rooms) * days * timeslots);
    
     for i = 1:length(acoNodes)
         for j = 1:length(acoNodes(i).pathsToNext)
             pheromones(i,j) = 1;
         end
     end
    
    
    %do aco
    %find path for each
    %until we get what we want: iteration/termination criteria
    iter = 1;
    while iter <= iterations
        pathsChosenByEachAnt = [];
        for i = 1:numAnts
            [ antPath pathsChosen ] = getAntSolution(acoNodes, pheromones); 
            pathsChosenByEachAnt = [ pathsChosenByEachAnt ; pathsChosen ]; %#ok
            ants(i) = Schedule(antPath, days, timeslots);
        end
        %get best solution
        bestAntFitness = inf;
        bestAntSol = 0;
        bestAntPath = 0;
        for i = 1:numAnts
            fitness = GetFitness(ants(i), students, Khard, Ksoft, false);
            fprintf ('Ant: %d -- fitness: %d -- best fitness: %d\n',i,fitness,bestFitness);
            if fitness < bestAntFitness
               bestAntFitness = fitness;
               bestAntSol = ants(i);
               bestAntPath = pathsChosenByEachAnt(1, :);
            end
        end

        %update pheromones
        pheromones = updatePheromones(pheromones, bestAntPath, bestAntFitness, rho, Q);
        
        %see if best from this iteration is better than global best
        if bestAntFitness < bestFitness
           bestSolution = bestAntSol;
           bestFitness = bestAntFitness;
        end
        
        set(handle.Cur_Iter_val,'String', int2str(iter));
        set(handle.Cur_Best_val,'String', int2str(bestFitness));
        drawnow;
        
        iter = iter + 1;
    end
   
end

function [ newPheromones ] = updatePheromones(pheromones, bestAntPath, bestFitness, rho, Q)
    
    %evaporation
    pheromones = pheromones * (1 - rho);
    
    %add to the pheromones for the path of the best
    for i = 1:length(bestAntPath)
        pheromones(i, bestAntPath(i)) = pheromones(i, bestAntPath(i)) + (Q/bestFitness);
    end
    newPheromones = pheromones;
end


function [ acoNode ] = generateNodePaths(course, rooms, days, timeslots)

    maxTimeslot = timeslots - course.duration + 1;
    paths = CourseMapping.empty((length(rooms) * days * maxTimeslot),0);
    
    pathIter = 1;
    
    %create all possible solutions for the given course
    for day = 1:days
       for timeslot = 1:maxTimeslot
           for room = rooms
             paths(pathIter) = CourseMapping(course, room, day, timeslot);
             pathIter = pathIter + 1;  
           end
       end
    end

    acoNode = ACONode(course, paths);

end

function [ solChosen pathsChosen] = getAntSolution(acoNodes, pheromones)

    solChosen = CourseMapping.empty(length(acoNodes),0);
    %keeps track of the index of the path that the ant took
    pathsChosen = zeros(1,length(acoNodes));
    for i = 1:length(acoNodes)
        % get the overall value of pheromones for each path we could take
        sumTotal = sum(pheromones(i,:));
        % calculate the percentages
        probabilities = pheromones(i,:) ./ sumTotal;
        for j = 2:length(probabilities)
           probabilities(j) = probabilities(j) + probabilities(j-1);
        end
        %generate random number
        randNum = rand;
        for j = 1:length(probabilities)
           if randNum <= probabilities(j)
              solChosen(i) = acoNodes(i).pathsToNext(j);
              pathsChosen(i) = j;
              break; 
           end
        end
    end
end

