function [Courses Students Rooms Teachers] = GenerateInput( numTimeSlots, numCourses, numStudents, numRooms, numTeachers, numEvents, numFeatures )
% GenerateInput Creates a random mapping of courses/events to students
% and teachers, and random rooms
%
%    numTimeSlots Number
%      numCourses Number
%     numStudents Number
%     numTeachers Number
%       numEvents Number
%     numFeatures Number
%
% Returns randomly-made courses, students, rooms, and teachers

Courses = Course.empty(numCourses + numEvents,0);
Students = Student.empty(numStudents,0);
Rooms = Classroom.empty(numRooms,0);
Teachers = Teacher.empty(numTeachers,0);
Features = 1:numFeatures;

for i = 1:numRooms
    Rooms(i) = createRandRoom(i, numStudents, Features);
end

for i = 1:numTeachers
    % We will fill in the teacher's course list later
    Teachers(i) = Teacher(i, []);
end

for i = 1:numCourses
    [ Courses(i) Teachers ] = createRandCourse(i, numTimeSlots, Features, Teachers);
end

for i = 1:numStudents
    [ Students(i) Courses ] = createRandStudent(i, Courses);
end

for i = (numCourses + 1):(numCourses + numEvents)
    [ Courses(i) Students Teachers ] = createRandEvent(i, Students, Teachers, numTimeSlots);
end

end


function [ randClassroom ] = createRandRoom( i, numStudents, Features )
% Creates a room with a random features and capacity
if isempty(Features),
    randFeatures = [];
else
    randNumFeatures = randi([0, length(Features)], 1);
    randFeatures = randsample(Features, randNumFeatures);
end

randCapacity = randi([1, numStudents], 1);
randClassroom = Classroom(i, randFeatures, randCapacity);
end


function [ randCourse Teachers ] = createRandCourse( i, numTimeSlots, Features, Teachers )
% Creates a course with random features, duration, and teacher
if isempty(Features),
    randFeatures = [];
else
    randNumFeatures = randi([0, length(Features)], 1);
    randFeatures = randsample(Features, randNumFeatures);
end

randDuration = randi([1, numTimeSlots], 1);
randTeacher = randi([1, length(Teachers)], 1);
randCourse = Course(i, randFeatures, randDuration, 'C', randTeacher, []);

Teachers(randTeacher).classesTaught = [Teachers(randTeacher).classesTaught, randCourse];
end


function [ randStudent Courses ] = createRandStudent( i, Courses )
% Create a student taking a random number of courses
randNumCourses = randi([1, ceil(length(Courses) / 2)], 1);
randCourses = randsample(Courses, randNumCourses);

for j = 1:length(randCourses)
    courseID = randCourses(j).courseID;
    Courses(courseID).studentsTaking = [Courses(courseID).studentsTaking, i];
end

randStudent = Student(i, randCourses);
end


function [ randEventCourse Students Teachers ] = createRandEvent( i, Students, Teachers, numTimeSlots )
% Create an event with a random student, teacher, and duration
randStudent = randi([1, length(Students)], 1);
randTeacher = randi([1, length(Teachers)], 1);
randDuration = randi([1, numTimeSlots], 1);

randEventCourse = Course(i, [], randDuration, 'E', randTeacher, randStudent);

Students(randStudent).enrolledCourses = [Students(randStudent).enrolledCourses, randEventCourse];
Teachers(randTeacher).classesTaught = [Teachers(randTeacher).classesTaught, randEventCourse];
end
