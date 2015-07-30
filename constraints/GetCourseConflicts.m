function [ conflicts ] = GetCourseConflicts( schedule )
% GetCourseConflicts Determines conflicts between courses
%
% schedule Schedule
%
% Returns the list of pairs of courses with time-based conflicts.
% Does not take rooms into account.

mappings = schedule.courseMappings;
conflicts = {};
conflictIndex = 1;

for i = 1:length(mappings),
    for j = i + 1:length(mappings),
        m1 = mappings(i);
        m2 = mappings(j);
        if m1.day ~= m2.day,
            continue;
        end
        
        if ~((m1.timeSlot > (m2.timeSlot + m2.course.duration - 1)) || ((m1.timeSlot + m1.course.duration - 1) < m2.timeSlot)),
           % Conflict detected for <day, timeslot> pair!
           conflicts{conflictIndex} = { m1, m2 }; %#ok
           conflictIndex = conflictIndex + 1;
        end
    end
end

end

