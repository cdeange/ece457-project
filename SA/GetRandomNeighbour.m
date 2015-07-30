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
    exit = false;
    randCourseIDs = randperm(length(schedule.courseMappings));
    swapCourseIDs = randperm(length(schedule.courseMappings));
    
    % Look at all random possible combinations of unique courses to swap
    for courseID = randCourseIDs,
        for swapID = swapCourseIDs,
            if courseID == swapID,
                % Same course
                continue;
            end
            
            mapping1 = schedule.courseMappings(courseID);
            mapping2 = schedule.courseMappings(swapID);
            
            newEndSlot1 = mapping1.timeSlot + mapping2.course.duration - 1;
            newEndSlot2 = mapping2.timeSlot + mapping1.course.duration - 1;
            
            if newEndSlot1 <= schedule.timeslots && newEndSlot2 <= schedule.timeslots,
                % Found two different courses that can be safely swapped
                randMapping = mapping1;
                randCourse = randMapping.course;
                swapMapping = mapping2;
                swapCourse = swapMapping.course;
                
                exit = true;
                break;
            end
        end
        
        if exit,
            break;
        end
    end
    
    if ~exit,
        % Solution was not found, we could not swap ANY two courses safely.
        % Highly unlikely, but still possible! Return the original schedule.
        newSchedule = schedule;
        return;
    end
    
    newMapping1 = CourseMapping(randCourse, swapMapping.room, swapMapping.day, swapMapping.timeSlot);
    newMapping2 = CourseMapping(swapCourse, randMapping.room, randMapping.day, randMapping.timeSlot);
    newMappings = schedule.courseMappings;
    newMappings(randCourse.courseID) = newMapping1;
    newMappings(swapCourse.courseID) = newMapping2;
    newSchedule = Schedule(newMappings, days, timeslots);
    
end

end