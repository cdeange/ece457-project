A = {'hi', 'ho' ; 'hey', {'poo';'oop'}}
% A{2,2} = cell2table(A{2,2});

A{2,2} = {A{2,2}{:} ; 'asdf'}
%A{2,2}{3} = 'yup';
%T = cell2mat(A)
%  fprintf(A{1,1});
%  fprintf(A{1,2});
%  fprintf('\n');
%  fprintf(A{2,1});
 str = A{2,2}{3}
 fprintf('AKJDB %s',str);
% disp('----');
% celldisp(A{2,2});



