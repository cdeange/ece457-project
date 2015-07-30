function [ numOverbookedRooms ] = HardConstraintClassroomCapacity( schedule, students )
% HardConstraintClassroomCapacity Determines overbooked classrooms
%
% schedule Schedule
% students List(Student)
%
% Returns the number of times this constraint is not met

numOverbookedRooms = 0;
coursemappings = [ schedule.courseMappings ];
courseEnrollments = zeros(length(coursemappings), 1);

for i = 1:length(students),
   student = students(i);
   coursesTaken = student.enrolledCourses;

   for j = 1:length(coursesTaken),
      courseEnrollments(coursesTaken(j).courseID) = courseEnrollments(coursesTaken(j).courseID) + 1;
   end
end

for i = 1:length(coursemappings),
    room = coursemappings(i).room;
    roomCapacity = room.capacity;

    courseID = coursemappings(i).course.courseID;

    courseEnrollment = courseEnrollments(courseID);

    if courseEnrollment > roomCapacity,
        numOverbookedRooms = numOverbookedRooms + 1;
    end
end

end

