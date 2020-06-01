% Functional connectivity assessment of regions within semantic
% representation network (e.g., hub vs spoke connections)
%gets timecourses of hub and spoke regions in two different contexts (context1_PCA_timecourses, context2_PCA_timecourses) - use
%to compute correlations and see difference between
%needs results data from 80 models of an architecture in current directory,
%processed with NEW_input_data_CONTROL_GIT.m 
%models should have negative biases on the hidden units (this is an option
%in the simulation code)

%get activations with original order
load('sim_matrices_results_workspace_80runs_NEW_CONTROL',  'results_data*')

%CREATE BLANK V'S FOR ALL RUNS - to look at unit timecourse only, not to compute FC
%input context 1 = m1 in, m2 out input context 2 = m1 in, m3 out
all_runs_context1_results_timecourse= [];
all_runs_context2_results_timecourse= [];
%create blank v's for all runs PCA timecourse - real timecourse using for
%FC - ROI-ROI, ATL constant, output mods only flipped by dir of correlation with ATL
all_runs_context1_PCA_timecourse_M1= [];
all_runs_context1_PCA_timecourse_M2= [];
all_runs_context1_PCA_timecourse_M3= [];
all_runs_context2_PCA_timecourse_M1= [];
all_runs_context2_PCA_timecourse_M2= [];
all_runs_context2_PCA_timecourse_M3= [];
all_runs_context1_PCA_timecourse_ATL= [];
all_runs_context2_PCA_timecourse_ATL= [];

%for each model run
for r=1:80; %num model runs
%load results
current_results = eval(strcat('results_data', num2str(r))) ;

%separate trials for each context
%IS ORDERED BY CONTEXTS THEN EXAMPLES (NOT FINAL ORDER) SO ALL OF FIRST CONTEXT FIRST ETC - MODALITY/CONTEXT ORDER IS M1_M1, M2_M1, M3_M1, M1_M2, M2_M2, M3_M2, M1_M3
%M2_M3, M3_M3

% get right trials for each context - full timecourse of each (25 epochs)
       %loop across 16 concepts
       context1=4; %gets m1_m2 context (see above to change)
       context2=7;%gets m1_m3 context (see above to change)
       epochs=25;
       num_context1_trials = 16; %16 examples in one context = 16 trials
       num_context2_trials = 16; %16 examples in one context = 16 trials
       concepts=16;
     %  CURRENT_CONTEXT1_ROWS =[]; CURRENT_CONTEXT2_ROWS =[];
       
       context1_row = current_results((context1-1)*concepts*epochs+1:(context1-1)*concepts*epochs+(concepts*epochs),:);
       context2_row = current_results((context2-1)*concepts*epochs+1:(context2-1)*concepts*epochs+(concepts*epochs),:);
       
        
%permute context1 trials to get random order for this run
current_context1_trials_idx = randperm(num_context1_trials);
current_ordered_context1_trials_results = [];
current_ordered_context1_trials_results_SINGLE_TIME = [];

for i=1:num_context1_trials;
    start_point = (current_context1_trials_idx(i)-1)*epochs+1+1; %added extra one so skips first trial
    end_point = current_context1_trials_idx(i)*epochs;
      current_ordered_context1_trials_results=vertcat(current_ordered_context1_trials_results, (context1_row(start_point:end_point,:)));% take 25 epochs of one trial 
    current_ordered_context1_trials_results_SINGLE_TIME=vertcat(current_ordered_context1_trials_results_SINGLE_TIME, (context1_row(end_point,:))); %take 25th epoch only
end
         
 %permute context2 trials to get random order for this run
current_context2_trials_idx = randperm(num_context2_trials);
current_ordered_context2_trials_results = [];current_ordered_context2_trials_results_SINGLE_TIME = [];

for i=1:num_context2_trials;
    start_point = ((current_context2_trials_idx(i)-1)*(epochs))+1+1; %added extra one so skips first trial
    end_point = current_context2_trials_idx(i)*(epochs);
      current_ordered_context2_trials_results=vertcat(current_ordered_context2_trials_results, (context2_row(start_point:end_point,:)));% take 25 epochs of one trial 
      current_ordered_context2_trials_results_SINGLE_TIME=vertcat(current_ordered_context2_trials_results_SINGLE_TIME, (context2_row(end_point,:))); %take 25th epoch only
end

