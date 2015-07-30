classdef Classroom
    % Classroom Represents a room that a course/event can be taken in
    %
    %   roomID Number
    % features List(Number)
    % capacity Number
    
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

