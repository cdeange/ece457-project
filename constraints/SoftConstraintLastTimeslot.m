function [ lastSlotCount ] = SoftConstraintLastTimeslot( schedule )
% SoftConstraintLastTimeslot Determines the number of students who are
% booked for a class in the last available timeslot.
%
% schedule Schedule
%
% Returns the number of times this constraint is not met

lastSlotCount = 0;

for mapping = schedule.courseMappings,
    timeslot = mapping.timeSlot;
    course = mapping.course;
    duration = course.duration;
    
    if (timeslot + duration - 1) == schedule.timeslots,
        lastSlotCount = lastSlotCount + length(course.studentsTaking);
    end
end

end
