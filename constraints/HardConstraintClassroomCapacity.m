function [ numOverbookedRooms ] = HardConstraintClassroomCapacity( schedule, students )
    numOverbookedRooms = 0;
    coursemappings = [schedule.courseMappings];
    courseEnrollments = zeros(length(coursemappings),1);
    
    for i=1:length(students)
       stud = students(i);
       coursesTaken = stud.enrolledCourses;
       
       for j=1:length(coursesTaken)
          courseEnrollments(coursesTaken(j).courseID) = courseEnrollments(coursesTaken(j).courseID) + 1;
       end
    end
    
    for i = 1:length(coursemappings)
        room = coursemappings(i).room;
        roomCapacity = room.capacity;
        
        course = coursemappings(i).course;
        courseID = course.courseID;
        
        courseEnrollment = courseEnrollments(courseID);
        
        if courseEnrollment > roomCapacity
            numOverbookedRooms = numOverbookedRooms + 1;
        end
    end


end

