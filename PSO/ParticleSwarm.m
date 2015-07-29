function [ bestSolution bestFitness ] = ParticleSwarm( numParticles, numDays, numTimeSlots, courses, rooms, students, iterations, Khard, Ksoft )

    particles = Particle.empty(numParticles,0);
    
    globalBestSol = 0;
    globalBestFitness = Inf;
    
    %initialize particles
    for i = 1:numParticles
        particle = GenerateInitialSolution(numDays, numTimeSlots, courses, rooms);
        fitness = GetFitness(particle, students, Khard, Ksoft, false);
        
        particles(i) =  Particle(particle, particle, fitness);
        
        fprintf('part%d  best: %d  global: %d\n',i, fitness,globalBestFitness);
       
        if fitness < globalBestFitness
            globalBestSol = particles(i).schedule;
            globalBestFitness = fitness;
        end
    end
    
    
    
    %do while
    for i = 1:iterations
        bestPartSol = 0;
        bestPartFitness = Inf;
        for j = 1:numParticles
            %update particle
%             fprintf('\npart%d\n',j);
            particles(j) = updateParticle(particles(j), globalBestSol, globalBestFitness, rooms, numDays, numTimeSlots);
            %get new personal bests
            
            fitness = GetFitness(particles(j).schedule, students, Khard, Ksoft, false);
            
            if fitness < particles(j).personalBestFitness
                particles(j).personalBestSol = particles(j).schedule;
                particles(j).personalBestFitness = fitness;
            end
            
            if fitness < bestPartFitness
                bestPartSol = particles(j).schedule;
                bestPartFitness = fitness;
            end        
        end
        
        if bestPartFitness < globalBestFitness
            globalBestSol = bestPartSol;
            globalBestFitness = bestPartFitness;
        end  
        fprintf('iter best: %d global best: %d\n',bestPartFitness,globalBestFitness);
        
        
    end
    
    bestSolution = globalBestSol;
    bestFitness = globalBestFitness;

end

function [ newParticle ] = updateParticle(particle, globalBestSol, globalBestFitness, rooms, numDays, numTimeSlots)
%      noChange = 0.097;
%      random = 0.03;
%      takePbest = 0.3;
%      takegBest = 0.6;
    
     noChange = 0.1;
     random = 0.3;
     takePbest = 0.35;
     takegBest = 0.35;

    coursemappings = particle.schedule.courseMappings;
    
    for i = 1:length(coursemappings)
        %day
%         fprintf('\ncourse%d\n',i);
        randOp = rand;
        if randOp <= noChange
%             fprintf('no day change\n');
        elseif randOp < random
            randDay = round(numDays * rand + 0.5);
%             fprintf('randday: %d\n', randDay);
            coursemappings(i).day = randDay;
        elseif randOp <= takePbest
%             fprintf('pbest day: %d\n', particle.personalBestSol.courseMappings(i).day);
            coursemappings(i).day = particle.personalBestSol.courseMappings(i).day;
        else
%             fprintf('gbest day: %d\n', globalBestSol.courseMappings(i).day);
            coursemappings(i).day = globalBestSol.courseMappings(i).day;
        end
        
        %timeslot
        randOp = rand;
        maxTimeslot = numTimeSlots - coursemappings(i).course.duration + 1;
        
        if randOp <= noChange
%             fprintf('no ts change\n');
        elseif randOp <= random
            randTimeSlot = round(maxTimeslot * rand + 0.5);
%             fprintf('randts: %d\n', randTimeSlot);
            coursemappings(i).timeSlot = randTimeSlot;
        elseif randOp <= takePbest
%             fprintf('pbest room: %d\n', particle.personalBestSol.courseMappings(i).timeSlot);
            coursemappings(i).timeSlot = particle.personalBestSol.courseMappings(i).timeSlot;
        else
%             fprintf('gbest ts: %d\n', globalBestSol.courseMappings(i).timeSlot);
            coursemappings(i).timeSlot = globalBestSol.courseMappings(i).timeSlot;
        end
        
        %room
        randOp = rand;
        
        if randOp <= noChange
%             fprintf('no room change\n');
        elseif randOp <= random
            randRoom = randsample(rooms, 1);
%             fprintf('rand room: %d\n', randRoom.roomID);
            coursemappings(i).room = randRoom;
        elseif randOp <= takePbest
%             fprintf('pbest room: %d\n', particle.personalBestSol.courseMappings(i).room.roomID);
            coursemappings(i).room = particle.personalBestSol.courseMappings(i).room;
        else
%             fprintf('gbest room: %d\n', globalBestSol.courseMappings(i).room.roomID);
            coursemappings(i).room = globalBestSol.courseMappings(i).room;
        end
    end
    
    sched = Schedule(coursemappings, numDays, numTimeSlots);
    
    newParticle = Particle(sched, particle.personalBestSol, particle.personalBestFitness);
end

