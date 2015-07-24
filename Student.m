classdef Student
    %STUDENT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        studentID
        enrolledCourses
    end
    
    methods
        function student = Student(studentID, enrolledCourses)
            if nargin > 0
                student.studentID = studentID;
                student.enrolledCourses = enrolledCourses;
            end
        end
    end
    
end

