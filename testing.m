rng(0);

USE_FEASIBLE = false;

if USE_FEASIBLE,
    [courses students rooms teachers days timeslots] = ReadInput('feasible.csv');
else
    days = 10;
    timeslots = 10;
    numCourses = 30;
    numStudents = 30;
    numRooms = 4;
    numTeachers = 25;
    numEvents = 5;
    numFeatures = 0;
    [ courses students rooms teachers ] = GenerateInput(timeslots, numCourses, numStudents, numRooms, numTeachers, numEvents, numFeatures);
end


[ schedule ] = GenerateInitialSolution(days, timeslots, courses, rooms);


PrintSchedule(schedule);
PrintCoursesRooms (schedule, students);
PrintCourseMappings(students, length(courses), false);

addpath(strcat(pwd, '/constraints'));
addpath(strcat(pwd, '/GUI'));

addpath(strcat(pwd, '/TS'));
addpath(strcat(pwd, '/SA'));
addpath(strcat(pwd, '/GA'));
addpath(strcat(pwd, '/ACO'));
addpath(strcat(pwd, '/PSO'));
addpath(strcat(pwd, '/BA'));

% [ bestFitness bestSolution fitnesses solutions ] = TabuSearch(schedule, rooms, 3, students, 20)
% [ bestFitness bestSolution fitnesses solutions ] = SimulatedAnnealing(schedule, rooms, students)
% [ bestFitness bestSolution fitnesses solutions ] = Genetic(courses, students, rooms, days, timeslots);

[ bestFitness bestSolution fitnesses solutions ] = BatAlgorithm(days, timeslots, courses, rooms, students)