rng(0);

[courses students rooms teachers days timeslots] = ReadInput('feasible.csv');

% days = 5;
% timeslots = 5;
% numCourses = 5;
% numStudents = 10;
% numRooms = 2;
% numTeachers = 3;
% numEvents = 2;
% numFeatures = 0;
% [ courses students rooms teachers ] = GenerateInput(timeslots, numCourses, numStudents, numRooms, numTeachers, numEvents, numFeatures);

%[ schedule ] = GenerateInitialSolution(days, timeslots, courses, students, rooms, teachers);

% PrintSchedule(schedule);
% PrintCoursesRooms (schedule, students);
% PrintCourseMappings(students, length(courses), false);

addpath(strcat(pwd, '/constraints'));

addpath(strcat(pwd, '/TS'));
addpath(strcat(pwd, '/SA'));
addpath(strcat(pwd, '/GA'));
addpath(strcat(pwd, '/ACO'));
addpath(strcat(pwd, '/PSO'));


% [ bestFitness bestSolution fitnesses solutions ] = TabuSearch(schedule, rooms, 3, students, 20)
% [ bestFitness bestSolution fitnesses solutions ] = SimulatedAnnealing(schedule, rooms, students)

%ACO
% numAnts = 200;
% Khard = 1000;
% Ksoft = 1;
% rho = 0.1;
% iterations = 500;
% [bestSolution bestFitness] = AntColony(courses, rooms, days, timeslots, numAnts, students, iterations, Khard, Ksoft, rho);

%PSO
% numParticles = 50;
% iterations = 100;
% Khard = 1000000;
% Ksoft = 1;
% [ bestSolution bestFitness ] = ParticleSwarm(numParticles, days, timeslots, courses, rooms, students, iterations, Khard, Ksoft);
% 
% bestFitness

