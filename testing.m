rand('state', 0)

[courses students rooms teachers days timeslots numFeatures] = ReadInput('feasible.csv');

% days = 5;
% timeslots = 5;
% numCourses = 5;
% numStudents = 10;
% numRooms = 2;
% numTeachers = 3;
% numEvents = 2;
% numFeatures = 0;
% [ courses students rooms teachers ] = GenerateInput(timeslots, numCourses, numStudents, numRooms, numTeachers, numEvents, numFeatures);

[ schedule ] = GenerateInitialSolution(days, timeslots, courses, students, rooms, teachers);

PrintSchedule(schedule);
PrintCoursesRooms (schedule, students);
PrintCourseMappings(students, length(courses), false);

addpath('constraints');

addpath('TabuSearch');

TabuSearch(schedule, rooms, 3, students, 100)
