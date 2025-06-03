function test_excel_load()
% TEST_EXCEL_LOAD Simple routine to verify reading the CI Excel files.
%   This function loads each of the provided Excel workbooks using
%   readtable with the 'VariableNamingRule' set to 'preserve'. It
%   displays the variable names and the first few rows so you can confirm
%   that the data import works correctly.

files = { ...
    'CI engine exercise 1500and3000RPM.xlsx', ...
    'CI engine exercise 2000and3500RPM.xlsx', ...
    'CI engine exercise 2500and4000RPM.xlsx'};

for i = 1:numel(files)
    fprintf('--- %s ---\n', files{i});
    T = readtable(files{i}, 'VariableNamingRule', 'preserve');
    disp(T.Properties.VariableNames');
    disp(head(T, 3));
end
end
