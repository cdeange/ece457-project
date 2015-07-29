function [ child ] = Mutate( parent, pm, rooms )

courseCount = length(parent.courseMappings);
newMappings = CourseMapping.empty(courseCount, 0);

days = parent.days;
timeslots = parent.timeslots;
roomCount = length(rooms);

for i = 1:courseCount,
    
    % Get parent values
    mapping = parent.courseMappings(i);
    day = mapping.day;
    room = mapping.room.roomID;
    timeslot = mapping.timeSlot;
    duration = mapping.course.duration;
    
    % Mutate day/room/time if necessary, preventing timeslot overflow
    if rand < pm,
        day = randi([1, days], 1);
    end
    
    if rand < pm,
        room = randi([1, roomCount], 1);
    end
    
    if rand < pm,
        timeslot = randi([1, timeslots - duration + 1], 1);
    end
    
    % Create new mapping from (potentially) new values
    newMappings(i) = CourseMapping(mapping.course, rooms(room), day, timeslot);
end

child = Schedule(newMappings, days, timeslots);

end
