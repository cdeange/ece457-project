classdef Schedule
    % Schedule A container for course mappings; typically this is a
    % solution for a given adaptive algorithm
    %
    % courseMappings List(CourseMapping)
    %           days Number
    %      timeslots Number
    
    properties
        courseMappings
        days
        timeslots
    end
    
    methods
        function schedule = Schedule(courseMappings, days, timeslots)
            if nargin > 0
                schedule.courseMappings = courseMappings;
                schedule.days = days;
                schedule.timeslots = timeslots;
            end
        end
    end
    
end

