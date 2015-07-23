function PrintSchedule( schedule2print )

    %get values
    coursemappings = [schedule2print.courseMappings];
    eventmappings = [schedule2print.eventMappings];
    numDays = schedule2print.days;
    numTimeSlots = schedule2print.timeslots;
    
    
    
    %create cell array of proper size
    schedule = cell(numTimeSlots + 1, numDays + 1);
    
    %iterate through and add days/timeslots    
    %vertical, add time slots
    for i = 1:numTimeSlots
        schedule{i + 1,1} = {strcat('TS-',int2str(i))};
    end
    
    
    %horizontal, add days
    for i = 1:numDays
        schedule{1,i + 1} = {strcat('Day-',int2str(i))};
    end
    
    
    %go through and add all events/courses
    for i = 1:length(coursemappings)
        day = coursemappings(i).day + 1;
        timeslot = coursemappings(i).timeSlot + 1;
        
        formattedMapping = formatCourseMapping(coursemappings(i));
        duration = coursemappings(i).course.duration;
        
        for ts = timeslot: timeslot + duration - 1
            sizes = size(schedule{ts, day});
            schedule{ts, day}{sizes(1) + 1,1} =  formattedMapping;
        end
       
    end
    
    %go through and add all events/courses
    for i = 1:length(eventmappings)
        day = eventmappings(i).day + 1;
        timeslot = eventmappings(i).timeSlot + 1;
        
        formattedMapping = formatEventMapping(eventmappings(i));
        duration = eventmappings(i).event.duration;
        
        for ts = timeslot: timeslot + duration - 1
            sizes = size(schedule{ts, day});
            schedule{ts, day}{sizes(1) + 1,1} =  formattedMapping;
        end
       
    end
    
    %go through each row and find max size for a given timeslot
    maxSizes = zeros(numTimeSlots + 1,1);
    for i = 1:numTimeSlots + 1
        for j = 1:numDays + 1
            sizes = size(schedule{i,j});
            if sizes(1) > maxSizes(i)
                maxSizes(i) = sizes(1);
            end
        end
    end
    disp(maxSizes)
    
    %add blank cells so they all are same size
    for i = 1:numTimeSlots + 1
        for j = 1:numDays + 1
            sizes = size(schedule{i,j});
            if maxSizes(i) > sizes(1)
                max = maxSizes(i);
                schedule{i,j}{max, 1} = '';
            end
        end
    end

    disp(schedule);

    %PRINT!!!!
      for i = 1:numTimeSlots + 1
          for k = 1:maxSizes(i)
            for j = 1:numDays + 1
              
                  strCell = schedule{i,j};
                  str = '';
                  if maxSizes(i) > 1
                     %str = sprintf('%d', strCell{k});
%                      class(strCell{k})
%                      disp(strCell{k});
                     str = char(strCell{k});
                  else
                     %str = sprintf('%d', strCell);
%                      class(strCell)
%                      disp(strCell);
                     str = char(strCell);
                  end
                  
                  fprintf('%25s | ', str);
            end
            fprintf('\n');
            divider = repmat('-',1,28*(numDays+1));
            fprintf('%s',divider);
            fprintf('\n');
          end
      end
    
end

function [formatted] = formatCourseMapping(coursemapping)
    day = coursemapping.day;
    timeslot = coursemapping.timeSlot;
    room = coursemapping.room;
    course = coursemapping.course;
    
    str = sprintf('C:%d R:%d D:%d T:%d d:%d', course.courseID, room.roomID, day, timeslot, course.duration);
    formatted = str;
end

function [formatted] = formatEventMapping(eventmapping)
    day = eventmapping.day;
    timeslot = eventmapping.timeSlot;
    room = eventmapping.room;
    event = eventmapping.event;
    
    str = sprintf('E:%d R:%d D:%d T:%d d:%d', event.eventID, room.roomID, day, timeslot, event.duration);
    formatted = str;
end


















