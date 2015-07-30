function [ bestSolution bestFitness ] = ParticleSwarm( numParticles, numDays, numTimeSlots, courses, rooms, students, iterations, Khard, Ksoft )
% ParticleSwarm Algorithm to find best schedule
%
%  numParticles Number
%       numDays Number
%  numTimeSlots Number
%    courses List(Course)
%      rooms List(Classroom)
%   students List(Student)
% iterations Number
%      Khard Number
%      Ksoft Number
%
% Returns the best fitness and solutions for the inputs

particles = Particle.empty(numParticles, 0);

globalBestSol = 0;
globalBestFitness = Inf;

% Initialize particles
for i = 1:numParticles,
    particle = GenerateInitialSolution(numDays, numTimeSlots, courses, rooms);
    fitness = GetFitness(particle, students, Khard, Ksoft, false);
    
    particles(i) =  Particle(particle, particle, fitness);
    
    fprintf('part%d  best: %d  global: %d\n',i, fitness,globalBestFitness);
    
    if fitness < globalBestFitness
        globalBestSol = particles(i).schedule;
        globalBestFitness = fitness;
    end
end

for i = 1:iterations,
    bestPartSol = 0;
    bestPartFitness = Inf;
    for j = 1:numParticles,
        % Update particle
        particles(j) = updateParticle(particles(j), globalBestSol, globalBestFitness, rooms, numDays, numTimeSlots);
        % Get new personal bests
        
        fitness = GetFitness(particles(j).schedule, students, Khard, Ksoft, false);
        
        if fitness < particles(j).personalBestFitness,
            particles(j).personalBestSol = particles(j).schedule;
            particles(j).personalBestFitness = fitness;
        end
        
        if fitness < bestPartFitness,
            bestPartSol = particles(j).schedule;
            bestPartFitness = fitness;
        end
    end
    
    if bestPartFitness < globalBestFitness,
        globalBestSol = bestPartSol;
        globalBestFitness = bestPartFitness;
    end
    fprintf('iter best: %d global best: %d\n', bestPartFitness, globalBestFitness);
    
end

bestSolution = globalBestSol;
bestFitness = globalBestFitness;

end


function [ newParticle ] = updateParticle(particle, globalBestSol, globalBestFitness, rooms, numDays, numTimeSlots)

noChange  = 0.1;
random    = 0.2  + noChange;
takePbest = 0.35 + random;
takegBest = 0.35 + takePbest; %#ok unused since this is the 'else' case

coursemappings = particle.schedule.courseMappings;

for i = 1:length(coursemappings),
    
    % Day
    randOp = rand;
    
    if randOp <= noChange,
        % No day change
    elseif randOp <= random,
        randDay = randi([1, numDays], 1);
        coursemappings(i).day = randDay;
    elseif randOp <= takePbest,
        coursemappings(i).day = particle.personalBestSol.courseMappings(i).day;
    else
        coursemappings(i).day = globalBestSol.courseMappings(i).day;
    end
    
    % Timeslot
    randOp = rand;
    maxTimeslot = numTimeSlots - coursemappings(i).course.duration + 1;
    
    if randOp <= noChange,
        % No timeslot change
    elseif randOp <= random,
        randTimeSlot = randi([1, maxTimeslot], 1);
        coursemappings(i).timeSlot = randTimeSlot;
    elseif randOp <= takePbest,
        coursemappings(i).timeSlot = particle.personalBestSol.courseMappings(i).timeSlot;
    else
        coursemappings(i).timeSlot = globalBestSol.courseMappings(i).timeSlot;
    end
    
    % Room
    randOp = rand;
    
    if randOp <= noChange,
        % No room change
    elseif randOp <= random,
        randRoom = randsample(rooms, 1);
        coursemappings(i).room = randRoom;
    elseif randOp <= takePbest,
        coursemappings(i).room = particle.personalBestSol.courseMappings(i).room;
    else
        coursemappings(i).room = globalBestSol.courseMappings(i).room;
    end
    
end

newSchedule = Schedule(coursemappings, numDays, numTimeSlots);
newParticle = Particle(newSchedule, particle.personalBestSol, particle.personalBestFitness);

end
