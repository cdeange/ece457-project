function [ oneCourseCount ] = SoftConstraintOneCourseInDay( schedule, students )
% SoftConstraintOneCourseInDay Determines the number of students who have
% only one class on any given day
%
% schedule Schedule
% students List(Student)
%
% Returns the number of times this constraint is not met

courseCount = zeros(length(students), schedule.days);

for mapping = schedule.courseMappings,
    for student = mapping.course.studentsTaking,
        courseCount(student, mapping.day) = courseCount(student, mapping.day) + 1;
    end
end

% Find cells that are equal to 1, and sum them all
% Gives the total number of times any student has 1 course in a day
oneCourseCount = sum(sum(courseCount == 1));

end
