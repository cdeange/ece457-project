function [ oneCourseCount ] = SoftConstraintOneCourseInDay( schedule, students )

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
