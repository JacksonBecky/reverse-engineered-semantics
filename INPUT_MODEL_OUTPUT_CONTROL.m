
function [ results_data ] = INPUT_MODEL_OUTPUT_CONTROL(filename, num_ex)
%TAKES FILENAME OF MODEL OUTPUT AND LOADS IN TO MATLAB W/O FIRST 3 COLUMNS
%(I.E. JUST ACTIVATION)


%loads textfile into single cell array
fid = fopen(filename);
data = textscan(fid,'%s','delimiter',' ');
fclose(fid);

%change single cell array to correct sized matrix - depends on no units
%(same for all arch using atm as matched) - in correct dim and del first 3
%rows (unit name, example name, epoch number)

results_data = reshape(data{:},[],(num_ex*25)); %25 epochs * number of examples (full diff examples e.g. 48 not 16)
results_data=results_data';
 results_data=results_data(:,4:size(results_data, 2));

%fix structure type inputted in so works
results_data=str2double(results_data);

end


