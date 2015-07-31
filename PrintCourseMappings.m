function PrintCourseMappings( students, courseCount, reverse )
% PrintCourseMappings Prints the list of courses mapped to students, or
% vice versa if specified
%
%    students List(Student)
% courseCount Number
%     reverse (optional) Logical

if nargin < 3
    reverse = false;
end

if ~reverse,
    % Print students --> courses
    for student = students,
        fprintf('Student %2d:', student.studentID);
        studentCourses = sort(arrayfun(@(c)c.courseID, student.enrolledCourses));
        for course = studentCourses,
            fprintf(' %4d', course);
        end
        fprintf('\n');
    end
else
    % Print courses --> students
    courses = zeros(1, courseCount);
    for student = students,
        for course = student.enrolledCourses,
            nonZeroIndices = find(courses(:, course.courseID));
            if isempty(nonZeroIndices),
                nextIndex = 1;
            else
                nextIndex = nonZeroIndices(end) + 1;
            end
            
            courses(nextIndex, course.courseID) = student.studentID;
        end
    end
    
    for i = 1:length(courses),
        studentsInCourse = courses(:, i);
        fprintf('Course %2d:', i);
        studentIndices = find(studentsInCourse);
        for index = studentIndices,
            fprintf(' %4d', studentsInCourse(index));
        end
        fprintf('\n');
    end
    
end

fprintf('\n');

end