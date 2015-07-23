classdef Event
    %EVENT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        eventID
        teacher % teacher and student will just be ints, otherwise circular update between teacher/student and event
        student
        duration
    end
    
    methods
        function event = Event(eventID, teacher, student, duration)
           if nargin > 0
              event.eventID = eventID;
              event.teacher = teacher;
              event.student = student;
              event.duration = duration;
           end
        end
    end
    
end