%getting timecourse to look at only - not for computing FC as not flipped
%direction of each run based on pca correlation (unit-unit would be
%accurate but meaningless outside of spokes)
all_runs_context1_results_timecourse= vertcat(all_runs_context1_results_timecourse, current_ordered_context1_trials_results);
all_runs_context2_results_timecourse= vertcat(all_runs_context2_results_timecourse, current_ordered_context2_trials_results);


%split by area
current_run_context1_ATL_timecourse= current_ordered_context1_trials_results(:, 79:96);
current_run_context1_HL1_timecourse= current_ordered_context1_trials_results(:, 37:78); 
current_run_context2_ATL_timecourse= current_ordered_context2_trials_results(:, 79:96);
current_run_context2_HL1_timecourse=current_ordered_context2_trials_results(:, 37:78);
current_run_context1_M1_timecourse= current_ordered_context1_trials_results(:, 1:12);
current_run_context1_M2_timecourse= current_ordered_context1_trials_results(:, 13:24);
current_run_context1_M3_timecourse= current_ordered_context1_trials_results(:, 25:36);
current_run_context2_M1_timecourse= current_ordered_context2_trials_results(:, 1:12);
current_run_context2_M2_timecourse= current_ordered_context2_trials_results(:, 13:24);
current_run_context2_M3_timecourse= current_ordered_context2_trials_results(:, 25:36);


current_run_context1_ATL_timecourse_SINGLE_TIME= current_ordered_context1_trials_results_SINGLE_TIME(:, 79:96);
current_run_context1_HL1_timecourse_SINGLE_TIME= current_ordered_context1_trials_results_SINGLE_TIME(:, 37:78); 
current_run_context2_ATL_timecourse_SINGLE_TIME= current_ordered_context2_trials_results_SINGLE_TIME(:, 79:96);
current_run_context2_HL1_timecourse_SINGLE_TIME=current_ordered_context2_trials_results_SINGLE_TIME(:, 37:78); 
current_run_context1_M1_timecourse_SINGLE_TIME=current_ordered_context1_trials_results_SINGLE_TIME(:, 1:12);
current_run_context1_M2_timecourse_SINGLE_TIME= current_ordered_context1_trials_results_SINGLE_TIME(:, 13:24);
current_run_context1_M3_timecourse_SINGLE_TIME= current_ordered_context1_trials_results_SINGLE_TIME(:, 25:36);
current_run_context2_M1_timecourse_SINGLE_TIME= current_ordered_context2_trials_results_SINGLE_TIME(:, 1:12);
current_run_context2_M2_timecourse_SINGLE_TIME= current_ordered_context2_trials_results_SINGLE_TIME(:, 13:24);
current_run_context2_M3_timecourse_SINGLE_TIME= current_ordered_context2_trials_results_SINGLE_TIME(:, 25:36);


