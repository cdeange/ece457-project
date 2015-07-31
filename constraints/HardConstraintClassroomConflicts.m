function [ conflictCount ] = HardConstraintClassroomConflicts( conflictingCourseMappings )
% HardConstraintClassroomConflicts Determines double-booked rooms
%
% conflictingCourseMappings List(Pair(CourseMapping, CourseMapping))
%
% Returns the number of times this constraint is not met

conflictCount = 0;

for conflict = conflictingCourseMappings,
    if conflict{1}{1}.room.roomID == conflict{1}{2}.room.roomID,
        conflictCount = conflictCount + 1;
    end
end

end
