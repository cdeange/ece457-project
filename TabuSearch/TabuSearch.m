function [ bestSolution ] = TabuSearch( schedule, rooms, tabuListLength, students )
    
    bestSolution = schedule;
    bestFitness = inf; 
    
    tabuList = zeros(length(schedule.courseMappings));
    
    %while still doing
    for k = 1:length(schedule)
        k
       [bestNeighbourSched fitness secondCourseTabu] = getBestNeighbour(schedule, k, rooms, tabuList, students);
       if fitness > bestFitness
            bestSolution = bestNeighbourSched;
            bestFitness = fitness;
       end
       %update Tabu - with tabu list size
       tabuList = tabuList - 1;
       tabuList(tabuList<0) = 0;
       %TODO pass in tabu length list
       tabuList(k) = tabuListLength;
       if secondCourseTabu ~= 0
           tabuList(secondCourseTabu) = tabuListLength;
       end
    
    end
    %end
    
    
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
                  PrintSchedule(newNeighbourSched);
                  fitness  = GetFitness( newNeighbourSched, students, 1000000, 1, true )
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
       
       %set return
       bestNeighbourSched = currentBestNeighbour;
       bestNeighbourFitness = currentBestNeighbourFitness;
       
       
   end
  
   
end

    

