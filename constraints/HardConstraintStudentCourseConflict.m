function [ conflictCount ] = HardConstraintStudentCourseConflict( conflictingCourseMappings )
%HARDCONSTRAINTSTUDENTCOURSECONFLICT Summary of this function goes here
%   Detailed explanation goes here

conflictCount = 0;

for conflict = conflictingCourseMappings,
    conflictingStudents = intersect(conflict{1}{1}.course.studentsTaking, conflict{1}{2}.course.studentsTaking);
    conflictCount = conflictCount + length(conflictingStudents);
end

end