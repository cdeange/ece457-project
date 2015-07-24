function [ numUnmetRequirements ] = HardConstraintClassRequirements( schedule )
    
coursemappings = schedule.courseMappings;

numUnmetRequirements = 0;

for i = 1:length(coursemappings)
    courseReqs = getFeatures(coursemappings(i).course.featuresReq);
    roomFeat = getFeatures(coursemappings(i).room.features);
    isSubset = all(ismember(courseReqs, roomFeat));
    if isSubset ~= 1
        numUnmetRequirements = numUnmetRequirements + 1;
    end
end

end

% return array of feature IDs from a list of feature
function [featuresreqs] = getFeatures( features )

featuresreqs = sort(arrayfun(@(f)f.featureID, features));

end
