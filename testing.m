

[courses students rooms teachers days timeslots numFeatures] = ReadInput('input.csv');
[schedule] = GenerateInitialSolution(days, timeslots, courses, students, rooms, teachers);

PrintSchedule(schedule);
PrintCoursesRooms (schedule, students);
PrintCourseMappings(students, length(courses), false);

addpath('constraints')


conflicts = GetCourseConflicts(schedule);

fprintf('Student course conflicts: %d\n', HardConstraintStudentCourseConflict(conflicts));
fprintf('Teacher course conflicts: %d\n', HardConstraintTeacherCourseConflict(conflicts));
fprintf('Classroom conflicts: %d\n', HardConstraintClassroomConflicts(conflicts));
fprintf('Classrooms overbooked: %d\n', HardConstraintClassroomCapacity(schedule, students));
fprintf('Unsatisfied classrooms: %d\n', HardConstraintClassRequirements(schedule));

fprintf('One Course Per Day: %d\n', SoftConstraintOneCourseInDay(schedule, students));