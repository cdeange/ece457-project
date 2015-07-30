classdef Particle
    % Particle A particle using in PSO
    % 
    %            schedule Schedule
    %     personalBestSol Schedule
    % personalBestFitness Number
    
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

