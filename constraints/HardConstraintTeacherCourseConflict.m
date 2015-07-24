function [ conflictCount ] = HardConstraintTeacherCourseConflict( conflictingCourseMappings )
%HARDCONSTRAINTTEACHERCOURSECONFLICT Summary of this function goes here
%   Detailed explanation goes here

conflictCount = 0;

for conflict = conflictingCourseMappings,
    if conflict{1}{1}.course.teacher == conflict{1}{2}.course.teacher,
        conflictCount = conflictCount + 1;
    end
end

end