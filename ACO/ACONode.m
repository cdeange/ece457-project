classdef ACONode    
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