%average over area would lose control signal so reduce data to first
%principal component - invert all as want over time not voxels
context1_HL1_coeff = pca(current_run_context1_HL1_timecourse');
context1_ATL_coeff = pca(current_run_context1_ATL_timecourse');
context2_HL1_coeff = pca(current_run_context2_HL1_timecourse');
context2_ATL_coeff = pca(current_run_context2_ATL_timecourse');

context1_M1_coeff = pca(current_run_context1_M1_timecourse');
context1_M2_coeff = pca(current_run_context1_M2_timecourse');
context1_M3_coeff = pca(current_run_context1_M3_timecourse');
context2_M1_coeff = pca(current_run_context2_M1_timecourse');
context2_M2_coeff = pca(current_run_context2_M2_timecourse');
context2_M3_coeff = pca(current_run_context2_M3_timecourse');

context1_HL1_coeff_SINGLE_TIME = pca(current_run_context1_HL1_timecourse_SINGLE_TIME');
context1_ATL_coeff_SINGLE_TIME = pca(current_run_context1_ATL_timecourse_SINGLE_TIME');
context2_HL1_coeff_SINGLE_TIME = pca(current_run_context2_HL1_timecourse_SINGLE_TIME');
context2_ATL_coeff_SINGLE_TIME = pca(current_run_context2_ATL_timecourse_SINGLE_TIME');

context1_M1_coeff_SINGLE_TIME = pca(current_run_context1_M1_timecourse_SINGLE_TIME');
context1_M2_coeff_SINGLE_TIME = pca(current_run_context1_M2_timecourse_SINGLE_TIME');
context1_M3_coeff_SINGLE_TIME = pca(current_run_context1_M3_timecourse_SINGLE_TIME');
context2_M1_coeff_SINGLE_TIME = pca(current_run_context2_M1_timecourse_SINGLE_TIME');
context2_M2_coeff_SINGLE_TIME = pca(current_run_context2_M2_timecourse_SINGLE_TIME');
context2_M3_coeff_SINGLE_TIME = pca(current_run_context2_M3_timecourse_SINGLE_TIME');

%correlations across regions - uses first component only - ABS value of
%correlation as PCA factor is equivalent to same but opposite directionality
CONTEXT1_HL2_VS_HL1_CONC(r,1) = abs(corr(context1_HL1_coeff(:,1), context1_ATL_coeff(:,1))); 
CONTEXT2_HL2_VS_HL1_CONC(r,1) = abs(corr(context2_HL1_coeff(:,1), context2_ATL_coeff(:,1))); 

CONTEXT1_HL2_VS_M1_CONC(r,1) = abs(corr(context1_M1_coeff(:,1), context1_ATL_coeff(:,1))); 
CONTEXT1_HL2_VS_M2_CONC(r,1) = abs(corr(context1_M2_coeff(:,1), context1_ATL_coeff(:,1))); 
CONTEXT1_HL2_VS_M3_CONC(r,1) = abs(corr(context1_M3_coeff(:,1), context1_ATL_coeff(:,1))); 
CONTEXT2_HL2_VS_M1_CONC(r,1) = abs(corr(context2_M1_coeff(:,1), context2_ATL_coeff(:,1))); 
CONTEXT2_HL2_VS_M2_CONC(r,1) = abs(corr(context2_M2_coeff(:,1), context2_ATL_coeff(:,1))); 
CONTEXT2_HL2_VS_M3_CONC(r,1) = abs(corr(context2_M3_coeff(:,1), context2_ATL_coeff(:,1))); 

CONTEXT1_HL1_VS_M1_CONC(r,1) = abs(corr(context1_M1_coeff(:,1), context1_HL1_coeff(:,1))); 
CONTEXT1_HL1_VS_M2_CONC(r,1) = abs(corr(context1_M2_coeff(:,1), context1_HL1_coeff(:,1))); 
CONTEXT1_HL1_VS_M3_CONC(r,1) = abs(corr(context1_M3_coeff(:,1), context1_HL1_coeff(:,1))); 
CONTEXT2_HL1_VS_M1_CONC(r,1) = abs(corr(context2_M1_coeff(:,1), context2_HL1_coeff(:,1))); 
CONTEXT2_HL1_VS_M2_CONC(r,1) = abs(corr(context2_M2_coeff(:,1), context2_HL1_coeff(:,1))); 
CONTEXT2_HL1_VS_M3_CONC(r,1) = abs(corr(context2_M3_coeff(:,1), context2_HL1_coeff(:,1))); 

CONTEXT1_HL2_VS_HL1_CONC_SINGLE_TIME(r,1) = abs(corr(context1_HL1_coeff_SINGLE_TIME(:,1), context1_ATL_coeff_SINGLE_TIME(:,1))); 
CONTEXT2_HL2_VS_HL1_CONC_SINGLE_TIME(r,1) = abs(corr(context2_HL1_coeff_SINGLE_TIME(:,1), context2_ATL_coeff_SINGLE_TIME(:,1))); 

CONTEXT1_HL2_VS_M1_CONC_SINGLE_TIME(r,1) = abs(corr(context1_M1_coeff_SINGLE_TIME(:,1), context1_ATL_coeff_SINGLE_TIME(:,1))); 
CONTEXT1_HL2_VS_M2_CONC_SINGLE_TIME(r,1) = abs(corr(context1_M2_coeff_SINGLE_TIME(:,1), context1_ATL_coeff_SINGLE_TIME(:,1))); 
CONTEXT1_HL2_VS_M3_CONC_SINGLE_TIME(r,1) = abs(corr(context1_M3_coeff_SINGLE_TIME(:,1), context1_ATL_coeff_SINGLE_TIME(:,1))); 
CONTEXT2_HL2_VS_M1_CONC_SINGLE_TIME(r,1) = abs(corr(context2_M1_coeff_SINGLE_TIME(:,1), context2_ATL_coeff_SINGLE_TIME(:,1))); 
CONTEXT2_HL2_VS_M2_CONC_SINGLE_TIME(r,1) = abs(corr(context2_M2_coeff_SINGLE_TIME(:,1), context2_ATL_coeff_SINGLE_TIME(:,1))); 
CONTEXT2_HL2_VS_M3_CONC_SINGLE_TIME(r,1) = abs(corr(context2_M3_coeff_SINGLE_TIME(:,1), context2_ATL_coeff_SINGLE_TIME(:,1))); 

CONTEXT1_HL1_VS_M1_CONC_SINGLE_TIME(r,1) = abs(corr(context1_M1_coeff_SINGLE_TIME(:,1), context1_HL1_coeff_SINGLE_TIME(:,1))); 
CONTEXT1_HL1_VS_M2_CONC_SINGLE_TIME(r,1) = abs(corr(context1_M2_coeff_SINGLE_TIME(:,1), context1_HL1_coeff_SINGLE_TIME(:,1))); 
CONTEXT1_HL1_VS_M3_CONC_SINGLE_TIME(r,1) = abs(corr(context1_M3_coeff_SINGLE_TIME(:,1), context1_HL1_coeff_SINGLE_TIME(:,1))); 
CONTEXT2_HL1_VS_M1_CONC_SINGLE_TIME(r,1) = abs(corr(context2_M1_coeff_SINGLE_TIME(:,1), context2_HL1_coeff_SINGLE_TIME(:,1))); 
CONTEXT2_HL1_VS_M2_CONC_SINGLE_TIME(r,1) = abs(corr(context2_M2_coeff_SINGLE_TIME(:,1), context2_HL1_coeff_SINGLE_TIME(:,1))); 
CONTEXT2_HL1_VS_M3_CONC_SINGLE_TIME(r,1) = abs(corr(context2_M3_coeff_SINGLE_TIME(:,1), context2_HL1_coeff_SINGLE_TIME(:,1))); 

%get timecourses use in ROI-ROI (PCA-based) correlations across runs
all_runs_context1_PCA_timecourse_ATL=vertcat(all_runs_context1_PCA_timecourse_ATL,context1_ATL_coeff(:,1));
all_runs_context2_PCA_timecourse_ATL=vertcat(all_runs_context2_PCA_timecourse_ATL,context2_ATL_coeff(:,1));
%GETTING m1/2/3 FLIPPED DIR TIMECOURSE BASED ON CORRELATION OF PCA WITH ATL
if corr(context1_M1_coeff(:,1), context1_ATL_coeff(:,1)) > 0;
    all_runs_context1_PCA_timecourse_M1=vertcat(all_runs_context1_PCA_timecourse_M1,context1_M1_coeff(:,1));
else
    all_runs_context1_PCA_timecourse_M1=vertcat(all_runs_context1_PCA_timecourse_M1,-(context1_M1_coeff(:,1)));
end
if corr(context1_M2_coeff(:,1), context1_ATL_coeff(:,1)) > 0;
    all_runs_context1_PCA_timecourse_M2=vertcat(all_runs_context1_PCA_timecourse_M2,context1_M2_coeff(:,1));
else
    all_runs_context1_PCA_timecourse_M2=vertcat(all_runs_context1_PCA_timecourse_M2,-(context1_M2_coeff(:,1)));
end
if corr(context1_M3_coeff(:,1), context1_ATL_coeff(:,1)) > 0;
    all_runs_context1_PCA_timecourse_M3=vertcat(all_runs_context1_PCA_timecourse_M3,context1_M3_coeff(:,1));
else
    all_runs_context1_PCA_timecourse_M3=vertcat(all_runs_context1_PCA_timecourse_M3,-(context1_M3_coeff(:,1)));
end
if corr(context2_M1_coeff(:,1), context2_ATL_coeff(:,1)) > 0;
    all_runs_context2_PCA_timecourse_M1=vertcat(all_runs_context2_PCA_timecourse_M1,context2_M1_coeff(:,1));
else
    all_runs_context2_PCA_timecourse_M1=vertcat(all_runs_context2_PCA_timecourse_M1,-(context2_M1_coeff(:,1)));
end
if corr(context2_M2_coeff(:,1), context2_ATL_coeff(:,1)) > 0;
    all_runs_context2_PCA_timecourse_M2=vertcat(all_runs_context2_PCA_timecourse_M2,context2_M2_coeff(:,1));
else
    all_runs_context2_PCA_timecourse_M2=vertcat(all_runs_context2_PCA_timecourse_M2,-(context2_M2_coeff(:,1)));
end
if corr(context2_M3_coeff(:,1), context2_ATL_coeff(:,1)) > 0;
    all_runs_context2_PCA_timecourse_M3=vertcat(all_runs_context2_PCA_timecourse_M3,context2_M3_coeff(:,1));
else
    all_runs_context2_PCA_timecourse_M3=vertcat(all_runs_context2_PCA_timecourse_M3,-(context2_M3_coeff(:,1)));
end


% ROI-VOXEL VERSION!!! - CORR WITH EACH VOXEL AND PUT IN VARIABLE

for unit = 1:12; %as 12 output units

CONTEXT1_HL2_VS_M1_VOXELS(r,unit) = abs(corr(context1_ATL_coeff(:,1), current_run_context1_M1_timecourse(:,unit))); 
CONTEXT1_HL2_VS_M2_VOXELS(r,unit) = abs(corr(context1_ATL_coeff(:,1), current_run_context1_M2_timecourse(:,unit))); 
CONTEXT1_HL2_VS_M3_VOXELS(r,unit) = abs(corr(context1_ATL_coeff(:,1), current_run_context1_M3_timecourse(:,unit))); 
CONTEXT2_HL2_VS_M1_VOXELS(r,unit) = abs(corr(context2_ATL_coeff(:,1), current_run_context2_M1_timecourse(:,unit))); 
CONTEXT2_HL2_VS_M2_VOXELS(r,unit) = abs(corr(context2_ATL_coeff(:,1), current_run_context2_M2_timecourse(:,unit))); 
CONTEXT2_HL2_VS_M3_VOXELS(r,unit) = abs(corr(context2_ATL_coeff(:,1), current_run_context2_M3_timecourse(:,unit))); 

CONTEXT1_HL2_VS_M1_VOXELS_SINGLE_TIME(r,unit) = abs(corr(context1_ATL_coeff_SINGLE_TIME(:,1), current_run_context1_M1_timecourse_SINGLE_TIME(:,unit))); 
CONTEXT1_HL2_VS_M2_VOXELS_SINGLE_TIME(r,unit) = abs(corr(context1_ATL_coeff_SINGLE_TIME(:,1), current_run_context1_M2_timecourse_SINGLE_TIME(:,unit))); 
CONTEXT1_HL2_VS_M3_VOXELS_SINGLE_TIME(r,unit) = abs(corr(context1_ATL_coeff_SINGLE_TIME(:,1), current_run_context1_M3_timecourse_SINGLE_TIME(:,unit))); 
CONTEXT2_HL2_VS_M1_VOXELS_SINGLE_TIME(r,unit) = abs(corr(context2_ATL_coeff_SINGLE_TIME(:,1), current_run_context2_M1_timecourse_SINGLE_TIME(:,unit))); 
CONTEXT2_HL2_VS_M2_VOXELS_SINGLE_TIME(r,unit) = abs(corr(context2_ATL_coeff_SINGLE_TIME(:,1), current_run_context2_M2_timecourse_SINGLE_TIME(:,unit))); 
CONTEXT2_HL2_VS_M3_VOXELS_SINGLE_TIME(r,unit) = abs(corr(context2_ATL_coeff_SINGLE_TIME(:,1), current_run_context2_M3_timecourse_SINGLE_TIME(:,unit))); 


end


end

%CONCAT and set up for t-tests with labels (horzcat diff region combos and context labels,
%vertcat diff contexts) - for stats and averages
temp_labels=ones(length(CONTEXT2_HL2_VS_M1_CONC),1)+ones(length(CONTEXT2_HL2_VS_M1_CONC),1);
HUB_VS_SPOKES_coeff = vertcat(horzcat(ones(length(CONTEXT1_HL2_VS_M1_CONC),1), CONTEXT1_HL2_VS_M1_CONC,CONTEXT1_HL2_VS_M2_CONC,CONTEXT1_HL2_VS_M3_CONC),horzcat(temp_labels, CONTEXT2_HL2_VS_M1_CONC,CONTEXT2_HL2_VS_M2_CONC,CONTEXT2_HL2_VS_M3_CONC));
HL1_VS_SPOKES_OR_HUB_coeff = vertcat(horzcat(ones(length(CONTEXT1_HL1_VS_M1_CONC),1), CONTEXT1_HL1_VS_M1_CONC,CONTEXT1_HL1_VS_M2_CONC,CONTEXT1_HL1_VS_M3_CONC,CONTEXT1_HL2_VS_HL1_CONC),horzcat(temp_labels, CONTEXT2_HL1_VS_M1_CONC,CONTEXT2_HL1_VS_M2_CONC,CONTEXT2_HL1_VS_M3_CONC,CONTEXT2_HL2_VS_HL1_CONC));

% ROI-voxel version - horzcat ATL-diff spokes with labels + %vertcat contexts together
ATL_vs_spokes_by_voxel = vertcat(horzcat(ones(length(CONTEXT1_HL2_VS_M1_CONC),1), CONTEXT1_HL2_VS_M1_VOXELS, CONTEXT1_HL2_VS_M2_VOXELS, CONTEXT1_HL2_VS_M3_VOXELS), horzcat(temp_labels, CONTEXT2_HL2_VS_M1_VOXELS, CONTEXT2_HL2_VS_M2_VOXELS, CONTEXT2_HL2_VS_M3_VOXELS));

%end time only versions
temp_labels_SINGLE_TIME=ones(length(CONTEXT2_HL2_VS_M1_CONC_SINGLE_TIME),1)+ones(length(CONTEXT2_HL2_VS_M1_CONC_SINGLE_TIME),1);
HUB_VS_SPOKES_coeff_SINGLE_TIME = vertcat(horzcat(ones(length(CONTEXT1_HL2_VS_M1_CONC_SINGLE_TIME),1), CONTEXT1_HL2_VS_M1_CONC_SINGLE_TIME,CONTEXT1_HL2_VS_M2_CONC_SINGLE_TIME,CONTEXT1_HL2_VS_M3_CONC_SINGLE_TIME),horzcat(temp_labels_SINGLE_TIME, CONTEXT2_HL2_VS_M1_CONC_SINGLE_TIME,CONTEXT2_HL2_VS_M2_CONC_SINGLE_TIME,CONTEXT2_HL2_VS_M3_CONC_SINGLE_TIME));
HL1_VS_SPOKES_OR_HUB_coeff_SINGLE_TIME = vertcat(horzcat(ones(length(CONTEXT1_HL1_VS_M1_CONC_SINGLE_TIME),1), CONTEXT1_HL1_VS_M1_CONC_SINGLE_TIME,CONTEXT1_HL1_VS_M2_CONC_SINGLE_TIME,CONTEXT1_HL1_VS_M3_CONC_SINGLE_TIME,CONTEXT1_HL2_VS_HL1_CONC_SINGLE_TIME),horzcat(temp_labels_SINGLE_TIME, CONTEXT2_HL1_VS_M1_CONC_SINGLE_TIME,CONTEXT2_HL1_VS_M2_CONC_SINGLE_TIME,CONTEXT2_HL1_VS_M3_CONC_SINGLE_TIME,CONTEXT2_HL2_VS_HL1_CONC_SINGLE_TIME));

ATL_vs_spokes_by_voxel_SINGLE_TIME = vertcat(horzcat(ones(length(CONTEXT1_HL2_VS_M1_CONC_SINGLE_TIME),1), CONTEXT1_HL2_VS_M1_VOXELS_SINGLE_TIME, CONTEXT1_HL2_VS_M2_VOXELS_SINGLE_TIME, CONTEXT1_HL2_VS_M3_VOXELS_SINGLE_TIME), horzcat(temp_labels_SINGLE_TIME, CONTEXT2_HL2_VS_M1_VOXELS_SINGLE_TIME, CONTEXT2_HL2_VS_M2_VOXELS_SINGLE_TIME, CONTEXT2_HL2_VS_M3_VOXELS_SINGLE_TIME));

%combine (flipped) PCA timecourses across regions
context1_PCA_timecourses=horzcat(all_runs_context1_PCA_timecourse_M1, all_runs_context1_PCA_timecourse_M2, all_runs_context1_PCA_timecourse_M3,all_runs_context1_PCA_timecourse_ATL);
context2_PCA_timecourses=horzcat(all_runs_context2_PCA_timecourse_M1,all_runs_context2_PCA_timecourse_M2, all_runs_context2_PCA_timecourse_M3,all_runs_context2_PCA_timecourse_ATL);

save('timecourses_for_contextdependentFC_hubs_spokes_changes_vary_OUTPUT_PCA_per_run')


