classdef EventMapping
    %EVENTMAPPING Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        event
        room
        day
        timeSlot
    end
    
    methods
        function eventmapping = EventMapping(event, room, day, timeSlot)
           if nargin > 0
              eventmapping.event = event;
              eventmapping.room = room;
              eventmapping.day = day;
              eventmapping.timeSlot = timeSlot;
           end
        end
    end
    
end

