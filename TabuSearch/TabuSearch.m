function [ bestSolution ] = TabuSearch( schedule, rooms, tabuListLength, students )
    
    bestSolution = schedule;
    bestFitness = inf; 
    
    tabuList = zeros(length(schedule.courseMappings));
    
    while bestFitness >= 1000000

        bestNeighbourSolution = 0;
        bestNeighbourFitness = Inf;
        bestNeighbourIndex = 0;
        bestNeighbourSwapIndex = 0;

        for k = 1:length(schedule.courseMappings)
            [neighbourSched fitness secondCourseTabu] = getBestNeighbour(bestSolution, k, rooms, tabuList, students);

            if fitness < bestNeighbourFitness,
                bestNeighbourSolution = neighbourSched;
                bestNeighbourFitness = fitness;
                bestNeighbourIndex = k;
                bestNeighbourSwapIndex = secondCourseTabu;
            end
        
        end

        bestSolution = bestNeighbourSolution;
        bestFitness = bestNeighbourFitness

        tabuList = tabuList - 1;
        tabuList(tabuList < 0) = 0;

        tabuList(bestNeighbourIndex) = tabuListLength;
        if bestNeighbourSwapIndex ~= 0
           tabuList(bestNeighbourSwapIndex) = tabuListLength;
        end

    end
    
    bestFitness
    
    %create tabu list
    %find all neighbours and their fitness
    %choose the best neighbour that's not in the tabu list
    %add class to the tabu list
    %update bestSolution as a new schedule with the swap done
    
end

function [bestNeighbourSched bestNeighbourFitness secondCourseTabu] = getBestNeighbour(schedule, currentCourse, rooms, tabuList, students)
   currentBestNeighbour = 0;
   currentBestNeighbourFitness = inf;
   secondCourseTabu = 0;
   coursemappings = schedule.courseMappings;
   currentCoursemapping = coursemappings(currentCourse);
   course = currentCoursemapping.course;
   duration = course.duration;
   days = schedule.days;
   timeslots = schedule.timeslots;
   
   if tabuList(course.courseID) == 0   
       %find best of moving
       for i = 1:days
          for j = 1 : timeslots - duration + 1
              if (i ~= currentCoursemapping.day || j ~= currentCoursemapping.timeSlot)
                  newNeighbourMapping = CourseMapping(course, currentCoursemapping.room, i, j);
                  newNeighourMappings = coursemappings;
                  newNeighourMappings(currentCourse) = newNeighbourMapping;
                  newNeighbourSched = Schedule(newNeighourMappings, days, timeslots);
%                   PrintSchedule(newNeighbourSched);
                  fitness = GetFitness(newNeighbourSched, students );
                  if fitness < currentBestNeighbourFitness
                      currentBestNeighbour = newNeighbourSched;
                      currentBestNeighbourFitness = fitness;
                  end
              end
          end
       end

       %find best of swapping room
       for i = 1:length(rooms)
           if (currentCoursemapping.room.roomID ~= rooms(i).roomID)
               newNeighbourMapping = CourseMapping(course, rooms(i), currentCoursemapping.day, currentCoursemapping.timeSlot);
               newNeighourMappings = coursemappings;
               newNeighourMappings(currentCourse) = newNeighbourMapping;
               newNeighbourSched = Schedule(newNeighourMappings, days, timeslots);
               fitness  = GetFitness( newNeighbourSched, students );
               if fitness < currentBestNeighbourFitness
                  currentBestNeighbour = newNeighbourSched;
                  currentBestNeighbourFitness = fitness;
               end
           end
           
       end

       
       %find best of swapping with other class
       for i = 1:length(coursemappings)
          if coursemappings(i).course.courseID ~= course.courseID
             if tabuList(i) == 0
                 newNeighbourMapping1 = CourseMapping(course, coursemappings(i).room, coursemappings(i).day, coursemappings(i).timeSlot);
                 newNeighbourMapping2 = CourseMapping(coursemappings(i).course, currentCoursemapping.room, currentCoursemapping.day, currentCoursemapping.timeSlot);
                 newNeighourMappings = coursemappings;
                 newNeighourMappings(currentCourse) = newNeighbourMapping1;
                 newNeighourMappings(i) = newNeighbourMapping2;
                 newNeighbourSched = Schedule(newNeighourMappings, days, timeslots);
                 fitness  = GetFitness( newNeighbourSched, students );
                  if fitness < currentBestNeighbourFitness
                      currentBestNeighbour = newNeighbourSched;
                      currentBestNeighbourFitness = fitness;
                  end
             end
          end
       end
       
   end
       
   % set return
   bestNeighbourSched = currentBestNeighbour;
   bestNeighbourFitness = currentBestNeighbourFitness;
       
  
   
end

    

