function [ initialSchedule ] = GenerateInitialSolution( numDays, numTimeSlots, courses, rooms )
% GenerateInitialSolution Create a random solution for a given course list
%
%      numDays Number
% numTimeSlots Number
%      courses List(Course)
%        rooms List(Classroom)
%
% Returns a schedule with the randomly-generated course mappings

numCourses = length(courses);
coursemappings = CourseMapping.empty(numCourses,0);

for i = 1:numCourses
    % Random room, day, valid timeslot (from 1 to numTimeSlots - duration)
    randRoom = randsample(rooms, 1);
    randDay = randi([1, numDays], 1);
    validTimeSlots = numTimeSlots - courses(i).duration + 1;
    randTimeSlot = randi([1, validTimeSlots], 1);
    
    coursemappings(i) = CourseMapping(courses(i), randRoom, randDay, randTimeSlot);
end

initialSchedule = Schedule(coursemappings, numDays, numTimeSlots);

end
