function [ conflictCount ] = HardConstraintStudentCourseConflict( conflictingCourseMappings )
% HardConstraintStudentCourseConflict Determines double-booked students
%
% conflictingCourseMappings List(Pair(CourseMapping, CourseMapping))
%
% Returns the number of times this constraint is not met

conflictCount = 0;

for conflict = conflictingCourseMappings,
    conflictingStudents = intersect(conflict{1}{1}.course.studentsTaking, conflict{1}{2}.course.studentsTaking);
    conflictCount = conflictCount + length(conflictingStudents);
end

end