function PrintCoursesRooms( schedule, students )
    % PrintCoursesRoomns Prints info about courses and the rooms they're in
    %
    % schedule Schedule
    % students List(Student)

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
       course = coursemappings(i).course;
       room = coursemappings(i).room;
       
       courseID = course.courseID;
       courseEnrollment = courseEnrollments(courseID);
       courseReq = course.featuresReq;
       
       roomID = room.roomID;
       roomCapacity = room.capacity;
       roomFeatures = room.features;
       
       courseReqStr = getStringFeatures(courseReq);
       roomFeaturesStr = getStringFeatures(roomFeatures);
       
       outputstring1 = sprintf ('C:%2d En:%2d Rq:%10s', courseID, courseEnrollment, courseReqStr);
       outputstring2 = sprintf ('R:%2d Cp:%2d Ft:%10s', roomID, roomCapacity, roomFeaturesStr);
       
       fprintf('%s\n%s\n\n',outputstring1,outputstring2);
       
    end

end

function [featuresreqs] = getStringFeatures( features )
    featuresreqs = '';
    if isempty(features) ~= 1
        features = sort(features);
        featuresreqs = sprintf('%d', features(1));
        for i = 2:length(features)
           featuresreqs = strcat(featuresreqs, sprintf(',%d', features(i)));
        end
    end
end
