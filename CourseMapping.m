classdef CourseMapping
    %COURSEMAPPING Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        course
        room
        day
        timeSlot
    end
    
    methods
        function coursemapping = CourseMapping(course, room, day, timeSlot)
           if nargin > 0
              coursemapping.course = course;
              coursemapping.room = room;
              coursemapping.day = day;
              coursemapping.timeSlot = timeSlot;
           end
        end
    end
    
end

