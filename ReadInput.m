function [ Courses Students Rooms Teachers numDays numTimeslots ] = ReadInput( file )
global lines;

% Read all the values into a cell array, one entry per line
f = fopen(file);
lines = textscan(f, '%s', 'Delimiter','\n', 'CommentStyle', '#');
lines = transpose(lines{1});
fclose(f);


counts       = GetLine(1);
numDays      = counts(1);
numTimeslots = counts(2);
numCourses   = counts(3);
numStudents  = counts(4);
numRooms     = counts(5);
numTeachers  = counts(6);
numEvents    = counts(7);

offsetRooms    = 2;
offsetTeachers = offsetRooms + numRooms;
offsetCourses  = offsetTeachers + numTeachers;
offsetEvents   = offsetCourses + numCourses;
offsetStudents = offsetEvents + numEvents;

Courses = Course.empty(numCourses + numEvents, 0);
Students = Student.empty(numStudents, 0);
Rooms = Classroom.empty(numRooms, 0);
Teachers = Teacher.empty(numTeachers, 0);


for i = 1:numRooms
   Rooms(i) = createRoom(offsetRooms - 1, i); 
end

for i = 1:numCourses
   Courses(i) = createCourse(offsetCourses - 1, i); 
end

for i = 1:numTeachers
   [ Teachers(i) Courses ] = createTeacher(offsetTeachers - 1, i, Courses);
end

for i = 1:numStudents
   [ Students(i) Courses ] = createStudent(offsetStudents - 1, i, Courses); 
end

for i = 1:numEvents
   [ Courses(numCourses + i) Students Teachers ] = ...
       createEvent(offsetEvents - 1, i, numCourses, Students, Teachers); 
end

end


function [ classroom ] = createRoom( offset, i )
line = GetLine(offset + i);
capacity = line(2);
features = line(3:end);

classroom = Classroom(i, features, capacity);
end


function [ course ] = createCourse(offset, i)
courseLine = GetLine(offset + i);
duration = courseLine(2);
features = courseLine(3:end);

course = Course(i, features, duration, 'C', 0, []);
end


function [ teacher courses ] = createTeacher( offset, i, courses )
line = GetLine(offset + i);
classesTaught = line(2:end);
classesTaught = courses(classesTaught);

for course = classesTaught,
    courses(course.courseID).teacher = i;
end

teacher = Teacher(i, classesTaught);
end


function [ student courses ] = createStudent( offset, i, courses )
line = GetLine(offset + i);
classesEnrolled = line(2:end);
classesEnrolled = courses(classesEnrolled);

for course = classesEnrolled,
    courses(course.courseID).studentsTaking = [ courses(course.courseID).studentsTaking, i ];
end

student = Student(i, classesEnrolled);
end


function [ event students teachers ] = createEvent( offset, i, offsetID, students, teachers )
eventLine = GetLine(offset + i);
duration = eventLine(2);
teacherID = eventLine(3);
studentID = eventLine(4);

event = Course(offsetID + i, [], duration, 'M', teacherID, studentID);

students(studentID).enrolledCourses = [ students(studentID).enrolledCourses, event ];
teachers(teacherID).classesTaught = [ teachers(teacherID).classesTaught, event ];
end


function [ values ] = GetLine ( index )
global lines;

split = textscan(lines{index}, '%f', 'Delimiter', ',');
values = transpose(split{1});
values = values(~isnan(values));

end
