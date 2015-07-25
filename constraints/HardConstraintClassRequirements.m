function [ numUnmetRequirements ] = HardConstraintClassRequirements( schedule )
    
coursemappings = schedule.courseMappings;

numUnmetRequirements = 0;

for i = 1:length(coursemappings)
    courseReqs = coursemappings(i).course.featuresReq;
    roomFeat = coursemappings(i).room.features;
    isSubset = all(ismember(courseReqs, roomFeat));
    if isSubset ~= 1
        numUnmetRequirements = numUnmetRequirements + 1;
    end
end

end
