function [ values, valid ] = ValidateNumbers( varargin )
% ValidateNumbers Ensure that all arguments are valid numbers
%
% varargin List(String)
%
% Returns true if all inputs are numbers, otherwise false

valid = true;
values = zeros(1, nargin);

index = 1;
for val = varargin,
    string = val{1};
    num = str2double(string);
    if isnan(num),
        msg = sprintf('"%s" is not a valid number.', string);
        errordlg(msg, 'Number Error');
        valid = false;
    end
    
    values(index) = num;
    index = index + 1;
end

end
