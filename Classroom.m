classdef Classroom
    %ROOM Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        roomID
        features
        capacity
    end
    
    methods
        function room = Classroom(roomID, features, capacity)
           if nargin > 0
              room.roomID = roomID;
              room.features = features;
              room.capacity = capacity;
           end
        end
    end
    
end

