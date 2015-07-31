function [ Khard ] = GetKHard( numCourses, numDays, numStudents )
% GetKHard Return the hard constraint scaling value
%
%  numCourses Number
%     numDays Number
% numStudents Number
%
% Returns the hard constraint scaling value

% Khard is calculated based on Ksoft.
% Consider the most amount of soft constraints unsatisfiable, multiply
% by Ksoft, and then round that up to the next highest power of 10.
worstCase = (numStudents * numCourses) + (numStudents * min([numDays, numCourses]));
Khard = 10 ^ ceil(log10(GetKSoft() * worstCase));

end

