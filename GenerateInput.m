function [Courses Students Rooms Teachers] = GenerateInput( numDays, numTimeSlots, numCourses, numStudents, numRooms, numTeachers, numEvents, numFeatures )
    %GENERATEINPUT Summary of this function goes here
    %   Detailed explanation goes here
    % e.g. [courses students rooms teachers events] = GenerateInput(5,6,5,4,15,5,5,5)
    %TODO: actually assign stuff to them (reqs, enrollment, etc)
    
    Features = RoomFeature.empty(numFeatures, 0);
    Courses = Course.empty(numCourses + numEvents,0);
    Students = Student.empty(numStudents,0);
    Rooms = Classroom.empty(numRooms,0);
    Teachers = Teacher.empty(numTeachers,0);
        
    for i = 1:numFeatures
       Features(i) = RoomFeature(i);
    end
    
    for i = 1:numRooms
       Rooms(i) = createRandRoom(i, numStudents, Features); 
    end
    
    for i = 1:numTeachers
        %do empty for both, do courses taught when creating courses 
       Teachers(i) = Teacher(i, []); 
    end
    
    for i = 1:numCourses
       [Courses(i) Teachers] = createRandCourse(i, numTimeSlots, Features, Teachers); 
    end
    
    for i = 1:numStudents
       [Students(i) Courses] = createRandStudent(i, Courses); 
    end
    
    for i = numCourses + 1:numCourses + numEvents
       [Courses(i) Students Teachers] = createRandEvent(i, Students, Teachers, numTimeSlots); 
    end
    
    
end

%random features and capacity
function [randClassroom] = createRandRoom(i, numStudents, Features)
    randNumFeatures = round(length(Features)*rand);
    randFeatures = randsample(Features,randNumFeatures);
    randCapacity = round(numStudents*rand + 0.5);
    randClassroom = Classroom(i, randFeatures, randCapacity);
end

%random features and duration
function [randCourse newTeachers] = createRandCourse(i, numTimeSlots, Features, Teachers)
    randNumFeatures = round(length(Features)*rand);
    randFeatures = randsample(Features,randNumFeatures);
    randDuration = round(numTimeSlots*rand + 0.5);
    
    randCourse = Course(i, randFeatures, randDuration,'C',[]);
    
    randTeacher = round(length(Teachers) * rand + 0.5);
    Teachers(randTeacher).classesTaught = [Teachers(randTeacher).classesTaught, randCourse];
    
    newTeachers = Teachers;
end

%random courses taken and empty events(add in when creating events)
function [randStudent Courses] = createRandStudent(i, Courses)
    randNumCourses = round((length(Courses)/2) * rand + 0.5);
    randCourses = randsample(Courses, randNumCourses);
    
    for j=1:length(randCourses)
       courseID = randCourses(j).courseID;
       Courses(courseID).studentsTaking = [Courses(courseID).studentsTaking, i];
    end
    
    randStudent = Student(i, randCourses);
end

%pick random teacher, student duration
function [randEventCourse newStudents newTeachers] = createRandEvent(i, Students, Teachers, numTimeSlots)
    randStudent = round(length(Students) * rand + 0.5);
    randTeacher = round(length(Teachers) * rand + 0.5);
    randDuration = round(numTimeSlots * rand + 0.5);
  
    randEventCourse = Course(i, [], randDuration, 'M', randStudent);
    
    Students(randStudent).enrolledCourses = [Students(randStudent).enrolledCourses, randEventCourse];
    newStudents = Students;
    
    Teachers(randTeacher).classesTaught = [Teachers(randTeacher).classesTaught, randEventCourse];
    newTeachers = Teachers;
end
































