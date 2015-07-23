classdef Course
    %COURSE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        courseID
        featuresReq
        duration
    end
    
    methods
        function course = Course(courseID, featuresReq, duration)
           if nargin > 0
              course.courseID = courseID;
              course.featuresReq = featuresReq;
              course.duration = duration;
           end
        end
    end
    
end

