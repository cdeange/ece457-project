function [ newSchedule ] = GetRandomNeighbour( schedule, rooms )

days = schedule.days;
timeslots = schedule.timeslots;

randOperation = rand;

if randOperation < 0.33,
    % Swap day and timeslot

    randMapping = randsample(schedule.courseMappings, 1);
    randCourse = randMapping.course;
    day = randMapping.day;
    timeslot = randMapping.timeSlot;
    
    while day == randMapping.day || timeslot == randMapping.timeSlot,
        day = round(days * rand + 0.5);
        validTimeSlots = timeslots - randCourse.duration + 1;
        timeslot = round(validTimeSlots * rand + 0.5);
    end
    
    newMapping = CourseMapping(randCourse, randMapping.room, day, timeslot);
    newMappings = schedule.courseMappings;
    newMappings(randCourse.courseID) = newMapping;
    newSchedule = Schedule(newMappings, days, timeslots);

elseif randOperation < 0.66,
    % Swap room
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
    end
    
    newMapping1 = CourseMapping(randCourse, swapMapping.room, swapMapping.day, swapMapping.timeSlot);
    newMapping2 = CourseMapping(swapCourse, randMapping.room, randMapping.day, randMapping.timeSlot);
    newMappings = schedule.courseMappings;
    newMappings(randCourse.courseID) = newMapping1;
    newMappings(swapCourse.courseID) = newMapping2;
    newSchedule = Schedule(newMappings, days, timeslots);
    
end % if

end