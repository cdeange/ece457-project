classdef Schedule
    %SCHEDULE Summary of this class goes here
    %   Detailed explanation goes here
    
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
        
        
        %TODO: add in methods to find all courses given a day, given
        %timeslot, etc
        %TODO: methods to find conflicts, etc
        %TODO: methods to find all courses/events for a given
        %student/teacher
        %TODO: add methods for all the swaps
    end
    
end

