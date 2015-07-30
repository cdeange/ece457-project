function [ c1 c2 ] = Crossover( p1, p2, rooms )
% Crossover Crosses over two parent schedules
%
%    p1 Schedule
%    p2 Schedule
% rooms List(Classroom)
%
% Returns the two children created from the crossover

courseCount = length(p1.courseMappings);
crossover_max = courseCount * 3;

cpoints = zeros(1, 3);
for i = 1:3,
    cpoint = 0;
    while any(cpoints == cpoint),
        % Generate random, unique crossover points
        cpoint = randi([1 crossover_max], 1);
    end
    cpoints(i) = cpoint;
end

cpoints = sort(cpoints);

% Unwrap the classes into a long vector of values
valuesp1 = zeros(1, crossover_max);
valuesp2 = zeros(1, crossover_max);
for i = 1:courseCount,
    offset = (i - 1) * 3;
    valuesp1(offset + 1) = p1.courseMappings(i).day;
    valuesp1(offset + 2) = p1.courseMappings(i).room.roomID;
    valuesp1(offset + 3) = p1.courseMappings(i).timeSlot;
    
    valuesp2(offset + 1) = p2.courseMappings(i).day;
    valuesp2(offset + 2) = p2.courseMappings(i).room.roomID;
    valuesp2(offset + 3) = p2.courseMappings(i).timeSlot;
end

% Cross over the value vectors
cp1 = cpoints(1);
cp2 = cpoints(2);
cp3 = cpoints(3);

valuesc1 = [valuesp1(1:cp1) valuesp2(cp1 + 1:cp2) valuesp1(cp2 + 1:cp3) valuesp2(cp3 + 1:end)];
valuesc2 = [valuesp2(1:cp1) valuesp1(cp1 + 1:cp2) valuesp2(cp2 + 1:cp3) valuesp1(cp3 + 1:end)];

% Recombine the values into new CourseMappings
mappings1 = CourseMapping.empty(courseCount, 0);
mappings2 = CourseMapping.empty(courseCount, 0);

for i = 1:courseCount,
    offset = (i - 1) * 3;
    
    day1         = valuesc1(offset + 1);
    room1        = valuesc1(offset + 2);
    timeslot1    = valuesc1(offset + 3);
    mappings1(i) = CourseMapping(p1.courseMappings(i).course, rooms(room1), day1, timeslot1);
    
    day2         = valuesc2(offset + 1);
    room2        = valuesc2(offset + 2);
    timeslot2    = valuesc2(offset + 3);
    mappings2(i) = CourseMapping(p2.courseMappings(i).course, rooms(room2), day2, timeslot2);
end

% Create the children schedules from the new mappings
c1 = Schedule(mappings1, p1.days, p1.timeslots);
c2 = Schedule(mappings2, p2.days, p2.timeslots);

end
