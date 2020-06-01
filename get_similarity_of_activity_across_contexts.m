%get activity difference across contexts in each area to simulate univariate
%differences between contexts
%needs 80 runs of a model with control, processed with
%NEW_input_data_CONTROL.m in this directory
%gives ALL_UNITS_ACROSS_CONTEXTS per region - is context 1 then context 2
%activity with context labels - contrast with t-test to see univariate
%activation difference between contexts

%in directory with processed results
load('sim_matrices_results_workspace_80runs_NEW_CONTROL.mat') % or just variables needed

%split IO into m1/m2/m3 (and just don't save)
 for r=1:size(all_files,1); 
no_IO_units_per_mod = (size(IO, 2)/3);
current_IO = eval(strcat('IO', num2str(r)));
assignin('base',strcat('m1', num2str(r)),current_IO(:, 1:no_IO_units_per_mod));
assignin('base',strcat('m2', num2str(r)),current_IO(:,no_IO_units_per_mod+1:2*no_IO_units_per_mod));
assignin('base',strcat('m3', num2str(r)),current_IO(:,2*no_IO_units_per_mod+1:size(IO, 2)));
 end
 
%getting activity per region (not similarity matrix)
region_name{1} = 'atl'; 
region_name{2} = 'pairwise';
region_name{3} = 'm1';
region_name{4} = 'm2'; 
region_name{5} = 'm3'; 

    av_absolute_context_differences=NaN(length(region_name), 50); %just need to have space for max num of units - 50 is more units than anything has - end will be NaN packed (zeros are rea)
    av_context_differences=NaN(length(region_name), 50);
    
%loop across diff regions
    for i = 1:length(region_name); 
    current_region_name = region_name{i}; 
    first_activity_matrix=eval(strcat(current_region_name, '1'));
    ALL_CONTEXT1_ROWS=zeros(1,size(first_activity_matrix, 2));
    ALL_CONTEXT2_ROWS=zeros(1,size(first_activity_matrix, 2));

        %loop across model runs
       for r=1:size(all_files,1); 
        current_activity_matrix = eval(strcat(current_region_name, num2str(r))); 
        group_sum_diff =zeros(1,size(current_activity_matrix, 2));    %varies by number of units in regions
            group_sum_absolute_diff =zeros(1,size(current_activity_matrix, 2));
            
             %loop across 16 concepts
        for concept = 1:16;   
        sum_diff=zeros(1,size(current_activity_matrix, 2));
        sum_absolute_diff=zeros(1,size(current_activity_matrix, 2));
        %get diffs in 9 contexts make compare this row to next 8 in turn, and these to each other -
        %fast way? save absolute differences
        %need each row = num of concept * contexts + context
        %start_row = ((concept-1)*9)+1;
         % no - take one context - m1 in, m2 out and subtract another - m1
        % in, m3 out (check context order numbers)
        
        %GET m1_m2 for an example - is 4th context
        context1_row = current_activity_matrix(((concept-1)*9)+4,:);
        %GET m1_m3 for an example - is 7th context
        context2_row = current_activity_matrix(((concept-1)*9)+7,:);
       
        %for stats - direct comparison between = analogy to univariate analysis???
        ALL_CONTEXT1_ROWS = vertcat(ALL_CONTEXT1_ROWS, context1_row);
         ALL_CONTEXT2_ROWS = vertcat(ALL_CONTEXT2_ROWS, context2_row);
        
        %get difference
        diff= context1_row - context2_row;
        %sum differences across concepts
        sum_diff = sum_diff + diff;
        % get absolute diffs
        sum_absolute_diff = sum_absolute_diff + abs(diff);
        end
        % sum across runs
        group_sum_diff = group_sum_diff+(sum_diff);
        group_sum_absolute_diff = group_sum_absolute_diff+(sum_absolute_diff);
       end  
       %divide by number of runs*concepts to get average per run and concept
        av_diff = group_sum_diff/(size(all_files,1)*16);
        av_absolute_diff=group_sum_absolute_diff/size(all_files,1)*16;

        %into matrix of differences by regions (rows are region, columns
        %are units)
         av_absolute_context_differences(i,1:size(current_activity_matrix, 2)) = av_absolute_diff;
         av_context_differences(i,1:size(current_activity_matrix, 2)) = av_diff;
      clear av_diff av_absolute_diff   
      
      %add context label and vertcat across contexts to do stats between
      ALL_CONTEXT1_ROWS=horzcat(ones(length(ALL_CONTEXT1_ROWS),1), ALL_CONTEXT1_ROWS);
      temp_labels=ones(length(ALL_CONTEXT1_ROWS),1)+ones(length(ALL_CONTEXT1_ROWS),1);
      ALL_CONTEXT2_ROWS=horzcat(temp_labels, ALL_CONTEXT2_ROWS);
      ALL_UNITS_ACROSS_CONTEXTS=vertcat(ALL_CONTEXT1_ROWS(2:end,:),ALL_CONTEXT2_ROWS(2:end,:));%lose first line as is zeros
      
      assignin('base',strcat('ALL_UNITS_ACROSS_CONTEXTS_', current_region_name),ALL_UNITS_ACROSS_CONTEXTS); 
 
      
    end

        %save important variables -DOESN'T VARY BY FILENAME - MAKE IF do
        %multiple versions
     save('univariate_simulation.mat', 'ALL_UNITS_ACROSS_CONTEXTS_atl', 'ALL_UNITS_ACROSS_CONTEXTS_pairwise', 'ALL_UNITS_ACROSS_CONTEXTS_m1', 'ALL_UNITS_ACROSS_CONTEXTS_m2', 'ALL_UNITS_ACROSS_CONTEXTS_m3')
     
     