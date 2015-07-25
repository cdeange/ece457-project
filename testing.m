rand('state',0)

[courses students rooms teachers days timeslots numFeatures] = ReadInput('input.csv');
[schedule] = GenerateInitialSolution(days, timeslots, courses, students, rooms, teachers);

PrintSchedule(schedule);
PrintCoursesRooms (schedule, students);
PrintCourseMappings(students, length(courses), false);

fitness = GetFitness(schedule, students, 1000000, 1, true)

addpath('TabuSearch');
TabuSearch( schedule, rooms, 3, students )
