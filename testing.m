
[courses students rooms teachers days timeslots numFeatures] = ReadInput('input.csv');
[schedule] = GenerateInitialSolution(days, timeslots, courses, students, rooms, teachers);

PrintSchedule(schedule);
PrintCoursesRooms (schedule, students);
PrintCourseMappings(students, length(courses), false);

fitness = GetFitness(schedule, students)
