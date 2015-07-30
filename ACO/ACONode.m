classdef ACONode
    % ACONode A single node for Ant Colony Optimization
    %
    %      course Course
    % pathsToNext List(CourseMapping)
    
    properties
        course
        pathsToNext
    end
    
    methods
         function aconode = ACONode(course, pathsToNext)
           if nargin > 0
              aconode.course = course; 
              aconode.pathsToNext = pathsToNext;
           end
        end
    end
    
end

