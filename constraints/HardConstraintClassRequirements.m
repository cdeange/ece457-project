function [ numUnmetRequirements ] = HardConstraintClassRequirements( schedule )
% HardConstraintClassRequirements Determines courses in rooms with unmet
% requirements.
%
% schedule Schedule
%
% Returns the number of times this constraint is not met

coursemappings = schedule.courseMappings;

numUnmetRequirements = 0;

for i = 1:length(coursemappings),
    courseReqs = coursemappings(i).course.featuresReq;
    roomFeat = coursemappings(i).room.features;
    isSubset = all(ismember(courseReqs, roomFeat));
    if isSubset ~= 1,
        % Unsatisfied requirements detected!
        numUnmetRequirements = numUnmetRequirements + 1;
    end
end

end
