function PrintCoursesRooms( schedule, students )
%PRINTCOURSESROOMS Summary of this function goes here
%   Detailed explanation goes here

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
    if isempty(features) ~= 1
        featureIDs = zeros(length(features),1);
        for i = 1:length(features)
            featureIDs(i) = features(i).featureID;
        end
        featureIDs = sort(featureIDs);
        str = sprintf('%d', featureIDs(1));
        for i = 2:length(features)
           str = strcat(str, sprintf(',%d', featureIDs(i))) ;
        end        
    else
        str = '';
    end
    
    featuresreqs = str;
    

end
