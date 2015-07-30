classdef Teacher
    % Teacher An individual who teaches classes
    %
    %     teacherID Number
    % classesTaught List(Course)
    
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

