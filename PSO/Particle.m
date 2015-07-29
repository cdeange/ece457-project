classdef Particle
    
    properties
        schedule
        personalBestSol
        personalBestFitness
    end
    
    methods
        function particle = Particle(schedule, personalBestSol, personalBestFitness)
            if nargin > 0
                particle.schedule = schedule;
                particle.personalBestSol = personalBestSol;
                particle.personalBestFitness = personalBestFitness;
            end
        end
    end
    
end

