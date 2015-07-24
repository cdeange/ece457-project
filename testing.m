
days = 5;
slots = 4;
numCourses = 10;
numEvents = 1;

[courses students rooms teachers] = GenerateInput(days, slots, numCourses, 10, 2, 1, numEvents, 5);
[schedule] = GenerateInitialSolution(days, slots, courses, students, rooms, teachers);

PrintSchedule(schedule);
% PrintCoursesRooms (schedule, students);
PrintCourseMappings(students, numCourses + numEvents, false);

addpath('constraints')

conflicts = GetCourseConflicts(schedule);

fprintf('Student course conflicts: %d\n', HardConstraintStudentCourseConflict(conflicts));
fprintf('Teacher course conflicts: %d\n', HardConstraintTeacherCourseConflict(conflicts));
fprintf('Classroom conflicts: %d\n', HardConstraintClassroomConflicts(conflicts));
fprintf('Classrooms overbooked: %d\n', HardConstraintClassroomCapacity(schedule, students));
fprintf('Unsatisfied classrooms: %d\n', HardConstraintClassRequirements(schedule));