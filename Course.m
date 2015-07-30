classdef Course
    % Course A single course that students take and teachers teach
    %
    %       courseID Number
    %    featuresReq List(Number)
    %       duration Number
    %     courseType 'M' or 'C'
    %        teacher Number
    % studentsTaking List(Number)
    
    properties
        courseID
        featuresReq
        duration
        courseType
        teacher
        studentsTaking
    end
    
    methods
        function course = Course(courseID, featuresReq, duration, courseType, teacher, studentsTaking)
            if nargin > 0
                course.courseID = courseID;
                course.featuresReq = featuresReq;
                course.duration = duration;
                course.courseType = courseType;
                course.teacher = teacher;
                course.studentsTaking = studentsTaking;
            end
        end
    end
    
end

