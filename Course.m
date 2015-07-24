classdef Course
    %COURSE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        courseID
        featuresReq
        duration
        courseType
        studentsTaking
    end
    
    methods
        function course = Course(courseID, featuresReq, duration, courseType, studentsTaking)
           if nargin > 0
              course.courseID = courseID;
              course.featuresReq = featuresReq;
              course.duration = duration;
              course.courseType = courseType;
              course.studentsTaking = studentsTaking;
           end
        end
    end
    
end

