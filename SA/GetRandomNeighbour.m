function [ newSchedule ] = GetRandomNeighbour( schedule, rooms )
% GetRandomNeighbour Returns a random neighbour of a schedule solution.
%
% schedule Schedule
%    rooms List(Classroom)
%
% Returns a new, slightly-changed Schedule

days = schedule.days;
timeslots = schedule.timeslots;

randOperation = rand;

if randOperation < 1/3,
    % Change day and/or timeslot
    randMapping = randsample(schedule.courseMappings, 1);
    randCourse = randMapping.course;
    day = randMapping.day;
    timeslot = randMapping.timeSlot;
    
    % Make sure at least one of <room, day> is different from before
    while day == randMapping.day && timeslot == randMapping.timeSlot,
        day = randi([1, days], 1);
        validTimeSlots = timeslots - randCourse.duration + 1;
        timeslot = randi([1, validTimeSlots], 1);
    end
    
    newMapping = CourseMapping(randCourse, randMapping.room, day, timeslot);
    newMappings = schedule.courseMappings;
    newMappings(randCourse.courseID) = newMapping;
    newSchedule = Schedule(newMappings, days, timeslots);
    
elseif randOperation < 2/3,
    % Change room
    randMapping = randsample(schedule.courseMappings, 1);
    randCourse = randMapping.course;
    room = randMapping.room;
    
    while room.roomID == randMapping.room.roomID,
        room = randsample(rooms, 1);
    end
    
    newMapping = CourseMapping(randCourse, room, randMapping.day, randMapping.timeSlot);
    newMappings = schedule.courseMappings;
    newMappings(randCourse.courseID) = newMapping;
    newSchedule = Schedule(newMappings, days, timeslots);
    
else
    % Swap two courses
    i = 1;
    while true,
        randMapping = randsample(schedule.courseMappings, 1);
        randCourse = randMapping.course;
        swapMapping = randsample(schedule.courseMappings, 1);
        swapCourse = swapMapping.course;
        
        if swapCourse.courseID ~= randCourse.courseID,
            newEndSlot1 = randMapping.timeSlot + swapMapping.course.duration;
            newEndSlot2 = swapMapping.timeSlot + randMapping.course.duration;
            
            if newEndSlot1 <= schedule.timeslots && newEndSlot2 <= schedule.timeslots,
                % Found two different courses that can be safely swapped
                break
            end
        end
        
        i = i + 1;
        if i >= 5000
            % It is unlikely any two courses can be swapped :(
            newSchedule = schedule;
            return
        end
    end
    
    newMapping1 = CourseMapping(randCourse, swapMapping.room, swapMapping.day, swapMapping.timeSlot);
    newMapping2 = CourseMapping(swapCourse, randMapping.room, randMapping.day, randMapping.timeSlot);
    newMappings = schedule.courseMappings;
    newMappings(randCourse.courseID) = newMapping1;
    newMappings(swapCourse.courseID) = newMapping2;
    newSchedule = Schedule(newMappings, days, timeslots);
    
end

end