classdef RoomFeature
    %CLASSFEATURE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        featureID
    end
    
    methods
        function feature = RoomFeature(featureID)
           if nargin > 0
               feature.featureID = featureID;
           end
        end
    end
    
end

