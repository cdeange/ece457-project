classdef Student
    %STUDENT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        studentID
        enrolledCourses
        eventsAttended
    end
    
    methods
        function student = Student(studentID, enrolledCourses, eventsAttended)
            if nargin > 0
                student.studentID = studentID;
                student.enrolledCourses = enrolledCourses;
                student.eventsAttended = eventsAttended;
            end
        end
    end
    
end

