classdef Teacher
    %TEACHER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        teacherID
        classesTaught
        eventsAttended
    end
    
    methods
        function teacher = Teacher(teacherID, classesTaught, eventsAttended)
           if nargin > 0
               teacher.teacherID = teacherID;
               teacher.classesTaught = classesTaught;
               teacher.eventsAttended = eventsAttended;
           end
        end
    end
    
end

