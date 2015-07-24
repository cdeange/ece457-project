classdef Teacher
    %TEACHER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        teacherID
        classesTaught
    end
    
    methods
        function teacher = Teacher(teacherID, classesTaught)
           if nargin > 0
               teacher.teacherID = teacherID;
               teacher.classesTaught = classesTaught;
           end
        end
    end
    
end

