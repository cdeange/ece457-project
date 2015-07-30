function [ conflictCount ] = HardConstraintTeacherCourseConflict( conflictingCourseMappings )
% HardConstraintTeacherCourseConflict Determines double-booked teachers
%
% conflictingCourseMappings List(Pair(CourseMapping, CourseMapping))
%
% Returns the number of times this constraint is not met

conflictCount = 0;

for conflict = conflictingCourseMappings,
    if conflict{1}{1}.course.teacher == conflict{1}{2}.course.teacher,
        conflictCount = conflictCount + 1;
    end
end

end