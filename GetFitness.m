function [ fitness fitnessHard fitnessSoft ] = GetFitness( schedule, students, verbose )
% GetFitness Calculates the fitness of a given solution
%
% schedule Schedule
% students List(Student)
%  verbose (optional) Logical
%
% Returns total, hard, and soft fitnesses of the solution

if nargin < 3,
    verbose = false;
end

Ksoft = GetKSoft();
Khard = GetKHard(length(schedule.courseMappings), schedule.days, length(students));

conflicts = GetCourseConflicts(schedule);

% Hard constraints
studentConflicts   = HardConstraintStudentCourseConflict(conflicts);
teacherConflicts   = HardConstraintTeacherCourseConflict(conflicts);
classroomConflicts = HardConstraintClassroomConflicts(conflicts);
capacityIssues     = HardConstraintClassroomCapacity(schedule, students);
requirementIssues  = HardConstraintClassRequirements(schedule);

% Soft constraints
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

% Scale constraints by Khard and Ksoft
fitnessHard = studentConflicts + teacherConflicts + classroomConflicts + capacityIssues + requirementIssues;
fitnessSoft = oneCoursePerDay + lastTimeslot;

fitnessHard = (Khard * fitnessHard);
fitnessSoft = (Ksoft * fitnessSoft);

fitness = fitnessHard + fitnessSoft;

end
