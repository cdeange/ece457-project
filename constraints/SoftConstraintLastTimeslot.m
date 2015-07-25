function [ lastSlotCount ] = SoftConstraintLastTimeslot( schedule )
    lastSlotCount = 0;
    
    coursemappings = schedule.courseMappings;
    
    for i = 1:length(coursemappings)
        timeslot = coursemappings(i).timeSlot;
        course = coursemappings(i).course;
        duration = course.duration;
        
        if (timeslot + duration - 1) == schedule.timeslots
            lastSlotCount = lastSlotCount + length(course.studentsTaking);
        end
    end

end

