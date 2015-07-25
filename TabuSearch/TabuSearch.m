function [ bestSolution ] = TabuSearch( schedule, rooms, tabuListLength )
    
    bestSolution = schedule;
    
    tabuList = zeros(length(schedule));
    
    %while still doing
    for i = 1:length(schedule)
       
    end
    %end
    
    %create tabu list
    %find all neighbours and their fitness
    %choose the best neighbour that's not in the tabu list
    %add class to the tabu list
    %update bestSolution as a new schedule with the swap done
    
end

function [bestNeighbourSched bestNeighbourFitness tabuList] = getBestNeighbour(schedule, currentCourse, rooms, TabuList)
   currentBestNeighbour = 0;
   currentBestNeighbourFitness = inf;
   secondCourseTabu = 0;
   coursemappings = schedule.courseMappings;
   currentCoursemapping = coursemappings(currentCourse);
   course = curentCoursemapping.course;
   days = schedule.days;
   timeslots = schedule.timeslots;
   
   tabuList = TabuList;
   
   if tabuList(course.courseID) == 0   
       %find best of moving
       for i = 1:days
          for j = 1 : timeslots - duration + 1
              if (i ~= currentCoursemapping.day && j ~= currentCoursemapping.timeslot)
                  newNeighbourMapping = CourseMapping(course, currentCoursemapping.room, i, j);
                  newNeighourMappings = courseMappings;
                  newNeighourMappings(currentCourse) = newNeighbourMapping;
                  newNeighbourSched = Schedule(newNeighourMappings, days, timeslots);
                  %get fitness
                  %if fitness < currentBestNeighbourFitness
                  currentBestNeighbour = newNeighbourSched;
                  %currentBestNeighbourFitness = fitness;
                  %end
              end
          end
       end

       %find best of swapping room
       for i = 1:length(rooms)
           if (currentCoursemapping.room.roomID ~= rooms(i).roomID)
               newNeighbourMapping = CourseMapping(course, rooms(i), currentCoursemapping.day, currentCoursemapping.timeSlot);
               newNeighourMappings = courseMappings;
               newNeighourMappings(currentCourse) = newNeighbourMapping;
               newNeighbourSched = Schedule(newNeighourMappings, days, timeslots);
               %get fitness
               %if fitness < currentBestNeighbourFitness
               currentBestNeighbour = newNeighbourSched;
               %currentBestNeighbourFitness = fitness;
               %end
           end
           
       end

       
       %find best of swapping with other class
       for i = 1:length(coursemappings)
          if coursemappings(i).course.courseID ~= course.courseID
             if tabuList(i) == 0
                 newNeighbourMapping1 = CourseMapping(course, coursemappings(i).room, coursemappings(i).course.day, coursemappings(i).course.timeSlot);
                 newNeighbourMapping2 = CourseMapping(coursemappings(i).course, currentCoursemapping.room, currentCoursemapping.day, currentCoursemapping.timeSlot);
                 newNeighourMappings = courseMappings;
                 newNeighourMappings(currentCourse) = newNeighbourMapping1;
                 newNeighourMappings(i) = newNeighbourMapping2;
                 newNeighbourSched = Schedule(newNeighourMappings, days, timeslots);
                 %get fitness
                 %if fitness < currentBestNeighbourFitness
                 currentBestNeighbour = newNeighbourSched;
                 secondCourseTabu = i;
                 %currentBestNeighbourFitness = fitness;
                 %end
             end
          end
       end
       
       %set return
       bestNeighbourSched = currentBestNeighbour;
       %bestNeighbourSched = currentBestNeighbourFitness;
       %update Tabu - with tabu list size
       tabuList = tabuList - 1;
       %TODO pass in tabu length list
       tabuList(currentCourse) = 10;
       if secondCourseTabu ~= 0
           tabuList(secondCourseTabu) = 10;
       end
       
   end
  
   
end

    

