function PrintSchedule( schedule2print )
    % PrintSchedule Print a given schedule in a human-readable way
    % 
    % schedule2print Schedule
    
    % Get values
    coursemappings = [schedule2print.courseMappings];
    numDays = schedule2print.days;
    numTimeSlots = schedule2print.timeslots;
    
    % Create cell array of proper size
    schedule = cell(numTimeSlots + 1, numDays + 1);
    
    % Iterate through and add days/timeslots
    % Vertical, add time slots
    for i = 1:numTimeSlots,
        schedule{i + 1, 1} = {strcat('Timeslot ', int2str(i))};
    end
    
    
    % Horizontal, add days
    for i = 1:numDays,
        schedule{1, i + 1} = {strcat('Day ',int2str(i))};
    end
    
    
    % Go through and add all events/courses
    for i = 1:length(coursemappings),
        day = coursemappings(i).day + 1;
        timeslot = coursemappings(i).timeSlot + 1;
        
        formattedMapping = formatCourseMapping(coursemappings(i));
        duration = coursemappings(i).course.duration;
        
        for ts = timeslot:(timeslot + duration - 1),
            if ts > length(schedule),
                fprintf('Course %d overflows timeslots!\n', coursemappings(i).course.courseID);
            else
                sizes = size(schedule{ts, day});
                schedule{ts, day}{sizes(1) + 1, 1} =  formattedMapping;
            end
        end
        
    end
    
    
    % Go through each row and find max size for a given timeslot
    maxSizes = zeros(numTimeSlots + 1, 1);
    for i = 1:numTimeSlots + 1,
        for j = 1:numDays + 1,
            sizes = size(schedule{i, j});
            if sizes(1) > maxSizes(i),
                maxSizes(i) = sizes(1);
            end
        end
    end
    
    % Add blank cells so they all are same size
    for i = 1:numTimeSlots + 1,
        for j = 1:numDays + 1,
            sizes = size(schedule{i, j});
            if maxSizes(i) > sizes(1),
                max = maxSizes(i);
                schedule{i, j}{max, 1} = '';
            end
        end
    end
    
    % Print the schedule!
    for i = 1:numTimeSlots + 1,
        for k = 1:maxSizes(i),
            for j = 1:numDays + 1,
                strCell = schedule{i, j};
                
                if maxSizes(i) > 1,
                    str = char(strCell{k});
                else
                    str = char(strCell);
                end
                
                fprintf('%20s | ', str);
            end
            
            divider = repmat('-', 1, 23 * (numDays + 1) - 1);
            fprintf('\n%s\n',divider);
        end
    end
    
end

function [ formatted ] = formatCourseMapping( coursemapping )
    % Format for a single cell for a CourseMapping
    timeslot = coursemapping.timeSlot;
    room = coursemapping.room;
    course = coursemapping.course;
    
    str = sprintf('"%s%d" R%d T%d D%d', course.courseType, course.courseID, room.roomID, timeslot, course.duration );
    formatted = str;
end
