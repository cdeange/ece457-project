function [ conflictCount ] = HardConstraintClassroomConflicts( conflictingCourseMappings )

conflictCount = 0;

for conflict = conflictingCourseMappings,
    if conflict{1}{1}.room.roomID == conflict{1}{2}.room.roomID,
        conflictCount = conflictCount + 1;
    end
end

end
