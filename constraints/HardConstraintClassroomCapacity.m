function [ numOverbookedRooms ] = HardConstraintClassroomCapacity( schedule, students )
% HardConstraintClassroomCapacity Determines overbooked classrooms
%
% schedule Schedule
% students List(Student)
%
% Returns the number of times this constraint is not met

numOverbookedRooms = 0;
courseEnrollments = zeros(length(schedule.courseMappings), 1);

for student = students,
    for course = student.enrolledCourses,
        courseEnrollments(course.courseID) = courseEnrollments(course.courseID) + 1;
    end
end

for mapping = schedule.courseMappings,
    roomCapacity = mapping.room.capacity;
    courseEnrollment = courseEnrollments(mapping.course.courseID);
    
    if courseEnrollment > roomCapacity,
        % Too many students for this room
        numOverbookedRooms = numOverbookedRooms + 1;
    end
end

end

