classdef CourseMapping
    % CourseMapping Defines the relationship between a course and its
    %
    % room/date/time
    %   course Course
    %     room Classroom
    %      day Number
    % timeSlot Number
    
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

