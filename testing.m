%[courses students rooms teachers events] = GenerateInput(5,6,5,4,15,5,5,5);
[courses students rooms teachers events] = GenerateInput(5,5,1,1,1,1,1,1);
%[initialSchedule] = GenerateInitialSolution(5,6, courses, students,rooms,teachers, events);
[initialSchedule] = GenerateInitialSolution(5,5, courses, students,rooms,teachers, events);
PrintSchedule(initialSchedule);
PrintCoursesRooms (initialSchedule, students);