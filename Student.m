classdef Student
    % Student An individual who attends classes
    %
    %       studentID Number
    % enrolledCourses List(Course)
    
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

