function [ fitness fitnessHard fitnessSoft ] = GetFitness( schedule, students, Khard, Ksoft, verbose )

addpath('constraints');


if nargin < 3,
    Khard = 1000000;
end
if nargin < 4,
    Ksoft = 1;
end
if nargin < 5,
    verbose = false;
end

conflicts = GetCourseConflicts(schedule);

studentConflicts   = HardConstraintStudentCourseConflict(conflicts);
teacherConflicts   = HardConstraintTeacherCourseConflict(conflicts);
classroomConflicts = HardConstraintClassroomConflicts(conflicts);
capacityIssues     = HardConstraintClassroomCapacity(schedule, students);
requirementIssues  = HardConstraintClassRequirements(schedule);

oneCoursePerDay = SoftConstraintOneCourseInDay(schedule, students);
lastTimeslot = SoftConstraintLastTimeslot(schedule);

if verbose,
    fprintf('Student course conflicts: %d\n', studentConflicts);
    fprintf('Teacher course conflicts: %d\n', teacherConflicts);
    fprintf('Classroom conflicts: %d\n', classroomConflicts);
    fprintf('Classrooms overbooked: %d\n', capacityIssues);
    fprintf('Unsatisfied classrooms: %d\n', requirementIssues);
    fprintf('One Course Per Day: %d\n', oneCoursePerDay);
    fprintf('Last Timeslot: %d\n', lastTimeslot);
end

fitnessHard = studentConflicts + teacherConflicts + classroomConflicts + capacityIssues + requirementIssues;
fitnessSoft = oneCoursePerDay + lastTimeslot;

fitnessHard = (Khard * fitnessHard);
fitnessSoft = (Ksoft * fitnessSoft);

fitness = fitnessHard + fitnessSoft;

end

