function [ initialSchedule ] = GenerateInitialSolution( numDays, numTimeSlots, courses, students, rooms, teachers, events )
%GENERATEINITIALSOLUTION Summary of this function goes here
%   Detailed explanation goes here
% [initialSchedule] = GenerateInitialSolution(5,6, courses, students,
% rooms,teachers, events)
% create and return schedule with the inputs given
    
    numCourses = length(courses);
    numEvents = length(events);
    coursemappings = CourseMapping.empty(numCourses,0);
    eventmappings = EventMapping.empty(numEvents,0);
    
    %TODO assign random values for rooms, etc, and also check the
    %durations/timeslots make sense
    for i=1:length(courses)
        %random room, day, timeslot (from 1 to numTimeslots-duration)
        randRoom = randsample(rooms, 1);
        randDay = round(numDays * rand + 0.5);
        validTimeSlots = numTimeSlots - courses(i).duration + 1;
        randTimeSlot = round(validTimeSlots * rand + 0.5);
    
        coursemappings(i) = CourseMapping(courses(i), randRoom, randDay, randTimeSlot);
    end
    
    for i=1:length(events)
        %random room, day, timeslot (from 1 to numTimeslots-duration)
        randRoom = randsample(rooms, 1);
        randDay = round(numDays * rand + 0.5);
        validTimeSlots = numTimeSlots - events(i).duration + 1;
        randTimeSlot = round(validTimeSlots * rand + 0.5);
        
        eventmappings(i) = EventMapping(events(i), randRoom, randDay, randTimeSlot);
    end
    
    initialSchedule = Schedule(coursemappings, eventmappings, numDays, numTimeSlots);

end

