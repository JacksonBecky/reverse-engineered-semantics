%% to process 80 model runs from text files to similarity values measuring conceptual abstraction with control
%need 80 models of an architecture with activations saved from LENS in
%current folder
%needs INPUT_MODEL_OUTPUT_CONTROL.m and organise_model_input_control.m in
%filepath
%get STATS_FOR_ANOVA_INPUT_BASED (similarity to example structure in Hidden
%Layer 1 regions if there is no bimodal hub in the architecture), STATS_FOR_ANOVA_6_DIV (same but for architectures with bimodal hubs) and STATS_FOR_ANOVA_HU2 (similarity to example structure in Hidden
%Layer 2) - will be different for 3 example structure types and will
%overwrite each other in the workspace so pull out of saved versions
%for conceptual abstraction want context-independent version i.e. control
%=1. Take average in HL1 and HL2 and whichever is highest is conceptual
%abstraction score.If comparing different architectures, use all the
%values in a statistical test (e.g. ANOVA, t-test).

%FIND AND CHANGE examples directory below if changed where saves to (keep reference
%to each subfolder for each type of control)

%change based on arch ---
%DEEP OR SHALLOW NETWORK
deep = 0;%input('Is the architecture deep?(1=deep, 0=shallow)'); CHANGE BY ARCH DEPTH
%--------

no_runs = 8; %input('How many model runs?(1=10, 2=20, 4=40, 8=80)'); %this version (with control) can only do 80 runs    
control =1;% ONLY WORKS WITH CONTROL - leave as 1
num_ex = 144; %full number of examples * mod of input/output for basic control

%list all variables to loop through - change here for later parts - 'consistency_ouput' v is specific
%to current v's and order but rest of consistency will run 
v_name{1} = 'sim_m1m2_results'; %'old 3 div' - ie. bimodal hubs - ignore
v_name{2} = 'sim_m1m3_results';
v_name{3} = 'sim_m2m3_results';
v_name{4} = 'sim_HUlayer1'; %is full HU1 
v_name{5} = 'sim_m1m2_m1_results'; % 6 divisions of HL1 - coherent regions for ALL ARCHITECTURES WITH BIMODAL HUBS
v_name{6} = 'sim_m1m2_m2_results';
v_name{7} = 'sim_m1m3_m1_results';
v_name{8} = 'sim_m1m3_m3_results';
v_name{9} = 'sim_m2m3_m2_results';
v_name{10} = 'sim_m2m3_m3_results';
v_name{11} = 'sim_IO_results'; %all rep (I/O) level i.e. spokes
v_name{12} = 'sim_m1rep_results'; % each mod in rep (I/O) level i.e. each spoke
v_name{13} = 'sim_m2rep_results';
v_name{14} = 'sim_m3rep_results';
v_name{15} = 'sim_m1_inputs_results'; %'new input-based 3div'  - HU1 split by inputs - is natural division for multimodal architectures, is m1m2 + m1m3 etc.
v_name{16} = 'sim_m2_inputs_results';
v_name{17} = 'sim_m3_inputs_results';

if deep ==1;
    v_name{18} = 'sim_HL2_results'; %HU2
    v_name{19} ='sim_HUlayer1_plus_2_results';  %HU1 and HU2 together
end

%% takes in model runs input from current directory and organises to separate layers final activation values 

% works out filename of model results - only if no other .txt files in folder + has 1 number at end of first
all_files = ls ('*.txt');
root_filename = all_files(1,:);
root_filename =root_filename(1:(length(root_filename)-6));

%get all filenames (assumes root filename than numbered)
for i=1:size(all_files,1);
    all_filenames{i} = strcat(root_filename, num2str(i),'.txt');
end

%loop through all filenames to get results data with function and call it
%resultsdata1 etc then take just final activations, order by examples (not
%just mod) and separate by layer then get sim matrices

for i=1:size(all_files,1);
    current_filename = all_filenames{i};
    [temp_results_data] = INPUT_MODEL_OUTPUT_CONTROL(current_filename, num_ex);
    assignin('base',strcat('results_data', num2str(i)),temp_results_data);
        
    if deep ==1;
        [ final_results_ordered, IO, pairwise, atl,pairs_plus_atl] = organise_model_input_control(temp_results_data, deep, num_ex, control);
        assignin('base',strcat('atl', num2str(i)),atl);
          assignin('base',strcat('pairs_plus_atl', num2str(i)),pairs_plus_atl);
    end
    
    if deep==0;
        [ final_results_ordered, IO, pairwise] = organise_model_input_no_atl_control(temp_results_data, deep , num_ex, control);
    end
    
    assignin('base',strcat('final_results_ordered', num2str(i)),final_results_ordered);
    assignin('base',strcat('IO', num2str(i)),IO);
    assignin('base',strcat('pairwise', num2str(i)),pairwise);
    
    if deep ==1;
    [sim_HUlayer1_plus_2_results,sim_HL2_results,sim_HUlayer1, sim_m2m3_m3_results , sim_m2m3_m2_results, sim_m1m3_m3_results, sim_m1m3_m1_results,sim_m1m2_m2_results,sim_m1m2_m1_results,sim_m2m3_results,sim_m1m3_results,sim_m1m2_results, sim_IO_results,sim_m1rep_results,sim_m2rep_results,sim_m3rep_results, sim_HL2_results_vector,sim_HUlayer1_vector, sim_m2m3_m3_results_vector , sim_m2m3_m2_results_vector, sim_m1m3_m3_results_vector, sim_m1m3_m1_results_vector,sim_m1m2_m2_results_vector,sim_m1m2_m1_results_vector,sim_m2m3_results_vector,sim_m1m3_results_vector,sim_m1m2_results_vector, sim_IO_results_vector,sim_m1rep_results_vector,sim_m2rep_results_vector,sim_m3rep_results_vector,sim_HUlayer1_plus_2_results_vector, sim_m1_inputs_results, sim_m2_inputs_results, sim_m3_inputs_results, sim_m1_inputs_results_vector, sim_m2_inputs_results_vector, sim_m3_inputs_results_vector] = hier_get_sim_matrices_control(pairwise, atl, IO,pairs_plus_atl, num_ex);  
    end 
    if deep==0;
    [sim_HUlayer1, sim_m2m3_m3_results , sim_m2m3_m2_results, sim_m1m3_m3_results, sim_m1m3_m1_results,sim_m1m2_m2_results,sim_m1m2_m1_results,sim_m2m3_results,sim_m1m3_results,sim_m1m2_results, sim_IO_results,sim_m1rep_results,sim_m2rep_results,sim_m3rep_results, sim_m1_inputs_results, sim_m2_inputs_results, sim_m3_inputs_results, sim_HUlayer1_vector, sim_m2m3_m3_results_vector , sim_m2m3_m2_results_vector, sim_m1m3_m3_results_vector, sim_m1m3_m1_results_vector,sim_m1m2_m2_results_vector,sim_m1m2_m1_results_vector,sim_m2m3_results_vector,sim_m1m3_results_vector,sim_m1m2_results_vector, sim_IO_results_vector,sim_m1rep_results_vector,sim_m2rep_results_vector,sim_m3rep_results_vector, sim_m1_inputs_results_vector, sim_m2_inputs_results_vector, sim_m3_inputs_results_vector] = hier_get_sim_matrices_no_atl_control(pairwise, IO, num_ex);  
    end
    
    assignin('base',strcat('sim_IO_results_', num2str(i),'_vector'),sim_IO_results_vector);
    assignin('base',strcat('sim_m1rep_results_', num2str(i),'_vector'),sim_m1rep_results_vector);
    assignin('base',strcat('sim_m2rep_results_', num2str(i),'_vector'),sim_m2rep_results_vector);
    assignin('base',strcat('sim_m3rep_results_', num2str(i),'_vector'),sim_m3rep_results_vector);
    assignin('base',strcat('sim_IO_results_', num2str(i)),sim_IO_results);
    assignin('base',strcat('sim_m1rep_results_', num2str(i)),sim_m1rep_results);
    assignin('base',strcat('sim_m2rep_results_', num2str(i)),sim_m2rep_results);
    assignin('base',strcat('sim_m3rep_results_', num2str(i)),sim_m3rep_results);   
    assignin('base',strcat('sim_HUlayer1_', num2str(i)),sim_HUlayer1);
    assignin('base',strcat('sim_m2m3_m3_results_', num2str(i)),sim_m2m3_m3_results);
    assignin('base',strcat('sim_m2m3_m2_results_', num2str(i)),sim_m2m3_m2_results);
    assignin('base',strcat('sim_m1m3_m3_results_', num2str(i)),sim_m1m3_m3_results);
    assignin('base',strcat('sim_m1m3_m1_results_', num2str(i)),sim_m1m3_m1_results);
    assignin('base',strcat('sim_m1m2_m2_results_', num2str(i)),sim_m1m2_m2_results);
    assignin('base',strcat('sim_m1m2_m1_results_', num2str(i)),sim_m1m2_m1_results);
    assignin('base',strcat('sim_m2m3_results_', num2str(i)),sim_m2m3_results);
    assignin('base',strcat('sim_m1m3_results_', num2str(i)),sim_m1m3_results);
    assignin('base',strcat('sim_m1m2_results_', num2str(i)),sim_m1m2_results);
    assignin('base',strcat('sim_HUlayer1_', num2str(i),'_vector'),sim_HUlayer1_vector);
    assignin('base',strcat('sim_m2m3_m3_results_', num2str(i),'_vector'),sim_m2m3_m3_results_vector);
    assignin('base',strcat('sim_m2m3_m2_results_', num2str(i),'_vector'),sim_m2m3_m2_results_vector);
    assignin('base',strcat('sim_m1m3_m3_results_', num2str(i),'_vector'),sim_m1m3_m3_results_vector);
    assignin('base',strcat('sim_m1m3_m1_results_', num2str(i),'_vector'),sim_m1m3_m1_results_vector);
    assignin('base',strcat('sim_m1m2_m2_results_', num2str(i),'_vector'),sim_m1m2_m2_results_vector);
    assignin('base',strcat('sim_m1m2_m1_results_', num2str(i),'_vector'),sim_m1m2_m1_results_vector);
    assignin('base',strcat('sim_m2m3_results_', num2str(i),'_vector'),sim_m2m3_results_vector);
    assignin('base',strcat('sim_m1m3_results_', num2str(i),'_vector'),sim_m1m3_results_vector);
    assignin('base',strcat('sim_m1m2_results_', num2str(i),'_vector'),sim_m1m2_results_vector);
         assignin('base',strcat('sim_m1_inputs_results_', num2str(i)),sim_m1_inputs_results);
        assignin('base',strcat('sim_m1_inputs_results_', num2str(i),'_vector'),sim_m1_inputs_results_vector);
        assignin('base',strcat('sim_m2_inputs_results_', num2str(i)),sim_m2_inputs_results);
        assignin('base',strcat('sim_m2_inputs_results_', num2str(i),'_vector'),sim_m2_inputs_results_vector);
        assignin('base',strcat('sim_m3_inputs_results_', num2str(i)),sim_m3_inputs_results);
        assignin('base',strcat('sim_m3_inputs_results_', num2str(i),'_vector'),sim_m3_inputs_results_vector);  
        
    if deep ==1;
        assignin('base',strcat('sim_HL2_results_', num2str(i),'_vector'),sim_HL2_results_vector);
        assignin('base',strcat('sim_HL2_results_', num2str(i)),sim_HL2_results);
        assignin('base',strcat('sim_HUlayer1_plus_2_results_', num2str(i),'_vector'),sim_HUlayer1_plus_2_results_vector);
        assignin('base',strcat('sim_HUlayer1_plus_2_results_', num2str(i)),sim_HUlayer1_plus_2_results);
    end

    end  
%% for all variables listed (where the sim matrices are given) - loops through to get average and leave one out consistency measure- CHANGE IF DIFF NO RUNS
% averages over runs of model + gets vectors from matrices to compare
% similarity between matrices - made so NO vectors include diagonal any more

%go to results directory (so figures don't overwrite) - % figs overwrite but same anyway so fine
% if control >0.5;
%     mkdir(results_folder);
%     cd(results_folder);
% end

%uses list of all variables at startto loop through
%loop through each variable = i

%for 80 runs
if no_runs ==8; %80 model runs
    

    for i = 1:length(v_name);
    
    current_v_name = v_name{i};
    
    
    %for current variable- gets the diff versions of it, r = run
        for r=1:size(all_files,1);
        all_vs{r} = strcat(current_v_name,'_', num2str(r));
        end  

    %WON'T WORK WITH NO. MODELS OTHER THAN 80 FROM HERE - just this section
    %- change it for each number (is because can't input eval of vraiables
    %in loop to function)
    
   % [temp_AV_matrix, temp_AV_sim_vector] =  MAKE_AV_SIM_MATRIX_any_number(eval(all_vs{1:r})); %can't make work - have to use specific number of runs still?
    
    [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{1}),eval(all_vs{2}), eval(all_vs{3}), eval(all_vs{4}), eval(all_vs{5}), eval(all_vs{6}), eval(all_vs{7}), eval(all_vs{8}), eval(all_vs{9}), eval(all_vs{10}),eval(all_vs{11}),eval(all_vs{12}), eval(all_vs{13}), eval(all_vs{14}), eval(all_vs{15}), eval(all_vs{16}), eval(all_vs{17}), eval(all_vs{18}), eval(all_vs{19}), eval(all_vs{20}),eval(all_vs{21}), eval(all_vs{22}), eval(all_vs{23}), eval(all_vs{24}), eval(all_vs{25}), eval(all_vs{26}), eval(all_vs{27}), eval(all_vs{28}), eval(all_vs{29}), eval(all_vs{30}),eval(all_vs{31}),eval(all_vs{32}), eval(all_vs{33}), eval(all_vs{34}), eval(all_vs{35}), eval(all_vs{36}), eval(all_vs{37}), eval(all_vs{38}), eval(all_vs{39}), eval(all_vs{40}), eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{80}), num_ex);%- change for each number of runs
    assignin('base',strcat('AV_',current_v_name), temp_AV_matrix);
    assignin('base',strcat('AV_',current_v_name,'_vector'), temp_AV_sim_vector);
        
    %save fig of average
    current_av_variable_name = eval(strcat('AV_',current_v_name));
    fig1=imagesc(current_av_variable_name);
    colorbar;
    saveas (fig1, strcat('AV_',current_v_name,'correlation.tif'));
    
    %get leave one out av sim matrix for 20 runs of model for current
    %variable   %- change for each number of runs
    [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{2}), eval(all_vs{3}), eval(all_vs{4}), eval(all_vs{5}), eval(all_vs{6}), eval(all_vs{7}), eval(all_vs{8}), eval(all_vs{9}), eval(all_vs{10}),eval(all_vs{11}),eval(all_vs{12}), eval(all_vs{13}), eval(all_vs{14}), eval(all_vs{15}), eval(all_vs{16}), eval(all_vs{17}), eval(all_vs{18}), eval(all_vs{19}), eval(all_vs{20}),eval(all_vs{21}),eval(all_vs{22}), eval(all_vs{23}), eval(all_vs{24}), eval(all_vs{25}), eval(all_vs{26}), eval(all_vs{27}), eval(all_vs{28}), eval(all_vs{29}), eval(all_vs{30}),eval(all_vs{31}),eval(all_vs{32}), eval(all_vs{33}), eval(all_vs{34}), eval(all_vs{35}), eval(all_vs{36}), eval(all_vs{37}), eval(all_vs{38}), eval(all_vs{39}), eval(all_vs{40}), eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_1'), temp_AV_matrix);
    assignin('base',strcat('AV_',current_v_name,'_leave_out_1_vector'), temp_AV_sim_vector);
    
    [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{1}), eval(all_vs{3}), eval(all_vs{4}), eval(all_vs{5}), eval(all_vs{6}), eval(all_vs{7}), eval(all_vs{8}), eval(all_vs{9}), eval(all_vs{10}),eval(all_vs{11}),eval(all_vs{12}), eval(all_vs{13}), eval(all_vs{14}), eval(all_vs{15}), eval(all_vs{16}), eval(all_vs{17}), eval(all_vs{18}), eval(all_vs{19}), eval(all_vs{20}),eval(all_vs{21}),eval(all_vs{22}), eval(all_vs{23}), eval(all_vs{24}), eval(all_vs{25}), eval(all_vs{26}), eval(all_vs{27}), eval(all_vs{28}), eval(all_vs{29}), eval(all_vs{30}),eval(all_vs{31}),eval(all_vs{32}), eval(all_vs{33}), eval(all_vs{34}), eval(all_vs{35}), eval(all_vs{36}), eval(all_vs{37}), eval(all_vs{38}), eval(all_vs{39}), eval(all_vs{40}), eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_2'), temp_AV_matrix);
    assignin('base',strcat('AV_',current_v_name,'_leave_out_2_vector'), temp_AV_sim_vector);
    
    [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{2}), eval(all_vs{1}), eval(all_vs{4}), eval(all_vs{5}), eval(all_vs{6}), eval(all_vs{7}), eval(all_vs{8}), eval(all_vs{9}), eval(all_vs{10}),eval(all_vs{11}),eval(all_vs{12}), eval(all_vs{13}), eval(all_vs{14}), eval(all_vs{15}), eval(all_vs{16}), eval(all_vs{17}), eval(all_vs{18}), eval(all_vs{19}), eval(all_vs{20}),eval(all_vs{21}),eval(all_vs{22}), eval(all_vs{23}), eval(all_vs{24}), eval(all_vs{25}), eval(all_vs{26}), eval(all_vs{27}), eval(all_vs{28}), eval(all_vs{29}), eval(all_vs{30}),eval(all_vs{31}),eval(all_vs{32}), eval(all_vs{33}), eval(all_vs{34}), eval(all_vs{35}), eval(all_vs{36}), eval(all_vs{37}), eval(all_vs{38}), eval(all_vs{39}), eval(all_vs{40}),eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_3'), temp_AV_matrix);
    assignin('base',strcat('AV_',current_v_name,'_leave_out_3_vector'), temp_AV_sim_vector);
    
    [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{2}), eval(all_vs{3}), eval(all_vs{1}), eval(all_vs{5}), eval(all_vs{6}), eval(all_vs{7}), eval(all_vs{8}), eval(all_vs{9}), eval(all_vs{10}),eval(all_vs{11}),eval(all_vs{12}), eval(all_vs{13}), eval(all_vs{14}), eval(all_vs{15}), eval(all_vs{16}), eval(all_vs{17}), eval(all_vs{18}), eval(all_vs{19}), eval(all_vs{20}),eval(all_vs{21}),eval(all_vs{22}), eval(all_vs{23}), eval(all_vs{24}), eval(all_vs{25}), eval(all_vs{26}), eval(all_vs{27}), eval(all_vs{28}), eval(all_vs{29}), eval(all_vs{30}),eval(all_vs{31}),eval(all_vs{32}), eval(all_vs{33}), eval(all_vs{34}), eval(all_vs{35}), eval(all_vs{36}), eval(all_vs{37}), eval(all_vs{38}), eval(all_vs{39}), eval(all_vs{40}),eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_4'), temp_AV_matrix);
    assignin('base',strcat('AV_',current_v_name,'_leave_out_4_vector'), temp_AV_sim_vector);
     
    [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{2}), eval(all_vs{3}), eval(all_vs{4}), eval(all_vs{1}), eval(all_vs{6}), eval(all_vs{7}), eval(all_vs{8}), eval(all_vs{9}), eval(all_vs{10}),eval(all_vs{11}),eval(all_vs{12}), eval(all_vs{13}), eval(all_vs{14}), eval(all_vs{15}), eval(all_vs{16}), eval(all_vs{17}), eval(all_vs{18}), eval(all_vs{19}), eval(all_vs{20}),eval(all_vs{21}),eval(all_vs{22}), eval(all_vs{23}), eval(all_vs{24}), eval(all_vs{25}), eval(all_vs{26}), eval(all_vs{27}), eval(all_vs{28}), eval(all_vs{29}), eval(all_vs{30}),eval(all_vs{31}),eval(all_vs{32}), eval(all_vs{33}), eval(all_vs{34}), eval(all_vs{35}), eval(all_vs{36}), eval(all_vs{37}), eval(all_vs{38}), eval(all_vs{39}), eval(all_vs{40}),eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_5'), temp_AV_matrix);
    assignin('base',strcat('AV_',current_v_name,'_leave_out_5_vector'), temp_AV_sim_vector);
    
    [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{2}), eval(all_vs{3}), eval(all_vs{4}), eval(all_vs{5}), eval(all_vs{1}), eval(all_vs{7}), eval(all_vs{8}), eval(all_vs{9}), eval(all_vs{10}),eval(all_vs{11}),eval(all_vs{12}), eval(all_vs{13}), eval(all_vs{14}), eval(all_vs{15}), eval(all_vs{16}), eval(all_vs{17}), eval(all_vs{18}), eval(all_vs{19}), eval(all_vs{20}),eval(all_vs{21}),eval(all_vs{22}), eval(all_vs{23}), eval(all_vs{24}), eval(all_vs{25}), eval(all_vs{26}), eval(all_vs{27}), eval(all_vs{28}), eval(all_vs{29}), eval(all_vs{30}),eval(all_vs{31}),eval(all_vs{32}), eval(all_vs{33}), eval(all_vs{34}), eval(all_vs{35}), eval(all_vs{36}), eval(all_vs{37}), eval(all_vs{38}), eval(all_vs{39}), eval(all_vs{40}),eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_6'), temp_AV_matrix);
    assignin('base',strcat('AV_',current_v_name,'_leave_out_6_vector'), temp_AV_sim_vector);
    
    [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{2}), eval(all_vs{3}), eval(all_vs{4}), eval(all_vs{5}), eval(all_vs{6}), eval(all_vs{1}), eval(all_vs{8}), eval(all_vs{9}), eval(all_vs{10}),eval(all_vs{11}),eval(all_vs{12}), eval(all_vs{13}), eval(all_vs{14}), eval(all_vs{15}), eval(all_vs{16}), eval(all_vs{17}), eval(all_vs{18}), eval(all_vs{19}), eval(all_vs{20}),eval(all_vs{21}),eval(all_vs{22}), eval(all_vs{23}), eval(all_vs{24}), eval(all_vs{25}), eval(all_vs{26}), eval(all_vs{27}), eval(all_vs{28}), eval(all_vs{29}), eval(all_vs{30}),eval(all_vs{31}),eval(all_vs{32}), eval(all_vs{33}), eval(all_vs{34}), eval(all_vs{35}), eval(all_vs{36}), eval(all_vs{37}), eval(all_vs{38}), eval(all_vs{39}), eval(all_vs{40}),eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_7'), temp_AV_matrix);
    assignin('base',strcat('AV_',current_v_name,'_leave_out_7_vector'), temp_AV_sim_vector);
    
    [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{2}), eval(all_vs{3}), eval(all_vs{4}), eval(all_vs{5}), eval(all_vs{6}), eval(all_vs{7}), eval(all_vs{1}), eval(all_vs{9}), eval(all_vs{10}),eval(all_vs{11}),eval(all_vs{12}), eval(all_vs{13}), eval(all_vs{14}), eval(all_vs{15}), eval(all_vs{16}), eval(all_vs{17}), eval(all_vs{18}), eval(all_vs{19}), eval(all_vs{20}),eval(all_vs{21}),eval(all_vs{22}), eval(all_vs{23}), eval(all_vs{24}), eval(all_vs{25}), eval(all_vs{26}), eval(all_vs{27}), eval(all_vs{28}), eval(all_vs{29}), eval(all_vs{30}),eval(all_vs{31}),eval(all_vs{32}), eval(all_vs{33}), eval(all_vs{34}), eval(all_vs{35}), eval(all_vs{36}), eval(all_vs{37}), eval(all_vs{38}), eval(all_vs{39}), eval(all_vs{40}),eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_8'), temp_AV_matrix);
    assignin('base',strcat('AV_',current_v_name,'_leave_out_8_vector'), temp_AV_sim_vector);
    
    [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{2}), eval(all_vs{3}), eval(all_vs{4}), eval(all_vs{5}), eval(all_vs{6}), eval(all_vs{7}), eval(all_vs{8}), eval(all_vs{1}), eval(all_vs{10}),eval(all_vs{11}),eval(all_vs{12}), eval(all_vs{13}), eval(all_vs{14}), eval(all_vs{15}), eval(all_vs{16}), eval(all_vs{17}), eval(all_vs{18}), eval(all_vs{19}), eval(all_vs{20}),eval(all_vs{21}),eval(all_vs{22}), eval(all_vs{23}), eval(all_vs{24}), eval(all_vs{25}), eval(all_vs{26}), eval(all_vs{27}), eval(all_vs{28}), eval(all_vs{29}), eval(all_vs{30}),eval(all_vs{31}),eval(all_vs{32}), eval(all_vs{33}), eval(all_vs{34}), eval(all_vs{35}), eval(all_vs{36}), eval(all_vs{37}), eval(all_vs{38}), eval(all_vs{39}), eval(all_vs{40}),eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_9'), temp_AV_matrix);
    assignin('base',strcat('AV_',current_v_name,'_leave_out_9_vector'), temp_AV_sim_vector);
    
    [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{2}), eval(all_vs{3}), eval(all_vs{4}), eval(all_vs{5}), eval(all_vs{6}), eval(all_vs{7}), eval(all_vs{8}), eval(all_vs{9}), eval(all_vs{1}),eval(all_vs{11}),eval(all_vs{12}), eval(all_vs{13}), eval(all_vs{14}), eval(all_vs{15}), eval(all_vs{16}), eval(all_vs{17}), eval(all_vs{18}), eval(all_vs{19}), eval(all_vs{20}),eval(all_vs{21}),eval(all_vs{22}), eval(all_vs{23}), eval(all_vs{24}), eval(all_vs{25}), eval(all_vs{26}), eval(all_vs{27}), eval(all_vs{28}), eval(all_vs{29}), eval(all_vs{30}),eval(all_vs{31}),eval(all_vs{32}), eval(all_vs{33}), eval(all_vs{34}), eval(all_vs{35}), eval(all_vs{36}), eval(all_vs{37}), eval(all_vs{38}), eval(all_vs{39}), eval(all_vs{40}),eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_10'), temp_AV_matrix); 
    assignin('base',strcat('AV_',current_v_name,'_leave_out_10_vector'), temp_AV_sim_vector);
    
    [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{2}), eval(all_vs{3}), eval(all_vs{4}), eval(all_vs{5}), eval(all_vs{6}), eval(all_vs{7}), eval(all_vs{8}), eval(all_vs{9}), eval(all_vs{1}),eval(all_vs{10}),eval(all_vs{12}), eval(all_vs{13}), eval(all_vs{14}), eval(all_vs{15}), eval(all_vs{16}), eval(all_vs{17}), eval(all_vs{18}), eval(all_vs{19}), eval(all_vs{20}),eval(all_vs{21}),eval(all_vs{22}), eval(all_vs{23}), eval(all_vs{24}), eval(all_vs{25}), eval(all_vs{26}), eval(all_vs{27}), eval(all_vs{28}), eval(all_vs{29}), eval(all_vs{30}),eval(all_vs{31}),eval(all_vs{32}), eval(all_vs{33}), eval(all_vs{34}), eval(all_vs{35}), eval(all_vs{36}), eval(all_vs{37}), eval(all_vs{38}), eval(all_vs{39}), eval(all_vs{40}),eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_11'), temp_AV_matrix); 
    assignin('base',strcat('AV_',current_v_name,'_leave_out_11_vector'), temp_AV_sim_vector);  
    
        [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{2}), eval(all_vs{3}), eval(all_vs{4}), eval(all_vs{5}), eval(all_vs{6}), eval(all_vs{7}), eval(all_vs{8}), eval(all_vs{9}), eval(all_vs{1}),eval(all_vs{11}),eval(all_vs{10}), eval(all_vs{13}), eval(all_vs{14}), eval(all_vs{15}), eval(all_vs{16}), eval(all_vs{17}), eval(all_vs{18}), eval(all_vs{19}), eval(all_vs{20}),eval(all_vs{21}),eval(all_vs{22}), eval(all_vs{23}), eval(all_vs{24}), eval(all_vs{25}), eval(all_vs{26}), eval(all_vs{27}), eval(all_vs{28}), eval(all_vs{29}), eval(all_vs{30}),eval(all_vs{31}),eval(all_vs{32}), eval(all_vs{33}), eval(all_vs{34}), eval(all_vs{35}), eval(all_vs{36}), eval(all_vs{37}), eval(all_vs{38}), eval(all_vs{39}), eval(all_vs{40}),eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_12'), temp_AV_matrix); 
    assignin('base',strcat('AV_',current_v_name,'_leave_out_12_vector'), temp_AV_sim_vector);  
    
        [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{2}), eval(all_vs{3}), eval(all_vs{4}), eval(all_vs{5}), eval(all_vs{6}), eval(all_vs{7}), eval(all_vs{8}), eval(all_vs{9}), eval(all_vs{1}),eval(all_vs{11}),eval(all_vs{12}), eval(all_vs{10}), eval(all_vs{14}), eval(all_vs{15}), eval(all_vs{16}), eval(all_vs{17}), eval(all_vs{18}), eval(all_vs{19}), eval(all_vs{20}),eval(all_vs{21}), eval(all_vs{22}), eval(all_vs{23}), eval(all_vs{24}), eval(all_vs{25}), eval(all_vs{26}), eval(all_vs{27}), eval(all_vs{28}), eval(all_vs{29}), eval(all_vs{30}),eval(all_vs{31}),eval(all_vs{32}), eval(all_vs{33}), eval(all_vs{34}), eval(all_vs{35}), eval(all_vs{36}), eval(all_vs{37}), eval(all_vs{38}), eval(all_vs{39}), eval(all_vs{40}),eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_13'), temp_AV_matrix); 
    assignin('base',strcat('AV_',current_v_name,'_leave_out_13_vector'), temp_AV_sim_vector);  
    
        [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{2}), eval(all_vs{3}), eval(all_vs{4}), eval(all_vs{5}), eval(all_vs{6}), eval(all_vs{7}), eval(all_vs{8}), eval(all_vs{9}), eval(all_vs{1}),eval(all_vs{11}),eval(all_vs{12}), eval(all_vs{13}), eval(all_vs{10}), eval(all_vs{15}), eval(all_vs{16}), eval(all_vs{17}), eval(all_vs{18}), eval(all_vs{19}), eval(all_vs{20}),eval(all_vs{21}),eval(all_vs{22}), eval(all_vs{23}), eval(all_vs{24}), eval(all_vs{25}), eval(all_vs{26}), eval(all_vs{27}), eval(all_vs{28}), eval(all_vs{29}), eval(all_vs{30}),eval(all_vs{31}),eval(all_vs{32}), eval(all_vs{33}), eval(all_vs{34}), eval(all_vs{35}), eval(all_vs{36}), eval(all_vs{37}), eval(all_vs{38}), eval(all_vs{39}), eval(all_vs{40}),eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_14'), temp_AV_matrix); 
    assignin('base',strcat('AV_',current_v_name,'_leave_out_14_vector'), temp_AV_sim_vector);  
    
        [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{2}), eval(all_vs{3}), eval(all_vs{4}), eval(all_vs{5}), eval(all_vs{6}), eval(all_vs{7}), eval(all_vs{8}), eval(all_vs{9}), eval(all_vs{1}),eval(all_vs{11}),eval(all_vs{12}), eval(all_vs{13}), eval(all_vs{14}), eval(all_vs{10}), eval(all_vs{16}), eval(all_vs{17}), eval(all_vs{18}), eval(all_vs{19}), eval(all_vs{20}),eval(all_vs{21}),eval(all_vs{22}), eval(all_vs{23}), eval(all_vs{24}), eval(all_vs{25}), eval(all_vs{26}), eval(all_vs{27}), eval(all_vs{28}), eval(all_vs{29}), eval(all_vs{30}),eval(all_vs{31}),eval(all_vs{32}), eval(all_vs{33}), eval(all_vs{34}), eval(all_vs{35}), eval(all_vs{36}), eval(all_vs{37}), eval(all_vs{38}), eval(all_vs{39}), eval(all_vs{40}),eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_15'), temp_AV_matrix); 
    assignin('base',strcat('AV_',current_v_name,'_leave_out_15_vector'), temp_AV_sim_vector);  
    
        [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{2}), eval(all_vs{3}), eval(all_vs{4}), eval(all_vs{5}), eval(all_vs{6}), eval(all_vs{7}), eval(all_vs{8}), eval(all_vs{9}), eval(all_vs{1}),eval(all_vs{11}),eval(all_vs{12}), eval(all_vs{13}), eval(all_vs{14}), eval(all_vs{15}), eval(all_vs{10}), eval(all_vs{17}), eval(all_vs{18}), eval(all_vs{19}), eval(all_vs{20}),eval(all_vs{21}),eval(all_vs{22}), eval(all_vs{23}), eval(all_vs{24}), eval(all_vs{25}), eval(all_vs{26}), eval(all_vs{27}), eval(all_vs{28}), eval(all_vs{29}), eval(all_vs{30}),eval(all_vs{31}),eval(all_vs{32}), eval(all_vs{33}), eval(all_vs{34}), eval(all_vs{35}), eval(all_vs{36}), eval(all_vs{37}), eval(all_vs{38}), eval(all_vs{39}), eval(all_vs{40}),eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_16'), temp_AV_matrix); 
    assignin('base',strcat('AV_',current_v_name,'_leave_out_16_vector'), temp_AV_sim_vector);
        [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{2}), eval(all_vs{3}), eval(all_vs{4}), eval(all_vs{5}), eval(all_vs{6}), eval(all_vs{7}), eval(all_vs{8}), eval(all_vs{9}), eval(all_vs{1}),eval(all_vs{11}),eval(all_vs{12}), eval(all_vs{13}), eval(all_vs{14}), eval(all_vs{15}), eval(all_vs{16}), eval(all_vs{10}), eval(all_vs{18}), eval(all_vs{19}), eval(all_vs{20}),eval(all_vs{21}),eval(all_vs{22}), eval(all_vs{23}), eval(all_vs{24}), eval(all_vs{25}), eval(all_vs{26}), eval(all_vs{27}), eval(all_vs{28}), eval(all_vs{29}), eval(all_vs{30}),eval(all_vs{31}),eval(all_vs{32}), eval(all_vs{33}), eval(all_vs{34}), eval(all_vs{35}), eval(all_vs{36}), eval(all_vs{37}), eval(all_vs{38}), eval(all_vs{39}), eval(all_vs{40}),eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_17'), temp_AV_matrix); 
    assignin('base',strcat('AV_',current_v_name,'_leave_out_17_vector'), temp_AV_sim_vector);
        [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{2}), eval(all_vs{3}), eval(all_vs{4}), eval(all_vs{5}), eval(all_vs{6}), eval(all_vs{7}), eval(all_vs{8}), eval(all_vs{9}), eval(all_vs{1}),eval(all_vs{11}),eval(all_vs{12}), eval(all_vs{13}), eval(all_vs{14}), eval(all_vs{15}), eval(all_vs{16}), eval(all_vs{17}), eval(all_vs{10}), eval(all_vs{19}), eval(all_vs{20}),eval(all_vs{21}),eval(all_vs{22}), eval(all_vs{23}), eval(all_vs{24}), eval(all_vs{25}), eval(all_vs{26}), eval(all_vs{27}), eval(all_vs{28}), eval(all_vs{29}), eval(all_vs{30}),eval(all_vs{31}),eval(all_vs{32}), eval(all_vs{33}), eval(all_vs{34}), eval(all_vs{35}), eval(all_vs{36}), eval(all_vs{37}), eval(all_vs{38}), eval(all_vs{39}), eval(all_vs{40}),eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_18'), temp_AV_matrix); 
    assignin('base',strcat('AV_',current_v_name,'_leave_out_18_vector'), temp_AV_sim_vector);
        [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{2}), eval(all_vs{3}), eval(all_vs{4}), eval(all_vs{5}), eval(all_vs{6}), eval(all_vs{7}), eval(all_vs{8}), eval(all_vs{9}), eval(all_vs{1}),eval(all_vs{11}),eval(all_vs{12}), eval(all_vs{13}), eval(all_vs{14}), eval(all_vs{15}), eval(all_vs{16}), eval(all_vs{17}), eval(all_vs{18}), eval(all_vs{10}), eval(all_vs{20}),eval(all_vs{21}),eval(all_vs{22}), eval(all_vs{23}), eval(all_vs{24}), eval(all_vs{25}), eval(all_vs{26}), eval(all_vs{27}), eval(all_vs{28}), eval(all_vs{29}), eval(all_vs{30}),eval(all_vs{31}),eval(all_vs{32}), eval(all_vs{33}), eval(all_vs{34}), eval(all_vs{35}), eval(all_vs{36}), eval(all_vs{37}), eval(all_vs{38}), eval(all_vs{39}), eval(all_vs{40}),eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_19'), temp_AV_matrix); 
    assignin('base',strcat('AV_',current_v_name,'_leave_out_19_vector'), temp_AV_sim_vector);
        [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{2}), eval(all_vs{3}), eval(all_vs{4}), eval(all_vs{5}), eval(all_vs{6}), eval(all_vs{7}), eval(all_vs{8}), eval(all_vs{9}), eval(all_vs{1}),eval(all_vs{11}),eval(all_vs{12}), eval(all_vs{13}), eval(all_vs{14}), eval(all_vs{15}), eval(all_vs{16}), eval(all_vs{17}), eval(all_vs{18}), eval(all_vs{19}), eval(all_vs{10}),eval(all_vs{21}),eval(all_vs{22}), eval(all_vs{23}), eval(all_vs{24}), eval(all_vs{25}), eval(all_vs{26}), eval(all_vs{27}), eval(all_vs{28}), eval(all_vs{29}), eval(all_vs{30}),eval(all_vs{31}),eval(all_vs{32}), eval(all_vs{33}), eval(all_vs{34}), eval(all_vs{35}), eval(all_vs{36}), eval(all_vs{37}), eval(all_vs{38}), eval(all_vs{39}), eval(all_vs{40}),eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_20'), temp_AV_matrix); 
    assignin('base',strcat('AV_',current_v_name,'_leave_out_20_vector'), temp_AV_sim_vector); 
            [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{2}), eval(all_vs{3}), eval(all_vs{4}), eval(all_vs{5}), eval(all_vs{6}), eval(all_vs{7}), eval(all_vs{8}), eval(all_vs{9}), eval(all_vs{1}),eval(all_vs{11}),eval(all_vs{12}), eval(all_vs{13}), eval(all_vs{14}), eval(all_vs{15}), eval(all_vs{16}), eval(all_vs{17}), eval(all_vs{18}), eval(all_vs{19}), eval(all_vs{10}),eval(all_vs{20}),eval(all_vs{22}), eval(all_vs{23}), eval(all_vs{24}), eval(all_vs{25}), eval(all_vs{26}), eval(all_vs{27}), eval(all_vs{28}), eval(all_vs{29}), eval(all_vs{30}),eval(all_vs{31}),eval(all_vs{32}), eval(all_vs{33}), eval(all_vs{34}), eval(all_vs{35}), eval(all_vs{36}), eval(all_vs{37}), eval(all_vs{38}), eval(all_vs{39}), eval(all_vs{40}),eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_21'), temp_AV_matrix); 
    assignin('base',strcat('AV_',current_v_name,'_leave_out_21_vector'), temp_AV_sim_vector); 
            [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{2}), eval(all_vs{3}), eval(all_vs{4}), eval(all_vs{5}), eval(all_vs{6}), eval(all_vs{7}), eval(all_vs{8}), eval(all_vs{9}), eval(all_vs{1}),eval(all_vs{11}),eval(all_vs{12}), eval(all_vs{13}), eval(all_vs{14}), eval(all_vs{15}), eval(all_vs{16}), eval(all_vs{17}), eval(all_vs{18}), eval(all_vs{19}), eval(all_vs{10}),eval(all_vs{21}),eval(all_vs{20}), eval(all_vs{23}), eval(all_vs{24}), eval(all_vs{25}), eval(all_vs{26}), eval(all_vs{27}), eval(all_vs{28}), eval(all_vs{29}), eval(all_vs{30}),eval(all_vs{31}),eval(all_vs{32}), eval(all_vs{33}), eval(all_vs{34}), eval(all_vs{35}), eval(all_vs{36}), eval(all_vs{37}), eval(all_vs{38}), eval(all_vs{39}), eval(all_vs{40}),eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_22'), temp_AV_matrix); 
    assignin('base',strcat('AV_',current_v_name,'_leave_out_22_vector'), temp_AV_sim_vector); 
            [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{2}), eval(all_vs{3}), eval(all_vs{4}), eval(all_vs{5}), eval(all_vs{6}), eval(all_vs{7}), eval(all_vs{8}), eval(all_vs{9}), eval(all_vs{1}),eval(all_vs{11}),eval(all_vs{12}), eval(all_vs{13}), eval(all_vs{14}), eval(all_vs{15}), eval(all_vs{16}), eval(all_vs{17}), eval(all_vs{18}), eval(all_vs{19}), eval(all_vs{10}),eval(all_vs{21}),eval(all_vs{22}), eval(all_vs{20}), eval(all_vs{24}), eval(all_vs{25}), eval(all_vs{26}), eval(all_vs{27}), eval(all_vs{28}), eval(all_vs{29}), eval(all_vs{30}),eval(all_vs{31}),eval(all_vs{32}), eval(all_vs{33}), eval(all_vs{34}), eval(all_vs{35}), eval(all_vs{36}), eval(all_vs{37}), eval(all_vs{38}), eval(all_vs{39}), eval(all_vs{40}),eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_23'), temp_AV_matrix); 
    assignin('base',strcat('AV_',current_v_name,'_leave_out_23_vector'), temp_AV_sim_vector); 
            [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{2}), eval(all_vs{3}), eval(all_vs{4}), eval(all_vs{5}), eval(all_vs{6}), eval(all_vs{7}), eval(all_vs{8}), eval(all_vs{9}), eval(all_vs{1}),eval(all_vs{11}),eval(all_vs{12}), eval(all_vs{13}), eval(all_vs{14}), eval(all_vs{15}), eval(all_vs{16}), eval(all_vs{17}), eval(all_vs{18}), eval(all_vs{19}), eval(all_vs{10}),eval(all_vs{21}),eval(all_vs{22}), eval(all_vs{23}), eval(all_vs{20}), eval(all_vs{25}), eval(all_vs{26}), eval(all_vs{27}), eval(all_vs{28}), eval(all_vs{29}), eval(all_vs{30}),eval(all_vs{31}),eval(all_vs{32}), eval(all_vs{33}), eval(all_vs{34}), eval(all_vs{35}), eval(all_vs{36}), eval(all_vs{37}), eval(all_vs{38}), eval(all_vs{39}), eval(all_vs{40}),eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_24'), temp_AV_matrix); 
    assignin('base',strcat('AV_',current_v_name,'_leave_out_24_vector'), temp_AV_sim_vector); 
            [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{2}), eval(all_vs{3}), eval(all_vs{4}), eval(all_vs{5}), eval(all_vs{6}), eval(all_vs{7}), eval(all_vs{8}), eval(all_vs{9}), eval(all_vs{1}),eval(all_vs{11}),eval(all_vs{12}), eval(all_vs{13}), eval(all_vs{14}), eval(all_vs{15}), eval(all_vs{16}), eval(all_vs{17}), eval(all_vs{18}), eval(all_vs{19}), eval(all_vs{10}),eval(all_vs{21}),eval(all_vs{22}), eval(all_vs{23}), eval(all_vs{24}), eval(all_vs{20}), eval(all_vs{26}), eval(all_vs{27}), eval(all_vs{28}), eval(all_vs{29}), eval(all_vs{30}),eval(all_vs{31}),eval(all_vs{32}), eval(all_vs{33}), eval(all_vs{34}), eval(all_vs{35}), eval(all_vs{36}), eval(all_vs{37}), eval(all_vs{38}), eval(all_vs{39}), eval(all_vs{40}),eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_25'), temp_AV_matrix); 
    assignin('base',strcat('AV_',current_v_name,'_leave_out_25_vector'), temp_AV_sim_vector); 
            [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{2}), eval(all_vs{3}), eval(all_vs{4}), eval(all_vs{5}), eval(all_vs{6}), eval(all_vs{7}), eval(all_vs{8}), eval(all_vs{9}), eval(all_vs{1}),eval(all_vs{11}),eval(all_vs{12}), eval(all_vs{13}), eval(all_vs{14}), eval(all_vs{15}), eval(all_vs{16}), eval(all_vs{17}), eval(all_vs{18}), eval(all_vs{19}), eval(all_vs{10}),eval(all_vs{21}),eval(all_vs{22}), eval(all_vs{23}), eval(all_vs{24}), eval(all_vs{25}), eval(all_vs{20}), eval(all_vs{27}), eval(all_vs{28}), eval(all_vs{29}), eval(all_vs{30}),eval(all_vs{31}),eval(all_vs{32}), eval(all_vs{33}), eval(all_vs{34}), eval(all_vs{35}), eval(all_vs{36}), eval(all_vs{37}), eval(all_vs{38}), eval(all_vs{39}), eval(all_vs{40}),eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_26'), temp_AV_matrix); 
    assignin('base',strcat('AV_',current_v_name,'_leave_out_26_vector'), temp_AV_sim_vector); 
            [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{2}), eval(all_vs{3}), eval(all_vs{4}), eval(all_vs{5}), eval(all_vs{6}), eval(all_vs{7}), eval(all_vs{8}), eval(all_vs{9}), eval(all_vs{1}),eval(all_vs{11}),eval(all_vs{12}), eval(all_vs{13}), eval(all_vs{14}), eval(all_vs{15}), eval(all_vs{16}), eval(all_vs{17}), eval(all_vs{18}), eval(all_vs{19}), eval(all_vs{10}),eval(all_vs{21}),eval(all_vs{22}), eval(all_vs{23}), eval(all_vs{24}), eval(all_vs{25}), eval(all_vs{26}), eval(all_vs{20}), eval(all_vs{28}), eval(all_vs{29}), eval(all_vs{30}),eval(all_vs{31}),eval(all_vs{32}), eval(all_vs{33}), eval(all_vs{34}), eval(all_vs{35}), eval(all_vs{36}), eval(all_vs{37}), eval(all_vs{38}), eval(all_vs{39}), eval(all_vs{40}),eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_27'), temp_AV_matrix); 
    assignin('base',strcat('AV_',current_v_name,'_leave_out_27_vector'), temp_AV_sim_vector); 
            [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{2}), eval(all_vs{3}), eval(all_vs{4}), eval(all_vs{5}), eval(all_vs{6}), eval(all_vs{7}), eval(all_vs{8}), eval(all_vs{9}), eval(all_vs{1}),eval(all_vs{11}),eval(all_vs{12}), eval(all_vs{13}), eval(all_vs{14}), eval(all_vs{15}), eval(all_vs{16}), eval(all_vs{17}), eval(all_vs{18}), eval(all_vs{19}), eval(all_vs{10}),eval(all_vs{21}),eval(all_vs{22}), eval(all_vs{23}), eval(all_vs{24}), eval(all_vs{25}), eval(all_vs{26}), eval(all_vs{27}), eval(all_vs{20}), eval(all_vs{29}), eval(all_vs{30}),eval(all_vs{31}),eval(all_vs{32}), eval(all_vs{33}), eval(all_vs{34}), eval(all_vs{35}), eval(all_vs{36}), eval(all_vs{37}), eval(all_vs{38}), eval(all_vs{39}), eval(all_vs{40}),eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_28'), temp_AV_matrix); 
    assignin('base',strcat('AV_',current_v_name,'_leave_out_28_vector'), temp_AV_sim_vector); 
            [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{2}), eval(all_vs{3}), eval(all_vs{4}), eval(all_vs{5}), eval(all_vs{6}), eval(all_vs{7}), eval(all_vs{8}), eval(all_vs{9}), eval(all_vs{1}),eval(all_vs{11}),eval(all_vs{12}), eval(all_vs{13}), eval(all_vs{14}), eval(all_vs{15}), eval(all_vs{16}), eval(all_vs{17}), eval(all_vs{18}), eval(all_vs{19}), eval(all_vs{10}),eval(all_vs{21}),eval(all_vs{22}), eval(all_vs{23}), eval(all_vs{24}), eval(all_vs{25}), eval(all_vs{26}), eval(all_vs{27}), eval(all_vs{28}), eval(all_vs{20}), eval(all_vs{30}),eval(all_vs{31}),eval(all_vs{32}), eval(all_vs{33}), eval(all_vs{34}), eval(all_vs{35}), eval(all_vs{36}), eval(all_vs{37}), eval(all_vs{38}), eval(all_vs{39}), eval(all_vs{40}),eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_29'), temp_AV_matrix); 
    assignin('base',strcat('AV_',current_v_name,'_leave_out_29_vector'), temp_AV_sim_vector); 
            [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{2}), eval(all_vs{3}), eval(all_vs{4}), eval(all_vs{5}), eval(all_vs{6}), eval(all_vs{7}), eval(all_vs{8}), eval(all_vs{9}), eval(all_vs{1}),eval(all_vs{11}),eval(all_vs{12}), eval(all_vs{13}), eval(all_vs{14}), eval(all_vs{15}), eval(all_vs{16}), eval(all_vs{17}), eval(all_vs{18}), eval(all_vs{19}), eval(all_vs{10}),eval(all_vs{21}),eval(all_vs{22}), eval(all_vs{23}), eval(all_vs{24}), eval(all_vs{25}), eval(all_vs{26}), eval(all_vs{27}), eval(all_vs{28}), eval(all_vs{29}), eval(all_vs{20}),eval(all_vs{31}),eval(all_vs{32}), eval(all_vs{33}), eval(all_vs{34}), eval(all_vs{35}), eval(all_vs{36}), eval(all_vs{37}), eval(all_vs{38}), eval(all_vs{39}), eval(all_vs{40}),eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_30'), temp_AV_matrix); 
    assignin('base',strcat('AV_',current_v_name,'_leave_out_30_vector'), temp_AV_sim_vector); 
    
     [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{2}), eval(all_vs{3}), eval(all_vs{4}), eval(all_vs{5}), eval(all_vs{6}), eval(all_vs{7}), eval(all_vs{8}), eval(all_vs{9}), eval(all_vs{1}),eval(all_vs{11}),eval(all_vs{12}), eval(all_vs{13}), eval(all_vs{14}), eval(all_vs{15}), eval(all_vs{16}), eval(all_vs{17}), eval(all_vs{18}), eval(all_vs{19}), eval(all_vs{10}),eval(all_vs{21}),eval(all_vs{22}), eval(all_vs{23}), eval(all_vs{24}), eval(all_vs{25}), eval(all_vs{26}), eval(all_vs{27}), eval(all_vs{28}), eval(all_vs{29}), eval(all_vs{20}),eval(all_vs{30}),eval(all_vs{32}), eval(all_vs{33}), eval(all_vs{34}), eval(all_vs{35}), eval(all_vs{36}), eval(all_vs{37}), eval(all_vs{38}), eval(all_vs{39}), eval(all_vs{40}),eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_31'), temp_AV_matrix); 
    assignin('base',strcat('AV_',current_v_name,'_leave_out_31_vector'), temp_AV_sim_vector); 
    
     [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{2}), eval(all_vs{3}), eval(all_vs{4}), eval(all_vs{5}), eval(all_vs{6}), eval(all_vs{7}), eval(all_vs{8}), eval(all_vs{9}), eval(all_vs{1}),eval(all_vs{11}),eval(all_vs{12}), eval(all_vs{13}), eval(all_vs{14}), eval(all_vs{15}), eval(all_vs{16}), eval(all_vs{17}), eval(all_vs{18}), eval(all_vs{19}), eval(all_vs{10}),eval(all_vs{21}),eval(all_vs{22}), eval(all_vs{23}), eval(all_vs{24}), eval(all_vs{25}), eval(all_vs{26}), eval(all_vs{27}), eval(all_vs{28}), eval(all_vs{29}), eval(all_vs{20}),eval(all_vs{31}),eval(all_vs{30}), eval(all_vs{33}), eval(all_vs{34}), eval(all_vs{35}), eval(all_vs{36}), eval(all_vs{37}), eval(all_vs{38}), eval(all_vs{39}), eval(all_vs{40}),eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_32'), temp_AV_matrix); 
    assignin('base',strcat('AV_',current_v_name,'_leave_out_32_vector'), temp_AV_sim_vector); 
    
     [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{2}), eval(all_vs{3}), eval(all_vs{4}), eval(all_vs{5}), eval(all_vs{6}), eval(all_vs{7}), eval(all_vs{8}), eval(all_vs{9}), eval(all_vs{1}),eval(all_vs{11}),eval(all_vs{12}), eval(all_vs{13}), eval(all_vs{14}), eval(all_vs{15}), eval(all_vs{16}), eval(all_vs{17}), eval(all_vs{18}), eval(all_vs{19}), eval(all_vs{10}),eval(all_vs{21}),eval(all_vs{22}), eval(all_vs{23}), eval(all_vs{24}), eval(all_vs{25}), eval(all_vs{26}), eval(all_vs{27}), eval(all_vs{28}), eval(all_vs{29}), eval(all_vs{20}),eval(all_vs{31}),eval(all_vs{32}), eval(all_vs{30}), eval(all_vs{34}), eval(all_vs{35}), eval(all_vs{36}), eval(all_vs{37}), eval(all_vs{38}), eval(all_vs{39}), eval(all_vs{40}),eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_33'), temp_AV_matrix); 
    assignin('base',strcat('AV_',current_v_name,'_leave_out_33_vector'), temp_AV_sim_vector); 
    
     [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{2}), eval(all_vs{3}), eval(all_vs{4}), eval(all_vs{5}), eval(all_vs{6}), eval(all_vs{7}), eval(all_vs{8}), eval(all_vs{9}), eval(all_vs{1}),eval(all_vs{11}),eval(all_vs{12}), eval(all_vs{13}), eval(all_vs{14}), eval(all_vs{15}), eval(all_vs{16}), eval(all_vs{17}), eval(all_vs{18}), eval(all_vs{19}), eval(all_vs{10}),eval(all_vs{21}),eval(all_vs{22}), eval(all_vs{23}), eval(all_vs{24}), eval(all_vs{25}), eval(all_vs{26}), eval(all_vs{27}), eval(all_vs{28}), eval(all_vs{29}), eval(all_vs{20}),eval(all_vs{31}),eval(all_vs{32}), eval(all_vs{33}), eval(all_vs{30}), eval(all_vs{35}), eval(all_vs{36}), eval(all_vs{37}), eval(all_vs{38}), eval(all_vs{39}), eval(all_vs{40}),eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_34'), temp_AV_matrix); 
    assignin('base',strcat('AV_',current_v_name,'_leave_out_34_vector'), temp_AV_sim_vector); 
    
     [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{2}), eval(all_vs{3}), eval(all_vs{4}), eval(all_vs{5}), eval(all_vs{6}), eval(all_vs{7}), eval(all_vs{8}), eval(all_vs{9}), eval(all_vs{1}),eval(all_vs{11}),eval(all_vs{12}), eval(all_vs{13}), eval(all_vs{14}), eval(all_vs{15}), eval(all_vs{16}), eval(all_vs{17}), eval(all_vs{18}), eval(all_vs{19}), eval(all_vs{10}),eval(all_vs{21}),eval(all_vs{22}), eval(all_vs{23}), eval(all_vs{24}), eval(all_vs{25}), eval(all_vs{26}), eval(all_vs{27}), eval(all_vs{28}), eval(all_vs{29}), eval(all_vs{20}),eval(all_vs{31}),eval(all_vs{32}), eval(all_vs{33}), eval(all_vs{34}), eval(all_vs{30}), eval(all_vs{36}), eval(all_vs{37}), eval(all_vs{38}), eval(all_vs{39}), eval(all_vs{40}),eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_35'), temp_AV_matrix); 
    assignin('base',strcat('AV_',current_v_name,'_leave_out_35_vector'), temp_AV_sim_vector); 
    
     [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{2}), eval(all_vs{3}), eval(all_vs{4}), eval(all_vs{5}), eval(all_vs{6}), eval(all_vs{7}), eval(all_vs{8}), eval(all_vs{9}), eval(all_vs{1}),eval(all_vs{11}),eval(all_vs{12}), eval(all_vs{13}), eval(all_vs{14}), eval(all_vs{15}), eval(all_vs{16}), eval(all_vs{17}), eval(all_vs{18}), eval(all_vs{19}), eval(all_vs{10}),eval(all_vs{21}),eval(all_vs{22}), eval(all_vs{23}), eval(all_vs{24}), eval(all_vs{25}), eval(all_vs{26}), eval(all_vs{27}), eval(all_vs{28}), eval(all_vs{29}), eval(all_vs{20}),eval(all_vs{31}),eval(all_vs{32}), eval(all_vs{33}), eval(all_vs{34}), eval(all_vs{35}), eval(all_vs{30}), eval(all_vs{37}), eval(all_vs{38}), eval(all_vs{39}), eval(all_vs{40}),eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_36'), temp_AV_matrix); 
    assignin('base',strcat('AV_',current_v_name,'_leave_out_36_vector'), temp_AV_sim_vector); 
    
     [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{2}), eval(all_vs{3}), eval(all_vs{4}), eval(all_vs{5}), eval(all_vs{6}), eval(all_vs{7}), eval(all_vs{8}), eval(all_vs{9}), eval(all_vs{1}),eval(all_vs{11}),eval(all_vs{12}), eval(all_vs{13}), eval(all_vs{14}), eval(all_vs{15}), eval(all_vs{16}), eval(all_vs{17}), eval(all_vs{18}), eval(all_vs{19}), eval(all_vs{10}),eval(all_vs{21}),eval(all_vs{22}), eval(all_vs{23}), eval(all_vs{24}), eval(all_vs{25}), eval(all_vs{26}), eval(all_vs{27}), eval(all_vs{28}), eval(all_vs{29}), eval(all_vs{20}),eval(all_vs{31}),eval(all_vs{32}), eval(all_vs{33}), eval(all_vs{34}), eval(all_vs{35}), eval(all_vs{36}), eval(all_vs{30}), eval(all_vs{38}), eval(all_vs{39}), eval(all_vs{40}),eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_37'), temp_AV_matrix); 
    assignin('base',strcat('AV_',current_v_name,'_leave_out_37_vector'), temp_AV_sim_vector); 
    
     [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{2}), eval(all_vs{3}), eval(all_vs{4}), eval(all_vs{5}), eval(all_vs{6}), eval(all_vs{7}), eval(all_vs{8}), eval(all_vs{9}), eval(all_vs{1}),eval(all_vs{11}),eval(all_vs{12}), eval(all_vs{13}), eval(all_vs{14}), eval(all_vs{15}), eval(all_vs{16}), eval(all_vs{17}), eval(all_vs{18}), eval(all_vs{19}), eval(all_vs{10}),eval(all_vs{21}),eval(all_vs{22}), eval(all_vs{23}), eval(all_vs{24}), eval(all_vs{25}), eval(all_vs{26}), eval(all_vs{27}), eval(all_vs{28}), eval(all_vs{29}), eval(all_vs{20}),eval(all_vs{31}),eval(all_vs{32}), eval(all_vs{33}), eval(all_vs{34}), eval(all_vs{35}), eval(all_vs{36}), eval(all_vs{37}), eval(all_vs{30}), eval(all_vs{39}), eval(all_vs{40}),eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_38'), temp_AV_matrix); 
    assignin('base',strcat('AV_',current_v_name,'_leave_out_38_vector'), temp_AV_sim_vector); 
    
     [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{2}), eval(all_vs{3}), eval(all_vs{4}), eval(all_vs{5}), eval(all_vs{6}), eval(all_vs{7}), eval(all_vs{8}), eval(all_vs{9}), eval(all_vs{1}),eval(all_vs{11}),eval(all_vs{12}), eval(all_vs{13}), eval(all_vs{14}), eval(all_vs{15}), eval(all_vs{16}), eval(all_vs{17}), eval(all_vs{18}), eval(all_vs{19}), eval(all_vs{10}),eval(all_vs{21}),eval(all_vs{22}), eval(all_vs{23}), eval(all_vs{24}), eval(all_vs{25}), eval(all_vs{26}), eval(all_vs{27}), eval(all_vs{28}), eval(all_vs{29}), eval(all_vs{20}),eval(all_vs{31}),eval(all_vs{32}), eval(all_vs{33}), eval(all_vs{34}), eval(all_vs{35}), eval(all_vs{36}), eval(all_vs{37}), eval(all_vs{38}), eval(all_vs{30}), eval(all_vs{40}),eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_39'), temp_AV_matrix); 
    assignin('base',strcat('AV_',current_v_name,'_leave_out_39_vector'), temp_AV_sim_vector); 
    
     [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{2}), eval(all_vs{3}), eval(all_vs{4}), eval(all_vs{5}), eval(all_vs{6}), eval(all_vs{7}), eval(all_vs{8}), eval(all_vs{9}), eval(all_vs{1}),eval(all_vs{11}),eval(all_vs{12}), eval(all_vs{13}), eval(all_vs{14}), eval(all_vs{15}), eval(all_vs{16}), eval(all_vs{17}), eval(all_vs{18}), eval(all_vs{19}), eval(all_vs{10}),eval(all_vs{21}),eval(all_vs{22}), eval(all_vs{23}), eval(all_vs{24}), eval(all_vs{25}), eval(all_vs{26}), eval(all_vs{27}), eval(all_vs{28}), eval(all_vs{29}), eval(all_vs{20}),eval(all_vs{31}),eval(all_vs{32}), eval(all_vs{33}), eval(all_vs{34}), eval(all_vs{35}), eval(all_vs{36}), eval(all_vs{37}), eval(all_vs{38}), eval(all_vs{39}), eval(all_vs{30}),eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_40'), temp_AV_matrix); 
    assignin('base',strcat('AV_',current_v_name,'_leave_out_40_vector'), temp_AV_sim_vector); 
     
    [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{2}), eval(all_vs{3}), eval(all_vs{4}), eval(all_vs{5}), eval(all_vs{6}), eval(all_vs{7}), eval(all_vs{8}), eval(all_vs{9}), eval(all_vs{10}),eval(all_vs{11}),eval(all_vs{12}), eval(all_vs{13}), eval(all_vs{14}), eval(all_vs{15}), eval(all_vs{16}), eval(all_vs{17}), eval(all_vs{18}), eval(all_vs{19}), eval(all_vs{20}),eval(all_vs{21}),eval(all_vs{22}), eval(all_vs{23}), eval(all_vs{24}), eval(all_vs{25}), eval(all_vs{26}), eval(all_vs{27}), eval(all_vs{28}), eval(all_vs{29}), eval(all_vs{30}),eval(all_vs{31}),eval(all_vs{32}), eval(all_vs{33}), eval(all_vs{34}), eval(all_vs{35}), eval(all_vs{36}), eval(all_vs{37}), eval(all_vs{38}), eval(all_vs{39}), eval(all_vs{40}), eval(all_vs{1}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_41'), temp_AV_matrix);
    assignin('base',strcat('AV_',current_v_name,'_leave_out_41_vector'), temp_AV_sim_vector);
    
    [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{1}), eval(all_vs{3}), eval(all_vs{4}), eval(all_vs{5}), eval(all_vs{6}), eval(all_vs{7}), eval(all_vs{8}), eval(all_vs{9}), eval(all_vs{10}),eval(all_vs{11}),eval(all_vs{12}), eval(all_vs{13}), eval(all_vs{14}), eval(all_vs{15}), eval(all_vs{16}), eval(all_vs{17}), eval(all_vs{18}), eval(all_vs{19}), eval(all_vs{20}),eval(all_vs{21}),eval(all_vs{22}), eval(all_vs{23}), eval(all_vs{24}), eval(all_vs{25}), eval(all_vs{26}), eval(all_vs{27}), eval(all_vs{28}), eval(all_vs{29}), eval(all_vs{30}),eval(all_vs{31}),eval(all_vs{32}), eval(all_vs{33}), eval(all_vs{34}), eval(all_vs{35}), eval(all_vs{36}), eval(all_vs{37}), eval(all_vs{38}), eval(all_vs{39}), eval(all_vs{40}), eval(all_vs{41}),eval(all_vs{2}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_42'), temp_AV_matrix);
    assignin('base',strcat('AV_',current_v_name,'_leave_out_42_vector'), temp_AV_sim_vector);
    
    [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{2}), eval(all_vs{1}), eval(all_vs{4}), eval(all_vs{5}), eval(all_vs{6}), eval(all_vs{7}), eval(all_vs{8}), eval(all_vs{9}), eval(all_vs{10}),eval(all_vs{11}),eval(all_vs{12}), eval(all_vs{13}), eval(all_vs{14}), eval(all_vs{15}), eval(all_vs{16}), eval(all_vs{17}), eval(all_vs{18}), eval(all_vs{19}), eval(all_vs{20}),eval(all_vs{21}),eval(all_vs{22}), eval(all_vs{23}), eval(all_vs{24}), eval(all_vs{25}), eval(all_vs{26}), eval(all_vs{27}), eval(all_vs{28}), eval(all_vs{29}), eval(all_vs{30}),eval(all_vs{31}),eval(all_vs{32}), eval(all_vs{33}), eval(all_vs{34}), eval(all_vs{35}), eval(all_vs{36}), eval(all_vs{37}), eval(all_vs{38}), eval(all_vs{39}), eval(all_vs{40}),eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{3}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_43'), temp_AV_matrix);
    assignin('base',strcat('AV_',current_v_name,'_leave_out_43_vector'), temp_AV_sim_vector);
    
    [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{2}), eval(all_vs{3}), eval(all_vs{1}), eval(all_vs{5}), eval(all_vs{6}), eval(all_vs{7}), eval(all_vs{8}), eval(all_vs{9}), eval(all_vs{10}),eval(all_vs{11}),eval(all_vs{12}), eval(all_vs{13}), eval(all_vs{14}), eval(all_vs{15}), eval(all_vs{16}), eval(all_vs{17}), eval(all_vs{18}), eval(all_vs{19}), eval(all_vs{20}),eval(all_vs{21}),eval(all_vs{22}), eval(all_vs{23}), eval(all_vs{24}), eval(all_vs{25}), eval(all_vs{26}), eval(all_vs{27}), eval(all_vs{28}), eval(all_vs{29}), eval(all_vs{30}),eval(all_vs{31}),eval(all_vs{32}), eval(all_vs{33}), eval(all_vs{34}), eval(all_vs{35}), eval(all_vs{36}), eval(all_vs{37}), eval(all_vs{38}), eval(all_vs{39}), eval(all_vs{40}),eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{4}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_44'), temp_AV_matrix);
    assignin('base',strcat('AV_',current_v_name,'_leave_out_44_vector'), temp_AV_sim_vector);
     
    [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{2}), eval(all_vs{3}), eval(all_vs{4}), eval(all_vs{1}), eval(all_vs{6}), eval(all_vs{7}), eval(all_vs{8}), eval(all_vs{9}), eval(all_vs{10}),eval(all_vs{11}),eval(all_vs{12}), eval(all_vs{13}), eval(all_vs{14}), eval(all_vs{15}), eval(all_vs{16}), eval(all_vs{17}), eval(all_vs{18}), eval(all_vs{19}), eval(all_vs{20}),eval(all_vs{21}),eval(all_vs{22}), eval(all_vs{23}), eval(all_vs{24}), eval(all_vs{25}), eval(all_vs{26}), eval(all_vs{27}), eval(all_vs{28}), eval(all_vs{29}), eval(all_vs{30}),eval(all_vs{31}),eval(all_vs{32}), eval(all_vs{33}), eval(all_vs{34}), eval(all_vs{35}), eval(all_vs{36}), eval(all_vs{37}), eval(all_vs{38}), eval(all_vs{39}), eval(all_vs{40}),eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{5}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_45'), temp_AV_matrix);
    assignin('base',strcat('AV_',current_v_name,'_leave_out_45_vector'), temp_AV_sim_vector);
    
    [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{2}), eval(all_vs{3}), eval(all_vs{4}), eval(all_vs{5}), eval(all_vs{1}), eval(all_vs{7}), eval(all_vs{8}), eval(all_vs{9}), eval(all_vs{10}),eval(all_vs{11}),eval(all_vs{12}), eval(all_vs{13}), eval(all_vs{14}), eval(all_vs{15}), eval(all_vs{16}), eval(all_vs{17}), eval(all_vs{18}), eval(all_vs{19}), eval(all_vs{20}),eval(all_vs{21}),eval(all_vs{22}), eval(all_vs{23}), eval(all_vs{24}), eval(all_vs{25}), eval(all_vs{26}), eval(all_vs{27}), eval(all_vs{28}), eval(all_vs{29}), eval(all_vs{30}),eval(all_vs{31}),eval(all_vs{32}), eval(all_vs{33}), eval(all_vs{34}), eval(all_vs{35}), eval(all_vs{36}), eval(all_vs{37}), eval(all_vs{38}), eval(all_vs{39}), eval(all_vs{40}),eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{6}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_46'), temp_AV_matrix);
    assignin('base',strcat('AV_',current_v_name,'_leave_out_46_vector'), temp_AV_sim_vector);
    
    [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{2}), eval(all_vs{3}), eval(all_vs{4}), eval(all_vs{5}), eval(all_vs{6}), eval(all_vs{1}), eval(all_vs{8}), eval(all_vs{9}), eval(all_vs{10}),eval(all_vs{11}),eval(all_vs{12}), eval(all_vs{13}), eval(all_vs{14}), eval(all_vs{15}), eval(all_vs{16}), eval(all_vs{17}), eval(all_vs{18}), eval(all_vs{19}), eval(all_vs{20}),eval(all_vs{21}),eval(all_vs{22}), eval(all_vs{23}), eval(all_vs{24}), eval(all_vs{25}), eval(all_vs{26}), eval(all_vs{27}), eval(all_vs{28}), eval(all_vs{29}), eval(all_vs{30}),eval(all_vs{31}),eval(all_vs{32}), eval(all_vs{33}), eval(all_vs{34}), eval(all_vs{35}), eval(all_vs{36}), eval(all_vs{37}), eval(all_vs{38}), eval(all_vs{39}), eval(all_vs{40}),eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{7}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_47'), temp_AV_matrix);
    assignin('base',strcat('AV_',current_v_name,'_leave_out_47_vector'), temp_AV_sim_vector);
    
    [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{2}), eval(all_vs{3}), eval(all_vs{4}), eval(all_vs{5}), eval(all_vs{6}), eval(all_vs{7}), eval(all_vs{1}), eval(all_vs{9}), eval(all_vs{10}),eval(all_vs{11}),eval(all_vs{12}), eval(all_vs{13}), eval(all_vs{14}), eval(all_vs{15}), eval(all_vs{16}), eval(all_vs{17}), eval(all_vs{18}), eval(all_vs{19}), eval(all_vs{20}),eval(all_vs{21}),eval(all_vs{22}), eval(all_vs{23}), eval(all_vs{24}), eval(all_vs{25}), eval(all_vs{26}), eval(all_vs{27}), eval(all_vs{28}), eval(all_vs{29}), eval(all_vs{30}),eval(all_vs{31}),eval(all_vs{32}), eval(all_vs{33}), eval(all_vs{34}), eval(all_vs{35}), eval(all_vs{36}), eval(all_vs{37}), eval(all_vs{38}), eval(all_vs{39}), eval(all_vs{40}),eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{8}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_48'), temp_AV_matrix);
    assignin('base',strcat('AV_',current_v_name,'_leave_out_48_vector'), temp_AV_sim_vector);
    
    [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{2}), eval(all_vs{3}), eval(all_vs{4}), eval(all_vs{5}), eval(all_vs{6}), eval(all_vs{7}), eval(all_vs{8}), eval(all_vs{1}), eval(all_vs{10}),eval(all_vs{11}),eval(all_vs{12}), eval(all_vs{13}), eval(all_vs{14}), eval(all_vs{15}), eval(all_vs{16}), eval(all_vs{17}), eval(all_vs{18}), eval(all_vs{19}), eval(all_vs{20}),eval(all_vs{21}),eval(all_vs{22}), eval(all_vs{23}), eval(all_vs{24}), eval(all_vs{25}), eval(all_vs{26}), eval(all_vs{27}), eval(all_vs{28}), eval(all_vs{29}), eval(all_vs{30}),eval(all_vs{31}),eval(all_vs{32}), eval(all_vs{33}), eval(all_vs{34}), eval(all_vs{35}), eval(all_vs{36}), eval(all_vs{37}), eval(all_vs{38}), eval(all_vs{39}), eval(all_vs{40}),eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{9}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_49'), temp_AV_matrix);
    assignin('base',strcat('AV_',current_v_name,'_leave_out_49_vector'), temp_AV_sim_vector);
    
    [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{2}), eval(all_vs{3}), eval(all_vs{4}), eval(all_vs{5}), eval(all_vs{6}), eval(all_vs{7}), eval(all_vs{8}), eval(all_vs{9}), eval(all_vs{1}),eval(all_vs{11}),eval(all_vs{12}), eval(all_vs{13}), eval(all_vs{14}), eval(all_vs{15}), eval(all_vs{16}), eval(all_vs{17}), eval(all_vs{18}), eval(all_vs{19}), eval(all_vs{20}),eval(all_vs{21}),eval(all_vs{22}), eval(all_vs{23}), eval(all_vs{24}), eval(all_vs{25}), eval(all_vs{26}), eval(all_vs{27}), eval(all_vs{28}), eval(all_vs{29}), eval(all_vs{30}),eval(all_vs{31}),eval(all_vs{32}), eval(all_vs{33}), eval(all_vs{34}), eval(all_vs{35}), eval(all_vs{36}), eval(all_vs{37}), eval(all_vs{38}), eval(all_vs{39}), eval(all_vs{40}),eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{10}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_50'), temp_AV_matrix); 
    assignin('base',strcat('AV_',current_v_name,'_leave_out_50_vector'), temp_AV_sim_vector);
    
    [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{2}), eval(all_vs{3}), eval(all_vs{4}), eval(all_vs{5}), eval(all_vs{6}), eval(all_vs{7}), eval(all_vs{8}), eval(all_vs{9}), eval(all_vs{1}),eval(all_vs{10}),eval(all_vs{12}), eval(all_vs{13}), eval(all_vs{14}), eval(all_vs{15}), eval(all_vs{16}), eval(all_vs{17}), eval(all_vs{18}), eval(all_vs{19}), eval(all_vs{20}),eval(all_vs{21}),eval(all_vs{22}), eval(all_vs{23}), eval(all_vs{24}), eval(all_vs{25}), eval(all_vs{26}), eval(all_vs{27}), eval(all_vs{28}), eval(all_vs{29}), eval(all_vs{30}),eval(all_vs{31}),eval(all_vs{32}), eval(all_vs{33}), eval(all_vs{34}), eval(all_vs{35}), eval(all_vs{36}), eval(all_vs{37}), eval(all_vs{38}), eval(all_vs{39}), eval(all_vs{40}),eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{11}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_51'), temp_AV_matrix); 
    assignin('base',strcat('AV_',current_v_name,'_leave_out_51_vector'), temp_AV_sim_vector);  
    
        [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{2}), eval(all_vs{3}), eval(all_vs{4}), eval(all_vs{5}), eval(all_vs{6}), eval(all_vs{7}), eval(all_vs{8}), eval(all_vs{9}), eval(all_vs{1}),eval(all_vs{11}),eval(all_vs{10}), eval(all_vs{13}), eval(all_vs{14}), eval(all_vs{15}), eval(all_vs{16}), eval(all_vs{17}), eval(all_vs{18}), eval(all_vs{19}), eval(all_vs{20}),eval(all_vs{21}),eval(all_vs{22}), eval(all_vs{23}), eval(all_vs{24}), eval(all_vs{25}), eval(all_vs{26}), eval(all_vs{27}), eval(all_vs{28}), eval(all_vs{29}), eval(all_vs{30}),eval(all_vs{31}),eval(all_vs{32}), eval(all_vs{33}), eval(all_vs{34}), eval(all_vs{35}), eval(all_vs{36}), eval(all_vs{37}), eval(all_vs{38}), eval(all_vs{39}), eval(all_vs{40}),eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{12}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_52'), temp_AV_matrix); 
    assignin('base',strcat('AV_',current_v_name,'_leave_out_52_vector'), temp_AV_sim_vector);  
    
        [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{2}), eval(all_vs{3}), eval(all_vs{4}), eval(all_vs{5}), eval(all_vs{6}), eval(all_vs{7}), eval(all_vs{8}), eval(all_vs{9}), eval(all_vs{1}),eval(all_vs{11}),eval(all_vs{12}), eval(all_vs{10}), eval(all_vs{14}), eval(all_vs{15}), eval(all_vs{16}), eval(all_vs{17}), eval(all_vs{18}), eval(all_vs{19}), eval(all_vs{20}),eval(all_vs{21}), eval(all_vs{22}), eval(all_vs{23}), eval(all_vs{24}), eval(all_vs{25}), eval(all_vs{26}), eval(all_vs{27}), eval(all_vs{28}), eval(all_vs{29}), eval(all_vs{30}),eval(all_vs{31}),eval(all_vs{32}), eval(all_vs{33}), eval(all_vs{34}), eval(all_vs{35}), eval(all_vs{36}), eval(all_vs{37}), eval(all_vs{38}), eval(all_vs{39}), eval(all_vs{40}),eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{13}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_53'), temp_AV_matrix); 
    assignin('base',strcat('AV_',current_v_name,'_leave_out_53_vector'), temp_AV_sim_vector);  
    
        [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{2}), eval(all_vs{3}), eval(all_vs{4}), eval(all_vs{5}), eval(all_vs{6}), eval(all_vs{7}), eval(all_vs{8}), eval(all_vs{9}), eval(all_vs{1}),eval(all_vs{11}),eval(all_vs{12}), eval(all_vs{13}), eval(all_vs{10}), eval(all_vs{15}), eval(all_vs{16}), eval(all_vs{17}), eval(all_vs{18}), eval(all_vs{19}), eval(all_vs{20}),eval(all_vs{21}),eval(all_vs{22}), eval(all_vs{23}), eval(all_vs{24}), eval(all_vs{25}), eval(all_vs{26}), eval(all_vs{27}), eval(all_vs{28}), eval(all_vs{29}), eval(all_vs{30}),eval(all_vs{31}),eval(all_vs{32}), eval(all_vs{33}), eval(all_vs{34}), eval(all_vs{35}), eval(all_vs{36}), eval(all_vs{37}), eval(all_vs{38}), eval(all_vs{39}), eval(all_vs{40}),eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{14}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_54'), temp_AV_matrix); 
    assignin('base',strcat('AV_',current_v_name,'_leave_out_54_vector'), temp_AV_sim_vector);  
    
        [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{2}), eval(all_vs{3}), eval(all_vs{4}), eval(all_vs{5}), eval(all_vs{6}), eval(all_vs{7}), eval(all_vs{8}), eval(all_vs{9}), eval(all_vs{1}),eval(all_vs{11}),eval(all_vs{12}), eval(all_vs{13}), eval(all_vs{14}), eval(all_vs{10}), eval(all_vs{16}), eval(all_vs{17}), eval(all_vs{18}), eval(all_vs{19}), eval(all_vs{20}),eval(all_vs{21}),eval(all_vs{22}), eval(all_vs{23}), eval(all_vs{24}), eval(all_vs{25}), eval(all_vs{26}), eval(all_vs{27}), eval(all_vs{28}), eval(all_vs{29}), eval(all_vs{30}),eval(all_vs{31}),eval(all_vs{32}), eval(all_vs{33}), eval(all_vs{34}), eval(all_vs{35}), eval(all_vs{36}), eval(all_vs{37}), eval(all_vs{38}), eval(all_vs{39}), eval(all_vs{40}),eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{15}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_55'), temp_AV_matrix); 
    assignin('base',strcat('AV_',current_v_name,'_leave_out_55_vector'), temp_AV_sim_vector);  
    
        [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{2}), eval(all_vs{3}), eval(all_vs{4}), eval(all_vs{5}), eval(all_vs{6}), eval(all_vs{7}), eval(all_vs{8}), eval(all_vs{9}), eval(all_vs{1}),eval(all_vs{11}),eval(all_vs{12}), eval(all_vs{13}), eval(all_vs{14}), eval(all_vs{15}), eval(all_vs{10}), eval(all_vs{17}), eval(all_vs{18}), eval(all_vs{19}), eval(all_vs{20}),eval(all_vs{21}),eval(all_vs{22}), eval(all_vs{23}), eval(all_vs{24}), eval(all_vs{25}), eval(all_vs{26}), eval(all_vs{27}), eval(all_vs{28}), eval(all_vs{29}), eval(all_vs{30}),eval(all_vs{31}),eval(all_vs{32}), eval(all_vs{33}), eval(all_vs{34}), eval(all_vs{35}), eval(all_vs{36}), eval(all_vs{37}), eval(all_vs{38}), eval(all_vs{39}), eval(all_vs{40}),eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{16}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_56'), temp_AV_matrix); 
    assignin('base',strcat('AV_',current_v_name,'_leave_out_56_vector'), temp_AV_sim_vector);
        [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{2}), eval(all_vs{3}), eval(all_vs{4}), eval(all_vs{5}), eval(all_vs{6}), eval(all_vs{7}), eval(all_vs{8}), eval(all_vs{9}), eval(all_vs{1}),eval(all_vs{11}),eval(all_vs{12}), eval(all_vs{13}), eval(all_vs{14}), eval(all_vs{15}), eval(all_vs{16}), eval(all_vs{10}), eval(all_vs{18}), eval(all_vs{19}), eval(all_vs{20}),eval(all_vs{21}),eval(all_vs{22}), eval(all_vs{23}), eval(all_vs{24}), eval(all_vs{25}), eval(all_vs{26}), eval(all_vs{27}), eval(all_vs{28}), eval(all_vs{29}), eval(all_vs{30}),eval(all_vs{31}),eval(all_vs{32}), eval(all_vs{33}), eval(all_vs{34}), eval(all_vs{35}), eval(all_vs{36}), eval(all_vs{37}), eval(all_vs{38}), eval(all_vs{39}), eval(all_vs{40}),eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{17}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_57'), temp_AV_matrix); 
    assignin('base',strcat('AV_',current_v_name,'_leave_out_57_vector'), temp_AV_sim_vector);
        [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{2}), eval(all_vs{3}), eval(all_vs{4}), eval(all_vs{5}), eval(all_vs{6}), eval(all_vs{7}), eval(all_vs{8}), eval(all_vs{9}), eval(all_vs{1}),eval(all_vs{11}),eval(all_vs{12}), eval(all_vs{13}), eval(all_vs{14}), eval(all_vs{15}), eval(all_vs{16}), eval(all_vs{17}), eval(all_vs{10}), eval(all_vs{19}), eval(all_vs{20}),eval(all_vs{21}),eval(all_vs{22}), eval(all_vs{23}), eval(all_vs{24}), eval(all_vs{25}), eval(all_vs{26}), eval(all_vs{27}), eval(all_vs{28}), eval(all_vs{29}), eval(all_vs{30}),eval(all_vs{31}),eval(all_vs{32}), eval(all_vs{33}), eval(all_vs{34}), eval(all_vs{35}), eval(all_vs{36}), eval(all_vs{37}), eval(all_vs{38}), eval(all_vs{39}), eval(all_vs{40}),eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{18}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_58'), temp_AV_matrix); 
    assignin('base',strcat('AV_',current_v_name,'_leave_out_58_vector'), temp_AV_sim_vector);
        [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{2}), eval(all_vs{3}), eval(all_vs{4}), eval(all_vs{5}), eval(all_vs{6}), eval(all_vs{7}), eval(all_vs{8}), eval(all_vs{9}), eval(all_vs{1}),eval(all_vs{11}),eval(all_vs{12}), eval(all_vs{13}), eval(all_vs{14}), eval(all_vs{15}), eval(all_vs{16}), eval(all_vs{17}), eval(all_vs{18}), eval(all_vs{10}), eval(all_vs{20}),eval(all_vs{21}),eval(all_vs{22}), eval(all_vs{23}), eval(all_vs{24}), eval(all_vs{25}), eval(all_vs{26}), eval(all_vs{27}), eval(all_vs{28}), eval(all_vs{29}), eval(all_vs{30}),eval(all_vs{31}),eval(all_vs{32}), eval(all_vs{33}), eval(all_vs{34}), eval(all_vs{35}), eval(all_vs{36}), eval(all_vs{37}), eval(all_vs{38}), eval(all_vs{39}), eval(all_vs{40}),eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{19}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_59'), temp_AV_matrix); 
    assignin('base',strcat('AV_',current_v_name,'_leave_out_59_vector'), temp_AV_sim_vector);
        [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{2}), eval(all_vs{3}), eval(all_vs{4}), eval(all_vs{5}), eval(all_vs{6}), eval(all_vs{7}), eval(all_vs{8}), eval(all_vs{9}), eval(all_vs{1}),eval(all_vs{11}),eval(all_vs{12}), eval(all_vs{13}), eval(all_vs{14}), eval(all_vs{15}), eval(all_vs{16}), eval(all_vs{17}), eval(all_vs{18}), eval(all_vs{19}), eval(all_vs{10}),eval(all_vs{21}),eval(all_vs{22}), eval(all_vs{23}), eval(all_vs{24}), eval(all_vs{25}), eval(all_vs{26}), eval(all_vs{27}), eval(all_vs{28}), eval(all_vs{29}), eval(all_vs{30}),eval(all_vs{31}),eval(all_vs{32}), eval(all_vs{33}), eval(all_vs{34}), eval(all_vs{35}), eval(all_vs{36}), eval(all_vs{37}), eval(all_vs{38}), eval(all_vs{39}), eval(all_vs{40}),eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{20}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_60'), temp_AV_matrix); 
    assignin('base',strcat('AV_',current_v_name,'_leave_out_60_vector'), temp_AV_sim_vector); 
            [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{2}), eval(all_vs{3}), eval(all_vs{4}), eval(all_vs{5}), eval(all_vs{6}), eval(all_vs{7}), eval(all_vs{8}), eval(all_vs{9}), eval(all_vs{1}),eval(all_vs{11}),eval(all_vs{12}), eval(all_vs{13}), eval(all_vs{14}), eval(all_vs{15}), eval(all_vs{16}), eval(all_vs{17}), eval(all_vs{18}), eval(all_vs{19}), eval(all_vs{10}),eval(all_vs{20}),eval(all_vs{22}), eval(all_vs{23}), eval(all_vs{24}), eval(all_vs{25}), eval(all_vs{26}), eval(all_vs{27}), eval(all_vs{28}), eval(all_vs{29}), eval(all_vs{30}),eval(all_vs{31}),eval(all_vs{32}), eval(all_vs{33}), eval(all_vs{34}), eval(all_vs{35}), eval(all_vs{36}), eval(all_vs{37}), eval(all_vs{38}), eval(all_vs{39}), eval(all_vs{40}),eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{21}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_61'), temp_AV_matrix); 
    assignin('base',strcat('AV_',current_v_name,'_leave_out_61_vector'), temp_AV_sim_vector); 
            [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{2}), eval(all_vs{3}), eval(all_vs{4}), eval(all_vs{5}), eval(all_vs{6}), eval(all_vs{7}), eval(all_vs{8}), eval(all_vs{9}), eval(all_vs{1}),eval(all_vs{11}),eval(all_vs{12}), eval(all_vs{13}), eval(all_vs{14}), eval(all_vs{15}), eval(all_vs{16}), eval(all_vs{17}), eval(all_vs{18}), eval(all_vs{19}), eval(all_vs{10}),eval(all_vs{21}),eval(all_vs{20}), eval(all_vs{23}), eval(all_vs{24}), eval(all_vs{25}), eval(all_vs{26}), eval(all_vs{27}), eval(all_vs{28}), eval(all_vs{29}), eval(all_vs{30}),eval(all_vs{31}),eval(all_vs{32}), eval(all_vs{33}), eval(all_vs{34}), eval(all_vs{35}), eval(all_vs{36}), eval(all_vs{37}), eval(all_vs{38}), eval(all_vs{39}), eval(all_vs{40}),eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{22}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_62'), temp_AV_matrix); 
    assignin('base',strcat('AV_',current_v_name,'_leave_out_62_vector'), temp_AV_sim_vector); 
            [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{2}), eval(all_vs{3}), eval(all_vs{4}), eval(all_vs{5}), eval(all_vs{6}), eval(all_vs{7}), eval(all_vs{8}), eval(all_vs{9}), eval(all_vs{1}),eval(all_vs{11}),eval(all_vs{12}), eval(all_vs{13}), eval(all_vs{14}), eval(all_vs{15}), eval(all_vs{16}), eval(all_vs{17}), eval(all_vs{18}), eval(all_vs{19}), eval(all_vs{10}),eval(all_vs{21}),eval(all_vs{22}), eval(all_vs{20}), eval(all_vs{24}), eval(all_vs{25}), eval(all_vs{26}), eval(all_vs{27}), eval(all_vs{28}), eval(all_vs{29}), eval(all_vs{30}),eval(all_vs{31}),eval(all_vs{32}), eval(all_vs{33}), eval(all_vs{34}), eval(all_vs{35}), eval(all_vs{36}), eval(all_vs{37}), eval(all_vs{38}), eval(all_vs{39}), eval(all_vs{40}),eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{23}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_63'), temp_AV_matrix); 
    assignin('base',strcat('AV_',current_v_name,'_leave_out_63_vector'), temp_AV_sim_vector); 
            [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{2}), eval(all_vs{3}), eval(all_vs{4}), eval(all_vs{5}), eval(all_vs{6}), eval(all_vs{7}), eval(all_vs{8}), eval(all_vs{9}), eval(all_vs{1}),eval(all_vs{11}),eval(all_vs{12}), eval(all_vs{13}), eval(all_vs{14}), eval(all_vs{15}), eval(all_vs{16}), eval(all_vs{17}), eval(all_vs{18}), eval(all_vs{19}), eval(all_vs{10}),eval(all_vs{21}),eval(all_vs{22}), eval(all_vs{23}), eval(all_vs{20}), eval(all_vs{25}), eval(all_vs{26}), eval(all_vs{27}), eval(all_vs{28}), eval(all_vs{29}), eval(all_vs{30}),eval(all_vs{31}),eval(all_vs{32}), eval(all_vs{33}), eval(all_vs{34}), eval(all_vs{35}), eval(all_vs{36}), eval(all_vs{37}), eval(all_vs{38}), eval(all_vs{39}), eval(all_vs{40}),eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{24}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_64'), temp_AV_matrix); 
    assignin('base',strcat('AV_',current_v_name,'_leave_out_64_vector'), temp_AV_sim_vector); 
            [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{2}), eval(all_vs{3}), eval(all_vs{4}), eval(all_vs{5}), eval(all_vs{6}), eval(all_vs{7}), eval(all_vs{8}), eval(all_vs{9}), eval(all_vs{1}),eval(all_vs{11}),eval(all_vs{12}), eval(all_vs{13}), eval(all_vs{14}), eval(all_vs{15}), eval(all_vs{16}), eval(all_vs{17}), eval(all_vs{18}), eval(all_vs{19}), eval(all_vs{10}),eval(all_vs{21}),eval(all_vs{22}), eval(all_vs{23}), eval(all_vs{24}), eval(all_vs{20}), eval(all_vs{26}), eval(all_vs{27}), eval(all_vs{28}), eval(all_vs{29}), eval(all_vs{30}),eval(all_vs{31}),eval(all_vs{32}), eval(all_vs{33}), eval(all_vs{34}), eval(all_vs{35}), eval(all_vs{36}), eval(all_vs{37}), eval(all_vs{38}), eval(all_vs{39}), eval(all_vs{40}),eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{25}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_65'), temp_AV_matrix); 
    assignin('base',strcat('AV_',current_v_name,'_leave_out_65_vector'), temp_AV_sim_vector); 
            [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{2}), eval(all_vs{3}), eval(all_vs{4}), eval(all_vs{5}), eval(all_vs{6}), eval(all_vs{7}), eval(all_vs{8}), eval(all_vs{9}), eval(all_vs{1}),eval(all_vs{11}),eval(all_vs{12}), eval(all_vs{13}), eval(all_vs{14}), eval(all_vs{15}), eval(all_vs{16}), eval(all_vs{17}), eval(all_vs{18}), eval(all_vs{19}), eval(all_vs{10}),eval(all_vs{21}),eval(all_vs{22}), eval(all_vs{23}), eval(all_vs{24}), eval(all_vs{25}), eval(all_vs{20}), eval(all_vs{27}), eval(all_vs{28}), eval(all_vs{29}), eval(all_vs{30}),eval(all_vs{31}),eval(all_vs{32}), eval(all_vs{33}), eval(all_vs{34}), eval(all_vs{35}), eval(all_vs{36}), eval(all_vs{37}), eval(all_vs{38}), eval(all_vs{39}), eval(all_vs{40}),eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{26}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_66'), temp_AV_matrix); 
    assignin('base',strcat('AV_',current_v_name,'_leave_out_66_vector'), temp_AV_sim_vector); 
            [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{2}), eval(all_vs{3}), eval(all_vs{4}), eval(all_vs{5}), eval(all_vs{6}), eval(all_vs{7}), eval(all_vs{8}), eval(all_vs{9}), eval(all_vs{1}),eval(all_vs{11}),eval(all_vs{12}), eval(all_vs{13}), eval(all_vs{14}), eval(all_vs{15}), eval(all_vs{16}), eval(all_vs{17}), eval(all_vs{18}), eval(all_vs{19}), eval(all_vs{10}),eval(all_vs{21}),eval(all_vs{22}), eval(all_vs{23}), eval(all_vs{24}), eval(all_vs{25}), eval(all_vs{26}), eval(all_vs{20}), eval(all_vs{28}), eval(all_vs{29}), eval(all_vs{30}),eval(all_vs{31}),eval(all_vs{32}), eval(all_vs{33}), eval(all_vs{34}), eval(all_vs{35}), eval(all_vs{36}), eval(all_vs{37}), eval(all_vs{38}), eval(all_vs{39}), eval(all_vs{40}),eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{27}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_67'), temp_AV_matrix); 
    assignin('base',strcat('AV_',current_v_name,'_leave_out_67_vector'), temp_AV_sim_vector); 
            [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{2}), eval(all_vs{3}), eval(all_vs{4}), eval(all_vs{5}), eval(all_vs{6}), eval(all_vs{7}), eval(all_vs{8}), eval(all_vs{9}), eval(all_vs{1}),eval(all_vs{11}),eval(all_vs{12}), eval(all_vs{13}), eval(all_vs{14}), eval(all_vs{15}), eval(all_vs{16}), eval(all_vs{17}), eval(all_vs{18}), eval(all_vs{19}), eval(all_vs{10}),eval(all_vs{21}),eval(all_vs{22}), eval(all_vs{23}), eval(all_vs{24}), eval(all_vs{25}), eval(all_vs{26}), eval(all_vs{27}), eval(all_vs{20}), eval(all_vs{29}), eval(all_vs{30}),eval(all_vs{31}),eval(all_vs{32}), eval(all_vs{33}), eval(all_vs{34}), eval(all_vs{35}), eval(all_vs{36}), eval(all_vs{37}), eval(all_vs{38}), eval(all_vs{39}), eval(all_vs{40}),eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{28}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_68'), temp_AV_matrix); 
    assignin('base',strcat('AV_',current_v_name,'_leave_out_68_vector'), temp_AV_sim_vector); 
            [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{2}), eval(all_vs{3}), eval(all_vs{4}), eval(all_vs{5}), eval(all_vs{6}), eval(all_vs{7}), eval(all_vs{8}), eval(all_vs{9}), eval(all_vs{1}),eval(all_vs{11}),eval(all_vs{12}), eval(all_vs{13}), eval(all_vs{14}), eval(all_vs{15}), eval(all_vs{16}), eval(all_vs{17}), eval(all_vs{18}), eval(all_vs{19}), eval(all_vs{10}),eval(all_vs{21}),eval(all_vs{22}), eval(all_vs{23}), eval(all_vs{24}), eval(all_vs{25}), eval(all_vs{26}), eval(all_vs{27}), eval(all_vs{28}), eval(all_vs{20}), eval(all_vs{30}),eval(all_vs{31}),eval(all_vs{32}), eval(all_vs{33}), eval(all_vs{34}), eval(all_vs{35}), eval(all_vs{36}), eval(all_vs{37}), eval(all_vs{38}), eval(all_vs{39}), eval(all_vs{40}),eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{29}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_69'), temp_AV_matrix); 
    assignin('base',strcat('AV_',current_v_name,'_leave_out_69_vector'), temp_AV_sim_vector); 
            [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{2}), eval(all_vs{3}), eval(all_vs{4}), eval(all_vs{5}), eval(all_vs{6}), eval(all_vs{7}), eval(all_vs{8}), eval(all_vs{9}), eval(all_vs{1}),eval(all_vs{11}),eval(all_vs{12}), eval(all_vs{13}), eval(all_vs{14}), eval(all_vs{15}), eval(all_vs{16}), eval(all_vs{17}), eval(all_vs{18}), eval(all_vs{19}), eval(all_vs{10}),eval(all_vs{21}),eval(all_vs{22}), eval(all_vs{23}), eval(all_vs{24}), eval(all_vs{25}), eval(all_vs{26}), eval(all_vs{27}), eval(all_vs{28}), eval(all_vs{29}), eval(all_vs{20}),eval(all_vs{31}),eval(all_vs{32}), eval(all_vs{33}), eval(all_vs{34}), eval(all_vs{35}), eval(all_vs{36}), eval(all_vs{37}), eval(all_vs{38}), eval(all_vs{39}), eval(all_vs{40}),eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{30}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_70'), temp_AV_matrix); 
    assignin('base',strcat('AV_',current_v_name,'_leave_out_70_vector'), temp_AV_sim_vector); 
    
     [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{2}), eval(all_vs{3}), eval(all_vs{4}), eval(all_vs{5}), eval(all_vs{6}), eval(all_vs{7}), eval(all_vs{8}), eval(all_vs{9}), eval(all_vs{1}),eval(all_vs{11}),eval(all_vs{12}), eval(all_vs{13}), eval(all_vs{14}), eval(all_vs{15}), eval(all_vs{16}), eval(all_vs{17}), eval(all_vs{18}), eval(all_vs{19}), eval(all_vs{10}),eval(all_vs{21}),eval(all_vs{22}), eval(all_vs{23}), eval(all_vs{24}), eval(all_vs{25}), eval(all_vs{26}), eval(all_vs{27}), eval(all_vs{28}), eval(all_vs{29}), eval(all_vs{20}),eval(all_vs{30}),eval(all_vs{32}), eval(all_vs{33}), eval(all_vs{34}), eval(all_vs{35}), eval(all_vs{36}), eval(all_vs{37}), eval(all_vs{38}), eval(all_vs{39}), eval(all_vs{40}),eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{31}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_71'), temp_AV_matrix); 
    assignin('base',strcat('AV_',current_v_name,'_leave_out_71_vector'), temp_AV_sim_vector); 
    
     [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{2}), eval(all_vs{3}), eval(all_vs{4}), eval(all_vs{5}), eval(all_vs{6}), eval(all_vs{7}), eval(all_vs{8}), eval(all_vs{9}), eval(all_vs{1}),eval(all_vs{11}),eval(all_vs{12}), eval(all_vs{13}), eval(all_vs{14}), eval(all_vs{15}), eval(all_vs{16}), eval(all_vs{17}), eval(all_vs{18}), eval(all_vs{19}), eval(all_vs{10}),eval(all_vs{21}),eval(all_vs{22}), eval(all_vs{23}), eval(all_vs{24}), eval(all_vs{25}), eval(all_vs{26}), eval(all_vs{27}), eval(all_vs{28}), eval(all_vs{29}), eval(all_vs{20}),eval(all_vs{31}),eval(all_vs{30}), eval(all_vs{33}), eval(all_vs{34}), eval(all_vs{35}), eval(all_vs{36}), eval(all_vs{37}), eval(all_vs{38}), eval(all_vs{39}), eval(all_vs{40}),eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{32}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_72'), temp_AV_matrix); 
    assignin('base',strcat('AV_',current_v_name,'_leave_out_72_vector'), temp_AV_sim_vector); 
    
     [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{2}), eval(all_vs{3}), eval(all_vs{4}), eval(all_vs{5}), eval(all_vs{6}), eval(all_vs{7}), eval(all_vs{8}), eval(all_vs{9}), eval(all_vs{1}),eval(all_vs{11}),eval(all_vs{12}), eval(all_vs{13}), eval(all_vs{14}), eval(all_vs{15}), eval(all_vs{16}), eval(all_vs{17}), eval(all_vs{18}), eval(all_vs{19}), eval(all_vs{10}),eval(all_vs{21}),eval(all_vs{22}), eval(all_vs{23}), eval(all_vs{24}), eval(all_vs{25}), eval(all_vs{26}), eval(all_vs{27}), eval(all_vs{28}), eval(all_vs{29}), eval(all_vs{20}),eval(all_vs{31}),eval(all_vs{32}), eval(all_vs{30}), eval(all_vs{34}), eval(all_vs{35}), eval(all_vs{36}), eval(all_vs{37}), eval(all_vs{38}), eval(all_vs{39}), eval(all_vs{40}),eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{33}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_73'), temp_AV_matrix); 
    assignin('base',strcat('AV_',current_v_name,'_leave_out_73_vector'), temp_AV_sim_vector); 
    
     [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{2}), eval(all_vs{3}), eval(all_vs{4}), eval(all_vs{5}), eval(all_vs{6}), eval(all_vs{7}), eval(all_vs{8}), eval(all_vs{9}), eval(all_vs{1}),eval(all_vs{11}),eval(all_vs{12}), eval(all_vs{13}), eval(all_vs{14}), eval(all_vs{15}), eval(all_vs{16}), eval(all_vs{17}), eval(all_vs{18}), eval(all_vs{19}), eval(all_vs{10}),eval(all_vs{21}),eval(all_vs{22}), eval(all_vs{23}), eval(all_vs{24}), eval(all_vs{25}), eval(all_vs{26}), eval(all_vs{27}), eval(all_vs{28}), eval(all_vs{29}), eval(all_vs{20}),eval(all_vs{31}),eval(all_vs{32}), eval(all_vs{33}), eval(all_vs{30}), eval(all_vs{35}), eval(all_vs{36}), eval(all_vs{37}), eval(all_vs{38}), eval(all_vs{39}), eval(all_vs{40}),eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{34}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_74'), temp_AV_matrix); 
    assignin('base',strcat('AV_',current_v_name,'_leave_out_74_vector'), temp_AV_sim_vector); 
    
     [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{2}), eval(all_vs{3}), eval(all_vs{4}), eval(all_vs{5}), eval(all_vs{6}), eval(all_vs{7}), eval(all_vs{8}), eval(all_vs{9}), eval(all_vs{1}),eval(all_vs{11}),eval(all_vs{12}), eval(all_vs{13}), eval(all_vs{14}), eval(all_vs{15}), eval(all_vs{16}), eval(all_vs{17}), eval(all_vs{18}), eval(all_vs{19}), eval(all_vs{10}),eval(all_vs{21}),eval(all_vs{22}), eval(all_vs{23}), eval(all_vs{24}), eval(all_vs{25}), eval(all_vs{26}), eval(all_vs{27}), eval(all_vs{28}), eval(all_vs{29}), eval(all_vs{20}),eval(all_vs{31}),eval(all_vs{32}), eval(all_vs{33}), eval(all_vs{34}), eval(all_vs{30}), eval(all_vs{36}), eval(all_vs{37}), eval(all_vs{38}), eval(all_vs{39}), eval(all_vs{40}),eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{35}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_75'), temp_AV_matrix); 
    assignin('base',strcat('AV_',current_v_name,'_leave_out_75_vector'), temp_AV_sim_vector); 
    
     [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{2}), eval(all_vs{3}), eval(all_vs{4}), eval(all_vs{5}), eval(all_vs{6}), eval(all_vs{7}), eval(all_vs{8}), eval(all_vs{9}), eval(all_vs{1}),eval(all_vs{11}),eval(all_vs{12}), eval(all_vs{13}), eval(all_vs{14}), eval(all_vs{15}), eval(all_vs{16}), eval(all_vs{17}), eval(all_vs{18}), eval(all_vs{19}), eval(all_vs{10}),eval(all_vs{21}),eval(all_vs{22}), eval(all_vs{23}), eval(all_vs{24}), eval(all_vs{25}), eval(all_vs{26}), eval(all_vs{27}), eval(all_vs{28}), eval(all_vs{29}), eval(all_vs{20}),eval(all_vs{31}),eval(all_vs{32}), eval(all_vs{33}), eval(all_vs{34}), eval(all_vs{35}), eval(all_vs{30}), eval(all_vs{37}), eval(all_vs{38}), eval(all_vs{39}), eval(all_vs{40}),eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{36}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_76'), temp_AV_matrix); 
    assignin('base',strcat('AV_',current_v_name,'_leave_out_76_vector'), temp_AV_sim_vector); 
    
     [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{2}), eval(all_vs{3}), eval(all_vs{4}), eval(all_vs{5}), eval(all_vs{6}), eval(all_vs{7}), eval(all_vs{8}), eval(all_vs{9}), eval(all_vs{1}),eval(all_vs{11}),eval(all_vs{12}), eval(all_vs{13}), eval(all_vs{14}), eval(all_vs{15}), eval(all_vs{16}), eval(all_vs{17}), eval(all_vs{18}), eval(all_vs{19}), eval(all_vs{10}),eval(all_vs{21}),eval(all_vs{22}), eval(all_vs{23}), eval(all_vs{24}), eval(all_vs{25}), eval(all_vs{26}), eval(all_vs{27}), eval(all_vs{28}), eval(all_vs{29}), eval(all_vs{20}),eval(all_vs{31}),eval(all_vs{32}), eval(all_vs{33}), eval(all_vs{34}), eval(all_vs{35}), eval(all_vs{36}), eval(all_vs{30}), eval(all_vs{38}), eval(all_vs{39}), eval(all_vs{40}),eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{37}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_77'), temp_AV_matrix); 
    assignin('base',strcat('AV_',current_v_name,'_leave_out_77_vector'), temp_AV_sim_vector); 
    
     [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{2}), eval(all_vs{3}), eval(all_vs{4}), eval(all_vs{5}), eval(all_vs{6}), eval(all_vs{7}), eval(all_vs{8}), eval(all_vs{9}), eval(all_vs{1}),eval(all_vs{11}),eval(all_vs{12}), eval(all_vs{13}), eval(all_vs{14}), eval(all_vs{15}), eval(all_vs{16}), eval(all_vs{17}), eval(all_vs{18}), eval(all_vs{19}), eval(all_vs{10}),eval(all_vs{21}),eval(all_vs{22}), eval(all_vs{23}), eval(all_vs{24}), eval(all_vs{25}), eval(all_vs{26}), eval(all_vs{27}), eval(all_vs{28}), eval(all_vs{29}), eval(all_vs{20}),eval(all_vs{31}),eval(all_vs{32}), eval(all_vs{33}), eval(all_vs{34}), eval(all_vs{35}), eval(all_vs{36}), eval(all_vs{37}), eval(all_vs{30}), eval(all_vs{39}), eval(all_vs{40}),eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{38}), eval(all_vs{79}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_78'), temp_AV_matrix); 
    assignin('base',strcat('AV_',current_v_name,'_leave_out_78_vector'), temp_AV_sim_vector); 
    
     [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{2}), eval(all_vs{3}), eval(all_vs{4}), eval(all_vs{5}), eval(all_vs{6}), eval(all_vs{7}), eval(all_vs{8}), eval(all_vs{9}), eval(all_vs{1}),eval(all_vs{11}),eval(all_vs{12}), eval(all_vs{13}), eval(all_vs{14}), eval(all_vs{15}), eval(all_vs{16}), eval(all_vs{17}), eval(all_vs{18}), eval(all_vs{19}), eval(all_vs{10}),eval(all_vs{21}),eval(all_vs{22}), eval(all_vs{23}), eval(all_vs{24}), eval(all_vs{25}), eval(all_vs{26}), eval(all_vs{27}), eval(all_vs{28}), eval(all_vs{29}), eval(all_vs{20}),eval(all_vs{31}),eval(all_vs{32}), eval(all_vs{33}), eval(all_vs{34}), eval(all_vs{35}), eval(all_vs{36}), eval(all_vs{37}), eval(all_vs{38}), eval(all_vs{30}), eval(all_vs{40}),eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{39}), eval(all_vs{80}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_79'), temp_AV_matrix); 
    assignin('base',strcat('AV_',current_v_name,'_leave_out_79_vector'), temp_AV_sim_vector); 
    
     [temp_AV_matrix, temp_AV_sim_vector] = MAKE_AV_SIM_MATRIX_any_number_control(eval(all_vs{2}), eval(all_vs{3}), eval(all_vs{4}), eval(all_vs{5}), eval(all_vs{6}), eval(all_vs{7}), eval(all_vs{8}), eval(all_vs{9}), eval(all_vs{1}),eval(all_vs{11}),eval(all_vs{12}), eval(all_vs{13}), eval(all_vs{14}), eval(all_vs{15}), eval(all_vs{16}), eval(all_vs{17}), eval(all_vs{18}), eval(all_vs{19}), eval(all_vs{10}),eval(all_vs{21}),eval(all_vs{22}), eval(all_vs{23}), eval(all_vs{24}), eval(all_vs{25}), eval(all_vs{26}), eval(all_vs{27}), eval(all_vs{28}), eval(all_vs{29}), eval(all_vs{20}),eval(all_vs{31}),eval(all_vs{32}), eval(all_vs{33}), eval(all_vs{34}), eval(all_vs{35}), eval(all_vs{36}), eval(all_vs{37}), eval(all_vs{38}), eval(all_vs{39}), eval(all_vs{30}),eval(all_vs{41}),eval(all_vs{42}), eval(all_vs{43}), eval(all_vs{44}), eval(all_vs{45}), eval(all_vs{46}), eval(all_vs{47}), eval(all_vs{48}), eval(all_vs{49}), eval(all_vs{50}),eval(all_vs{51}),eval(all_vs{52}), eval(all_vs{53}), eval(all_vs{54}), eval(all_vs{55}), eval(all_vs{56}), eval(all_vs{57}), eval(all_vs{58}), eval(all_vs{59}), eval(all_vs{60}),eval(all_vs{61}), eval(all_vs{62}), eval(all_vs{63}), eval(all_vs{64}), eval(all_vs{65}), eval(all_vs{66}), eval(all_vs{67}), eval(all_vs{68}), eval(all_vs{69}), eval(all_vs{70}),eval(all_vs{71}),eval(all_vs{72}), eval(all_vs{73}), eval(all_vs{74}), eval(all_vs{75}), eval(all_vs{76}), eval(all_vs{77}), eval(all_vs{78}), eval(all_vs{79}), eval(all_vs{40}), num_ex);
    assignin('base',strcat('AV_',current_v_name, '_leave_out_80'), temp_AV_matrix); 
    assignin('base',strcat('AV_',current_v_name,'_leave_out_80_vector'), temp_AV_sim_vector); 
        
    end

end

%% correlation of each runs rep similarity to the leave one out average per variable- loop v's
%alt get matrices for all leave on out and all results vectors with horzcat
%when create
leave_one_out_consistency_results = zeros(length(v_name),size(all_files,1));%make leave one out consistency matrix of all variables*all runs %for shallow includes input-based 3 way split

for i = 1:length(v_name);
    current_v_name = v_name{i};
      
    %for current variable- gets the versions of it per run, r = run
    for r=1:size(all_files,1);
        all_vs_vectors{r} = strcat(current_v_name,'_', num2str(r),'_vector');
        all_vs_leave_one_out_vectors{r} = strcat('AV_',current_v_name,'_leave_out_', num2str(r) ,'_vector');
    end  
    %get correlation between each runs vector and leave one out vector for each variable 
    for r=1:size(all_files,1);               
    temp_ans = corrcoef(eval(all_vs_vectors{r}),eval(strcat('AV_',current_v_name,'_leave_out_', num2str(r) ,'_vector')));
    leave_one_out_consistency_results(i,r) = temp_ans(2, 1);   
    end 
end

%% compare vectors to example script - LOOPS THROUGH DIFF EXAMPLE STRUCTURES FOR CONTROL
for control = 1:3;%control = 1; % 0 = no control, rest = basic control but assess examples structure differently 1 = main structure of underlying sem, 2 = output-based controlled sem, 3 = ouput modality regardless of sem - no control should work fine here so use this script for all
    %CHANGE BASE DIRECTORY HERE IF CHANGED WHERE SAVED - LEAVE REFERENCE TO
    %SUBFOLDERS BY CONTROL
    if control == 1;
    examples_dir = 'C:\lens\my_scripts\hierarchical_model\example_structure\FIXED_EX\fixed_ex_basic_control_MAIN'; % still need examples scripts ran - underlying sem - same as w/o control (but larger matrix)
    %results_folder = 'MAIN/'; % figs overwrite but same anyway so fine
    end
    if control == 2;
    examples_dir = 'C:\lens\my_scripts\hierarchical_model\example_structure\FIXED_EX\fixed_ex_basic_control_CONTROLLED_OUTPUT'; % still need examples scripts ran - is main .* control signal, is full output (which inc input)
     % results_folder = 'CONTROLLED_OUTPUT/';
    end
    if control == 3;
    examples_dir = 'C:\lens\my_scripts\hierarchical_model\example_structure\FIXED_EX\fixed_ex_basic_control_OUTPUT_MODALITIES'; % still need examples scripts ran - is now input + output mod as same and same as control signal
     % results_folder = 'OUTPUT_MODALITY/';
    end   


example_workspace_name = strcat(examples_dir, '\examples_UNITBASED_CORRELATION_MATRICES_workspace');
load(example_workspace_name, 'sim_multi_UNIT_examples_48_vector', 'sim_uni_M1_UNIT_examples_48_vector', 'sim_uni_M2_UNIT_examples_48_vector', 'sim_uni_M3_UNIT_examples_48_vector', 'sim_multi_M1_UNIT_examples_48_vector', 'sim_multi_M2_UNIT_examples_48_vector', 'sim_multi_M3_UNIT_examples_48_vector','sim_uni_M1_M2_M3_UNIT_examples_48_vector','sim_uni_M1_M2_UNIT_examples_48_vector','sim_uni_M1_M3_UNIT_examples_48_vector','sim_uni_M2_M3_UNIT_examples_48_vector', 'sim_multi_and_uni_M1_M2_M3_UNIT_examples_48_vector', 'sim_multi_and_uni_M1_M2_UNIT_examples_48_vector', 'sim_multi_and_uni_M1_M3_UNIT_examples_48_vector', 'sim_multi_and_uni_M2_M3_UNIT_examples_48_vector', 'sim_multi_and_uni_M1_UNIT_examples_48_vector', 'sim_multi_and_uni_M2_UNIT_examples_48_vector', 'sim_multi_and_uni_M3_UNIT_examples_48_vector','sim_fullest_UNIT_examples_48_vector');

%put all examples variables in cell array to loop through once - call e
%list all examples variables (example structures) to loop through
ex_name{1} = 'sim_multi_UNIT_examples_48_vector';
ex_name{2} = 'sim_uni_M1_UNIT_examples_48_vector';
ex_name{3} = 'sim_uni_M2_UNIT_examples_48_vector';
ex_name{4} = 'sim_uni_M3_UNIT_examples_48_vector';
ex_name{5} = 'sim_multi_and_uni_M1_M2_M3_UNIT_examples_48_vector';
ex_name{6} = 'sim_multi_and_uni_M1_UNIT_examples_48_vector';
ex_name{7} = 'sim_multi_and_uni_M2_UNIT_examples_48_vector';
ex_name{8} = 'sim_multi_and_uni_M3_UNIT_examples_48_vector';
ex_name{9} = 'sim_multi_and_uni_M1_M2_UNIT_examples_48_vector';
ex_name{10} = 'sim_multi_and_uni_M1_M3_UNIT_examples_48_vector';
ex_name{11} = 'sim_multi_and_uni_M2_M3_UNIT_examples_48_vector';
ex_name{12} = 'sim_uni_M1_M2_UNIT_examples_48_vector';
ex_name{13} = 'sim_uni_M1_M3_UNIT_examples_48_vector';
ex_name{14} = 'sim_uni_M2_M3_UNIT_examples_48_vector';
ex_name{15} = 'sim_uni_M1_M2_M3_UNIT_examples_48_vector';
ex_name{16} = 'sim_multi_M1_UNIT_examples_48_vector';
ex_name{17} = 'sim_multi_M2_UNIT_examples_48_vector';
ex_name{18} = 'sim_multi_M3_UNIT_examples_48_vector';
ex_name{19} = 'sim_fullest_UNIT_examples_48_vector';


e = length(ex_name);
i=length(v_name);
%make results matrices for av + each p (in 1 big matrix)
av_results_vs_all_examples = zeros(e, i); % want to depend on no v's in results and examples
per_p_results_vs_all_examples = zeros(e, (size(all_files,1)*i)); %make go through p1's results then p2's etc - 10 runs * results variables
%av over runs similarity results so tables fit stats better
AV_OVER_RUNS_FOR_TABLES_vs_all_examples_full_table = zeros(e, i);
TEMP_SUM =0;

%loop through e
for e = 1:length(ex_name);  
    current_ex_name = ex_name{e}; 
%   loop through variables (within examples loop
    for i = 1:length(v_name);
    current_v_name = v_name{i};
    
    %do average of sim matrices across runs vs examples structures
    temp_ans = corrcoef(eval(ex_name{e}),eval(strcat('AV_',current_v_name,'_vector')));
    av_results_vs_all_examples(e,i) = temp_ans(2, 1); 
     
    %loop through model runs
        for r=1:(size(all_files,1));
        temp_ans = corrcoef(eval(ex_name{e}),eval(strcat(current_v_name,'_',num2str(r) ,'_vector')));
        per_p_results_vs_all_examples(e,((length(v_name)*(r-1)+i))) = temp_ans(2, 1);
        TEMP_SUM =TEMP_SUM +temp_ans(2, 1);
        end
        AV_OVER_RUNS_FOR_TABLES_vs_all_examples_full_table(e,i) =TEMP_SUM/(size(all_files,1));
        TEMP_SUM =0;
    end 
end


%% making full tables of diff results for now -ADDED NEW 3 DIV IN BEFORE HU1 AND THEN DEEP ONLY PARTS - check 
average_consistency_results = mean(leave_one_out_consistency_results,2);

consistency_output_full_table(1,1) = average_consistency_results(5); %6 DIV
consistency_output_full_table(2,1) = average_consistency_results(6);
consistency_output_full_table(3,1) = average_consistency_results(7);
consistency_output_full_table(4,1) = average_consistency_results(8);
consistency_output_full_table(5,1) = average_consistency_results(9);
consistency_output_full_table(6,1) = average_consistency_results(10);
consistency_output_full_table(7,1) = average_consistency_results(1); %ORIG 3 DIV
consistency_output_full_table(8,1) = average_consistency_results(2);
consistency_output_full_table(9,1) = average_consistency_results(3);
consistency_output_full_table(10,1) =average_consistency_results(15);%NEW IB 3 DIV
consistency_output_full_table(11,1) =average_consistency_results(16);
consistency_output_full_table(12,1) =average_consistency_results(17);
consistency_output_full_table(13,1) =average_consistency_results(4); %HU1
if deep ==1;
    consistency_output_full_table(14,1) =average_consistency_results(18); %HU2
    consistency_output_full_table(15,1) =average_consistency_results(19); % ALL HU
end 

if deep >1;
    consistency_output_full_table(14,1) =average_consistency_results(18); %HU2
    consistency_output_full_table(15,1) =average_consistency_results(20); %HU3
end

if deep ==2;   
    consistency_output_full_table(16,1) =average_consistency_results(19); % ALL HU
end

if deep ==3;
        consistency_output_full_table(16,1) =average_consistency_results(21); %HU4
        consistency_output_full_table(17,1) =average_consistency_results(19); % ALL HU
end

%getting take home distance from fuller (all units) structure in important results areas on average run 
%IF CHANGE ORDER OF MODEL AREAS OR CHANGE COMPLETELY WILL BE WRONG
%is only fuller ex structure now not full

dist_from_fuller_structure_full_table(1,1)=av_results_vs_all_examples(19,12);
dist_from_fuller_structure_full_table(2,1)=av_results_vs_all_examples(19,13);
dist_from_fuller_structure_full_table(3,1)=av_results_vs_all_examples(19,14);
dist_from_fuller_structure_full_table(4,1)=av_results_vs_all_examples(19,5);
dist_from_fuller_structure_full_table(5,1)=av_results_vs_all_examples(19,6);
dist_from_fuller_structure_full_table(6,1)=av_results_vs_all_examples(19,7);
dist_from_fuller_structure_full_table(7,1)=av_results_vs_all_examples(19,8);
dist_from_fuller_structure_full_table(8,1)=av_results_vs_all_examples(19,9);
dist_from_fuller_structure_full_table(9,1)=av_results_vs_all_examples(19,10);
dist_from_fuller_structure_full_table(10,1)=av_results_vs_all_examples(19,1);
dist_from_fuller_structure_full_table(11,1)=av_results_vs_all_examples(19,2);
dist_from_fuller_structure_full_table(12,1)=av_results_vs_all_examples(19,3);
dist_from_fuller_structure_full_table(13,1)=av_results_vs_all_examples(19,15);
dist_from_fuller_structure_full_table(14,1)=av_results_vs_all_examples(19,16);
dist_from_fuller_structure_full_table(15,1)=av_results_vs_all_examples(19,17);
dist_from_fuller_structure_full_table(16,1)=av_results_vs_all_examples(19,4);

if deep ==1;
    dist_from_fuller_structure_full_table(17,1)=av_results_vs_all_examples(19,18); %hu2
    dist_from_fuller_structure_full_table(18,1)=av_results_vs_all_examples(19,19);%all hu
end

if deep>1;
        dist_from_fuller_structure_full_table(17,1)=av_results_vs_all_examples(19,18); %hu2
        dist_from_fuller_structure_full_table(18,1)=av_results_vs_all_examples(19,20); %hu3
end

if deep ==2;
        dist_from_fuller_structure_full_table(19,1)=av_results_vs_all_examples(19,19);%all hu
end

  
%SAME BUT USING AV OVER EACH RUNS RESULTS SO TABLE FITS STATS BETTER
if deep ==1;
AV_OVER_RUNS_FOR_TABLES_dist_from_fuller_structure_full_table = zeros(18,1);
end
if deep==0;
AV_OVER_RUNS_FOR_TABLES_dist_from_fuller_structure_full_table = zeros(16,1);
end

AV_OVER_RUNS_FOR_TABLES_dist_from_fuller_structure_full_table(1,1)=AV_OVER_RUNS_FOR_TABLES_vs_all_examples_full_table(19,12);
AV_OVER_RUNS_FOR_TABLES_dist_from_fuller_structure_full_table(2,1)=AV_OVER_RUNS_FOR_TABLES_vs_all_examples_full_table(19,13);
AV_OVER_RUNS_FOR_TABLES_dist_from_fuller_structure_full_table(3,1)=AV_OVER_RUNS_FOR_TABLES_vs_all_examples_full_table(19,14);
AV_OVER_RUNS_FOR_TABLES_dist_from_fuller_structure_full_table(4,1)=AV_OVER_RUNS_FOR_TABLES_vs_all_examples_full_table(19,5);
AV_OVER_RUNS_FOR_TABLES_dist_from_fuller_structure_full_table(5,1)=AV_OVER_RUNS_FOR_TABLES_vs_all_examples_full_table(19,6);
AV_OVER_RUNS_FOR_TABLES_dist_from_fuller_structure_full_table(6,1)=AV_OVER_RUNS_FOR_TABLES_vs_all_examples_full_table(19,7);
AV_OVER_RUNS_FOR_TABLES_dist_from_fuller_structure_full_table(7,1)=AV_OVER_RUNS_FOR_TABLES_vs_all_examples_full_table(19,8);
AV_OVER_RUNS_FOR_TABLES_dist_from_fuller_structure_full_table(8,1)=AV_OVER_RUNS_FOR_TABLES_vs_all_examples_full_table(19,9);
AV_OVER_RUNS_FOR_TABLES_dist_from_fuller_structure_full_table(9,1)=AV_OVER_RUNS_FOR_TABLES_vs_all_examples_full_table(19,10);
AV_OVER_RUNS_FOR_TABLES_dist_from_fuller_structure_full_table(10,1)=AV_OVER_RUNS_FOR_TABLES_vs_all_examples_full_table(19,1);
AV_OVER_RUNS_FOR_TABLES_dist_from_fuller_structure_full_table(11,1)=AV_OVER_RUNS_FOR_TABLES_vs_all_examples_full_table(19,2);
AV_OVER_RUNS_FOR_TABLES_dist_from_fuller_structure_full_table(12,1)=AV_OVER_RUNS_FOR_TABLES_vs_all_examples_full_table(19,3);
AV_OVER_RUNS_FOR_TABLES_dist_from_fuller_structure_full_table(13,1)=AV_OVER_RUNS_FOR_TABLES_vs_all_examples_full_table(19,15);
AV_OVER_RUNS_FOR_TABLES_dist_from_fuller_structure_full_table(14,1)=AV_OVER_RUNS_FOR_TABLES_vs_all_examples_full_table(19,16);
AV_OVER_RUNS_FOR_TABLES_dist_from_fuller_structure_full_table(15,1)=AV_OVER_RUNS_FOR_TABLES_vs_all_examples_full_table(19,17);
AV_OVER_RUNS_FOR_TABLES_dist_from_fuller_structure_full_table(16,1)=AV_OVER_RUNS_FOR_TABLES_vs_all_examples_full_table(19,4);

if deep ==1;
    AV_OVER_RUNS_FOR_TABLES_dist_from_fuller_structure_full_table(17,1)=AV_OVER_RUNS_FOR_TABLES_vs_all_examples_full_table(19,18);
    AV_OVER_RUNS_FOR_TABLES_dist_from_fuller_structure_full_table(18,1)=AV_OVER_RUNS_FOR_TABLES_vs_all_examples_full_table(19,19);
end

if deep ==2;
    AV_OVER_RUNS_FOR_TABLES_dist_from_fuller_structure_full_table(17,1)=AV_OVER_RUNS_FOR_TABLES_vs_all_examples_full_table(19,18);
    AV_OVER_RUNS_FOR_TABLES_dist_from_fuller_structure_full_table(18,1)=AV_OVER_RUNS_FOR_TABLES_vs_all_examples_full_table(19,20);
    AV_OVER_RUNS_FOR_TABLES_dist_from_fuller_structure_full_table(19,1)=AV_OVER_RUNS_FOR_TABLES_vs_all_examples_full_table(19,19);
end

if deep ==3;
    AV_OVER_RUNS_FOR_TABLES_dist_from_fuller_structure_full_table(17,1)=AV_OVER_RUNS_FOR_TABLES_vs_all_examples_full_table(19,18);
    AV_OVER_RUNS_FOR_TABLES_dist_from_fuller_structure_full_table(18,1)=AV_OVER_RUNS_FOR_TABLES_vs_all_examples_full_table(19,20);
        AV_OVER_RUNS_FOR_TABLES_dist_from_fuller_structure_full_table(19,1)=AV_OVER_RUNS_FOR_TABLES_vs_all_examples_full_table(19,21);
    AV_OVER_RUNS_FOR_TABLES_dist_from_fuller_structure_full_table(20,1)=AV_OVER_RUNS_FOR_TABLES_vs_all_examples_full_table(19,19);
end

%getting take home distance from full(multi+uni*3 units) or fuller (all
%units) structure in important results areas PER RUN FOR STATS - IF CHANGE ORDER OF MODEL AREAS OR CHANGE
%COMPLETELY WILL BE WRONG- could make easier by reordering
%per_p_results_vs_all_examples in new variable then just selecting correct
%rows (/columns?)
if deep ==0;
dist_from_fuller_structure_per_run_full_table = zeros(size(all_files,1),16);
dist_from_single_structures_per_run_full_table= zeros(size(all_files,1),16);
else 
dist_from_fuller_structure_per_run_full_table = zeros(size(all_files,1),18);
dist_from_single_structures_per_run_full_table=zeros(size(all_files,1),18);
end

for r=1:size(all_files,1);
    
  dist_from_fuller_structure_per_run_full_table(r,1)=per_p_results_vs_all_examples(19,(length(v_name)*(r-1)+12));
        dist_from_fuller_structure_per_run_full_table(r,2)=per_p_results_vs_all_examples(19,(length(v_name)*(r-1)+13));
    dist_from_fuller_structure_per_run_full_table(r,3)=per_p_results_vs_all_examples(19,(length(v_name)*(r-1)+14));
  dist_from_fuller_structure_per_run_full_table(r,4)=per_p_results_vs_all_examples(19,(length(v_name)*(r-1)+5));
   dist_from_fuller_structure_per_run_full_table(r,5)=per_p_results_vs_all_examples(19,(length(v_name)*(r-1)+6));
    dist_from_fuller_structure_per_run_full_table(r,6)=per_p_results_vs_all_examples(19,(length(v_name)*(r-1)+7));
     dist_from_fuller_structure_per_run_full_table(r,7)=per_p_results_vs_all_examples(19,(length(v_name)*(r-1)+8));
      dist_from_fuller_structure_per_run_full_table(r,8)=per_p_results_vs_all_examples(19,(length(v_name)*(r-1)+9));
       dist_from_fuller_structure_per_run_full_table(r,9)=per_p_results_vs_all_examples(19,(length(v_name)*(r-1)+10));     
        dist_from_fuller_structure_per_run_full_table(r,10)=per_p_results_vs_all_examples(19,(length(v_name)*(r-1)+1));
    dist_from_fuller_structure_per_run_full_table(r,11)=per_p_results_vs_all_examples(19,(length(v_name)*(r-1)+2));
      dist_from_fuller_structure_per_run_full_table(r,12)=per_p_results_vs_all_examples(19,(length(v_name)*(r-1)+3));
            dist_from_fuller_structure_per_run_full_table(r,13)=per_p_results_vs_all_examples(19,(length(v_name)*(r-1)+15));
            dist_from_fuller_structure_per_run_full_table(r,14)=per_p_results_vs_all_examples(19,(length(v_name)*(r-1)+16));
    dist_from_fuller_structure_per_run_full_table(r,15)=per_p_results_vs_all_examples(19,(length(v_name)*(r-1)+17));    
    dist_from_fuller_structure_per_run_full_table(r,16)=per_p_results_vs_all_examples(19,(length(v_name)*(r-1)+4));              
  if deep ==1;
    dist_from_fuller_structure_per_run_full_table(r,17)=per_p_results_vs_all_examples(19,(length(v_name)*(r-1)+18));
    dist_from_fuller_structure_per_run_full_table(r,18)=per_p_results_vs_all_examples(19,(length(v_name)*(r-1)+19));
  end
      
  dist_from_single_structures_per_run_full_table(r,1)=per_p_results_vs_all_examples(1,(length(v_name)*(r-1)+12));
    dist_from_single_structures_per_run_full_table(r,2)=per_p_results_vs_all_examples(1,(length(v_name)*(r-1)+13));
    dist_from_single_structures_per_run_full_table(r,3)=per_p_results_vs_all_examples(1,(length(v_name)*(r-1)+14));
  dist_from_single_structures_per_run_full_table(r,4)=per_p_results_vs_all_examples(1,(length(v_name)*(r-1)+5));
   dist_from_single_structures_per_run_full_table(r,5)=per_p_results_vs_all_examples(1,(length(v_name)*(r-1)+6));
    dist_from_single_structures_per_run_full_table(r,6)=per_p_results_vs_all_examples(1,(length(v_name)*(r-1)+7));
     dist_from_single_structures_per_run_full_table(r,7)=per_p_results_vs_all_examples(1,(length(v_name)*(r-1)+8));
      dist_from_single_structures_per_run_full_table(r,8)=per_p_results_vs_all_examples(1,(length(v_name)*(r-1)+9));
       dist_from_single_structures_per_run_full_table(r,9)=per_p_results_vs_all_examples(1,(length(v_name)*(r-1)+10));     
        dist_from_single_structures_per_run_full_table(r,10)=per_p_results_vs_all_examples(1,(length(v_name)*(r-1)+1));
    dist_from_single_structures_per_run_full_table(r,11)=per_p_results_vs_all_examples(1,(length(v_name)*(r-1)+2));
      dist_from_single_structures_per_run_full_table(r,12)=per_p_results_vs_all_examples(1,(length(v_name)*(r-1)+3));
            dist_from_single_structures_per_run_full_table(r,13)=per_p_results_vs_all_examples(1,(length(v_name)*(r-1)+15));
                dist_from_single_structures_per_run_full_table(r,14)=per_p_results_vs_all_examples(1,(length(v_name)*(r-1)+16));
    dist_from_single_structures_per_run_full_table(r,15)=per_p_results_vs_all_examples(1,(length(v_name)*(r-1)+17));
    dist_from_single_structures_per_run_full_table(r,16)=per_p_results_vs_all_examples(1,(length(v_name)*(r-1)+4));
  if deep ==1;
    dist_from_single_structures_per_run_full_table(r,17)=per_p_results_vs_all_examples(1,(length(v_name)*(r-1)+18));
    dist_from_single_structures_per_run_full_table(r,18)=per_p_results_vs_all_examples(1,(length(v_name)*(r-1)+19));
  end
  
%     if deep ==2;
%     dist_from_single_structures_per_run_full_table(r,17)=per_p_results_vs_all_examples(1,(length(v_name)*(r-1)+18));
%         dist_from_single_structures_per_run_full_table(r,18)=per_p_results_vs_all_examples(1,(length(v_name)*(r-1)+20));
%     dist_from_single_structures_per_run_full_table(r,19)=per_p_results_vs_all_examples(1,(length(v_name)*(r-1)+19));
%   end
%       if deep ==3;
%     dist_from_single_structures_per_run_full_table(r,17)=per_p_results_vs_all_examples(1,(length(v_name)*(r-1)+18));
%         dist_from_single_structures_per_run_full_table(r,18)=per_p_results_vs_all_examples(1,(length(v_name)*(r-1)+20));
%                 dist_from_single_structures_per_run_full_table(r,19)=per_p_results_vs_all_examples(1,(length(v_name)*(r-1)+21));
%     dist_from_single_structures_per_run_full_table(r,20)=per_p_results_vs_all_examples(1,(length(v_name)*(r-1)+19));
%   end
   dist_from_single_structures_per_run_full_table(r+size(all_files,1),1)=per_p_results_vs_all_examples(2,(length(v_name)*(r-1)+12));
    dist_from_single_structures_per_run_full_table(r+size(all_files,1),2)=per_p_results_vs_all_examples(2,(length(v_name)*(r-1)+13));
    dist_from_single_structures_per_run_full_table(r+size(all_files,1),3)=per_p_results_vs_all_examples(2,(length(v_name)*(r-1)+14));
  dist_from_single_structures_per_run_full_table(r+size(all_files,1),4)=per_p_results_vs_all_examples(2,(length(v_name)*(r-1)+5));
   dist_from_single_structures_per_run_full_table(r+size(all_files,1),5)=per_p_results_vs_all_examples(2,(length(v_name)*(r-1)+6));
    dist_from_single_structures_per_run_full_table(r+size(all_files,1),6)=per_p_results_vs_all_examples(2,(length(v_name)*(r-1)+7));
     dist_from_single_structures_per_run_full_table(r+size(all_files,1),7)=per_p_results_vs_all_examples(2,(length(v_name)*(r-1)+8));
      dist_from_single_structures_per_run_full_table(r+size(all_files,1),8)=per_p_results_vs_all_examples(2,(length(v_name)*(r-1)+9));
       dist_from_single_structures_per_run_full_table(r+size(all_files,1),9)=per_p_results_vs_all_examples(2,(length(v_name)*(r-1)+10));     
        dist_from_single_structures_per_run_full_table(r+size(all_files,1),10)=per_p_results_vs_all_examples(2,(length(v_name)*(r-1)+1));
    dist_from_single_structures_per_run_full_table(r+size(all_files,1),11)=per_p_results_vs_all_examples(2,(length(v_name)*(r-1)+2));
      dist_from_single_structures_per_run_full_table(r+size(all_files,1),12)=per_p_results_vs_all_examples(2,(length(v_name)*(r-1)+3));
            dist_from_single_structures_per_run_full_table(r+size(all_files,1),13)=per_p_results_vs_all_examples(2,(length(v_name)*(r-1)+15));
                dist_from_single_structures_per_run_full_table(r+size(all_files,1),14)=per_p_results_vs_all_examples(2,(length(v_name)*(r-1)+16));
    dist_from_single_structures_per_run_full_table(r+size(all_files,1),15)=per_p_results_vs_all_examples(2,(length(v_name)*(r-1)+17));
        dist_from_single_structures_per_run_full_table(r+size(all_files,1),16)=per_p_results_vs_all_examples(2,(length(v_name)*(r-1)+4));
  if deep ==1;
    dist_from_single_structures_per_run_full_table(r+size(all_files,1),17)=per_p_results_vs_all_examples(2,(length(v_name)*(r-1)+18));
    dist_from_single_structures_per_run_full_table(r+size(all_files,1),18)=per_p_results_vs_all_examples(2,(length(v_name)*(r-1)+19));
  end
  
    dist_from_single_structures_per_run_full_table(r+2*(size(all_files,1)),1)=per_p_results_vs_all_examples(3,(length(v_name)*(r-1)+12));
    dist_from_single_structures_per_run_full_table(r+2*(size(all_files,1)),2)=per_p_results_vs_all_examples(3,(length(v_name)*(r-1)+13));
    dist_from_single_structures_per_run_full_table(r+2*(size(all_files,1)),3)=per_p_results_vs_all_examples(3,(length(v_name)*(r-1)+14));
  dist_from_single_structures_per_run_full_table(r+2*(size(all_files,1)),4)=per_p_results_vs_all_examples(3,(length(v_name)*(r-1)+5));
   dist_from_single_structures_per_run_full_table(r+2*(size(all_files,1)),5)=per_p_results_vs_all_examples(3,(length(v_name)*(r-1)+6));
    dist_from_single_structures_per_run_full_table(r+2*(size(all_files,1)),6)=per_p_results_vs_all_examples(3,(length(v_name)*(r-1)+7));
     dist_from_single_structures_per_run_full_table(r+2*(size(all_files,1)),7)=per_p_results_vs_all_examples(3,(length(v_name)*(r-1)+8));
      dist_from_single_structures_per_run_full_table(r+2*(size(all_files,1)),8)=per_p_results_vs_all_examples(3,(length(v_name)*(r-1)+9));
       dist_from_single_structures_per_run_full_table(r+2*(size(all_files,1)),9)=per_p_results_vs_all_examples(3,(length(v_name)*(r-1)+10));     
        dist_from_single_structures_per_run_full_table(r+2*(size(all_files,1)),10)=per_p_results_vs_all_examples(3,(length(v_name)*(r-1)+1));
    dist_from_single_structures_per_run_full_table(r+2*(size(all_files,1)),11)=per_p_results_vs_all_examples(3,(length(v_name)*(r-1)+2));
      dist_from_single_structures_per_run_full_table(r+2*(size(all_files,1)),12)=per_p_results_vs_all_examples(3,(length(v_name)*(r-1)+3));
            dist_from_single_structures_per_run_full_table(r+2*(size(all_files,1)),13)=per_p_results_vs_all_examples(3,(length(v_name)*(r-1)+15));
                dist_from_single_structures_per_run_full_table(r+2*(size(all_files,1)),14)=per_p_results_vs_all_examples(3,(length(v_name)*(r-1)+16));
    dist_from_single_structures_per_run_full_table(r+2*(size(all_files,1)),15)=per_p_results_vs_all_examples(3,(length(v_name)*(r-1)+17));
    dist_from_single_structures_per_run_full_table(r+2*(size(all_files,1)),16)=per_p_results_vs_all_examples(3,(length(v_name)*(r-1)+4));
  if deep ==1;
    dist_from_single_structures_per_run_full_table(r+2*(size(all_files,1)),17)=per_p_results_vs_all_examples(3,(length(v_name)*(r-1)+18));
    dist_from_single_structures_per_run_full_table(r+2*(size(all_files,1)),18)=per_p_results_vs_all_examples(3,(length(v_name)*(r-1)+19));
  end
  
      dist_from_single_structures_per_run_full_table(r+3*(size(all_files,1)),1)=per_p_results_vs_all_examples(4,(length(v_name)*(r-1)+12));
    dist_from_single_structures_per_run_full_table(r+3*(size(all_files,1)),2)=per_p_results_vs_all_examples(4,(length(v_name)*(r-1)+13));
    dist_from_single_structures_per_run_full_table(r+3*(size(all_files,1)),3)=per_p_results_vs_all_examples(4,(length(v_name)*(r-1)+14));
  dist_from_single_structures_per_run_full_table(r+3*(size(all_files,1)),4)=per_p_results_vs_all_examples(4,(length(v_name)*(r-1)+5));
   dist_from_single_structures_per_run_full_table(r+3*(size(all_files,1)),5)=per_p_results_vs_all_examples(4,(length(v_name)*(r-1)+6));
    dist_from_single_structures_per_run_full_table(r+3*(size(all_files,1)),6)=per_p_results_vs_all_examples(4,(length(v_name)*(r-1)+7));
     dist_from_single_structures_per_run_full_table(r+3*(size(all_files,1)),7)=per_p_results_vs_all_examples(4,(length(v_name)*(r-1)+8));
      dist_from_single_structures_per_run_full_table(r+3*(size(all_files,1)),8)=per_p_results_vs_all_examples(4,(length(v_name)*(r-1)+9));
       dist_from_single_structures_per_run_full_table(r+3*(size(all_files,1)),9)=per_p_results_vs_all_examples(4,(length(v_name)*(r-1)+10));     
        dist_from_single_structures_per_run_full_table(r+3*(size(all_files,1)),10)=per_p_results_vs_all_examples(4,(length(v_name)*(r-1)+1));
    dist_from_single_structures_per_run_full_table(r+3*(size(all_files,1)),11)=per_p_results_vs_all_examples(4,(length(v_name)*(r-1)+2));
      dist_from_single_structures_per_run_full_table(r+3*(size(all_files,1)),12)=per_p_results_vs_all_examples(4,(length(v_name)*(r-1)+3));
            dist_from_single_structures_per_run_full_table(r+3*(size(all_files,1)),13)=per_p_results_vs_all_examples(4,(length(v_name)*(r-1)+15));
                dist_from_single_structures_per_run_full_table(r+3*(size(all_files,1)),14)=per_p_results_vs_all_examples(4,(length(v_name)*(r-1)+16));
    dist_from_single_structures_per_run_full_table(r+3*(size(all_files,1)),15)=per_p_results_vs_all_examples(4,(length(v_name)*(r-1)+17));
    dist_from_single_structures_per_run_full_table(r+3*(size(all_files,1)),16)=per_p_results_vs_all_examples(4,(length(v_name)*(r-1)+4));
  if deep ==1;
    dist_from_single_structures_per_run_full_table(r+3*(size(all_files,1)),17)=per_p_results_vs_all_examples(4,(length(v_name)*(r-1)+18));
    dist_from_single_structures_per_run_full_table(r+3*(size(all_files,1)),18)=per_p_results_vs_all_examples(4,(length(v_name)*(r-1)+19));
  end 
end

dist_from_fuller_structure_per_run_6_div_combined_areas = vertcat(dist_from_fuller_structure_per_run_full_table(:,4),dist_from_fuller_structure_per_run_full_table(:,5),dist_from_fuller_structure_per_run_full_table(:,6),dist_from_fuller_structure_per_run_full_table(:,7),dist_from_fuller_structure_per_run_full_table(:,8),dist_from_fuller_structure_per_run_full_table(:,9));
dist_from_single_structures_per_run_6_div_combined_areas = vertcat(dist_from_single_structures_per_run_full_table(:,4),dist_from_single_structures_per_run_full_table(:,5),dist_from_single_structures_per_run_full_table(:,6),dist_from_single_structures_per_run_full_table(:,7),dist_from_single_structures_per_run_full_table(:,8),dist_from_single_structures_per_run_full_table(:,9));
dist_from_fuller_structure_per_run_3_div_combined_areas = vertcat(dist_from_fuller_structure_per_run_full_table(:,10),dist_from_fuller_structure_per_run_full_table(:,11),dist_from_fuller_structure_per_run_full_table(:,12));

%see closest single example structure for core results areas - poss add
%m1m2 etc or diff poss splits for this in separate sections for diff arch
%as varies whether make sense- IF CHANGE ORDER OF MODEL AREAS OR CHANGE
%COMPLETELY WILL BE WRONG

temp_getting_closest_single_ex_structure=av_results_vs_all_examples([1:4] , : );
getting_closest_single_ex_structure_full_table(:,1)=temp_getting_closest_single_ex_structure(:,12);
getting_closest_single_ex_structure_full_table(:,2)=temp_getting_closest_single_ex_structure(:,13);
getting_closest_single_ex_structure_full_table(:,3)=temp_getting_closest_single_ex_structure(:,14);
getting_closest_single_ex_structure_full_table(:,4)=temp_getting_closest_single_ex_structure(:,5);
getting_closest_single_ex_structure_full_table(:,5)=temp_getting_closest_single_ex_structure(:,6);
getting_closest_single_ex_structure_full_table(:,6)=temp_getting_closest_single_ex_structure(:,7);
getting_closest_single_ex_structure_full_table(:,7)=temp_getting_closest_single_ex_structure(:,8);
getting_closest_single_ex_structure_full_table(:,8)=temp_getting_closest_single_ex_structure(:,9);
getting_closest_single_ex_structure_full_table(:,9)=temp_getting_closest_single_ex_structure(:,10);
getting_closest_single_ex_structure_full_table(:,10)=temp_getting_closest_single_ex_structure(:,1);
getting_closest_single_ex_structure_full_table(:,11)=temp_getting_closest_single_ex_structure(:,2);
getting_closest_single_ex_structure_full_table(:,12)=temp_getting_closest_single_ex_structure(:,3);
getting_closest_single_ex_structure_full_table(:,13)=temp_getting_closest_single_ex_structure(:,15);
getting_closest_single_ex_structure_full_table(:,14)=temp_getting_closest_single_ex_structure(:,16);
getting_closest_single_ex_structure_full_table(:,15)=temp_getting_closest_single_ex_structure(:,17);
getting_closest_single_ex_structure_full_table(:,16)=temp_getting_closest_single_ex_structure(:,4);
if deep ==1;
getting_closest_single_ex_structure_full_table(:,17)=temp_getting_closest_single_ex_structure(:,18);
getting_closest_single_ex_structure_full_table(:,18)=temp_getting_closest_single_ex_structure(:,19);
end
if deep ==2;
getting_closest_single_ex_structure_full_table(:,17)=temp_getting_closest_single_ex_structure(:,18);
getting_closest_single_ex_structure_full_table(:,18)=temp_getting_closest_single_ex_structure(:,20);
getting_closest_single_ex_structure_full_table(:,19)=temp_getting_closest_single_ex_structure(:,19);
end
if deep ==3;
getting_closest_single_ex_structure_full_table(:,17)=temp_getting_closest_single_ex_structure(:,18);
getting_closest_single_ex_structure_full_table(:,18)=temp_getting_closest_single_ex_structure(:,20);
getting_closest_single_ex_structure_full_table(:,19)=temp_getting_closest_single_ex_structure(:,21);
getting_closest_single_ex_structure_full_table(:,20)=temp_getting_closest_single_ex_structure(:,19);
end

temp_getting_closest_combo_ex_structure=av_results_vs_all_examples([1:15] , : );
getting_closest_combo_ex_structure_full_table(:,1)=temp_getting_closest_combo_ex_structure(:,12);
getting_closest_combo_ex_structure_full_table(:,2)=temp_getting_closest_combo_ex_structure(:,13);
getting_closest_combo_ex_structure_full_table(:,3)=temp_getting_closest_combo_ex_structure(:,14);
getting_closest_combo_ex_structure_full_table(:,4)=temp_getting_closest_combo_ex_structure(:,5);
getting_closest_combo_ex_structure_full_table(:,5)=temp_getting_closest_combo_ex_structure(:,6);
getting_closest_combo_ex_structure_full_table(:,6)=temp_getting_closest_combo_ex_structure(:,7);
getting_closest_combo_ex_structure_full_table(:,7)=temp_getting_closest_combo_ex_structure(:,8);
getting_closest_combo_ex_structure_full_table(:,8)=temp_getting_closest_combo_ex_structure(:,9);
getting_closest_combo_ex_structure_full_table(:,9)=temp_getting_closest_combo_ex_structure(:,10);
getting_closest_combo_ex_structure_full_table(:,10)=temp_getting_closest_combo_ex_structure(:,1);
getting_closest_combo_ex_structure_full_table(:,11)=temp_getting_closest_combo_ex_structure(:,2);
getting_closest_combo_ex_structure_full_table(:,12)=temp_getting_closest_combo_ex_structure(:,3);
getting_closest_combo_ex_structure_full_table(:,13)=temp_getting_closest_combo_ex_structure(:,15);
getting_closest_combo_ex_structure_full_table(:,14)=temp_getting_closest_combo_ex_structure(:,16);
getting_closest_combo_ex_structure_full_table(:,15)=temp_getting_closest_combo_ex_structure(:,17);
getting_closest_combo_ex_structure_full_table(:,16)=temp_getting_closest_combo_ex_structure(:,4);
if deep ==1;
getting_closest_combo_ex_structure_full_table(:,17)=temp_getting_closest_combo_ex_structure(:,18);
getting_closest_combo_ex_structure_full_table(:,18)=temp_getting_closest_combo_ex_structure(:,19);
end
if deep ==2;
getting_closest_combo_ex_structure_full_table(:,17)=temp_getting_closest_combo_ex_structure(:,18);
getting_closest_combo_ex_structure_full_table(:,18)=temp_getting_closest_combo_ex_structure(:,20);
getting_closest_combo_ex_structure_full_table(:,19)=temp_getting_closest_combo_ex_structure(:,19);
end
if deep ==3;
getting_closest_combo_ex_structure_full_table(:,17)=temp_getting_closest_combo_ex_structure(:,18);
getting_closest_combo_ex_structure_full_table(:,18)=temp_getting_closest_combo_ex_structure(:,20);
getting_closest_combo_ex_structure_full_table(:,19)=temp_getting_closest_combo_ex_structure(:,21);
getting_closest_combo_ex_structure_full_table(:,20)=temp_getting_closest_combo_ex_structure(:,19);
end

%SAME BUT USING AV OVER EACH RUNS RESULTS SO TABLE FITS STATS BETTER
if deep ==1;
AV_OVER_RUNS_FOR_TABLES_getting_closest_single_structure = zeros(4,18);
AV_OVER_RUNS_FOR_TABLES_getting_closest_combo = zeros(15,18);
end
if deep==0;
AV_OVER_RUNS_FOR_TABLES_getting_closest_single_structure = zeros(4,16);
AV_OVER_RUNS_FOR_TABLES_getting_closest_combo = zeros(15,16);
end


temp_AV_OVER_RUNS_FOR_TABLES_getting_single=AV_OVER_RUNS_FOR_TABLES_vs_all_examples_full_table([1:4] , : );
AV_OVER_RUNS_FOR_TABLES_getting_closest_single_structure(:,1)=temp_AV_OVER_RUNS_FOR_TABLES_getting_single(:,12);
AV_OVER_RUNS_FOR_TABLES_getting_closest_single_structure(:,2)=temp_AV_OVER_RUNS_FOR_TABLES_getting_single(:,13);
AV_OVER_RUNS_FOR_TABLES_getting_closest_single_structure(:,3)=temp_AV_OVER_RUNS_FOR_TABLES_getting_single(:,14);
AV_OVER_RUNS_FOR_TABLES_getting_closest_single_structure(:,4)=temp_AV_OVER_RUNS_FOR_TABLES_getting_single(:,5);
AV_OVER_RUNS_FOR_TABLES_getting_closest_single_structure(:,5)=temp_AV_OVER_RUNS_FOR_TABLES_getting_single(:,6);
AV_OVER_RUNS_FOR_TABLES_getting_closest_single_structure(:,6)=temp_AV_OVER_RUNS_FOR_TABLES_getting_single(:,7);
AV_OVER_RUNS_FOR_TABLES_getting_closest_single_structure(:,7)=temp_AV_OVER_RUNS_FOR_TABLES_getting_single(:,8);
AV_OVER_RUNS_FOR_TABLES_getting_closest_single_structure(:,8)=temp_AV_OVER_RUNS_FOR_TABLES_getting_single(:,9);
AV_OVER_RUNS_FOR_TABLES_getting_closest_single_structure(:,9)=temp_AV_OVER_RUNS_FOR_TABLES_getting_single(:,10);
AV_OVER_RUNS_FOR_TABLES_getting_closest_single_structure(:,10)=temp_AV_OVER_RUNS_FOR_TABLES_getting_single(:,1);
AV_OVER_RUNS_FOR_TABLES_getting_closest_single_structure(:,11)=temp_AV_OVER_RUNS_FOR_TABLES_getting_single(:,2);
AV_OVER_RUNS_FOR_TABLES_getting_closest_single_structure(:,12)=temp_AV_OVER_RUNS_FOR_TABLES_getting_single(:,3);
AV_OVER_RUNS_FOR_TABLES_getting_closest_single_structure(:,13)=temp_AV_OVER_RUNS_FOR_TABLES_getting_single(:,15);
AV_OVER_RUNS_FOR_TABLES_getting_closest_single_structure(:,14)=temp_AV_OVER_RUNS_FOR_TABLES_getting_single(:,16);
AV_OVER_RUNS_FOR_TABLES_getting_closest_single_structure(:,15)=temp_AV_OVER_RUNS_FOR_TABLES_getting_single(:,17);
AV_OVER_RUNS_FOR_TABLES_getting_closest_single_structure(:,16)=temp_AV_OVER_RUNS_FOR_TABLES_getting_single(:,4);
if deep ==1;
AV_OVER_RUNS_FOR_TABLES_getting_closest_single_structure(:,17)=temp_AV_OVER_RUNS_FOR_TABLES_getting_single(:,18);
AV_OVER_RUNS_FOR_TABLES_getting_closest_single_structure(:,18)=temp_AV_OVER_RUNS_FOR_TABLES_getting_single(:,19);
end
if deep ==2;
AV_OVER_RUNS_FOR_TABLES_getting_closest_single_structure(:,17)=temp_AV_OVER_RUNS_FOR_TABLES_getting_single(:,18);
AV_OVER_RUNS_FOR_TABLES_getting_closest_single_structure(:,18)=temp_AV_OVER_RUNS_FOR_TABLES_getting_single(:,20);
AV_OVER_RUNS_FOR_TABLES_getting_closest_single_structure(:,19)=temp_AV_OVER_RUNS_FOR_TABLES_getting_single(:,19);
end
if deep ==3;
AV_OVER_RUNS_FOR_TABLES_getting_closest_single_structure(:,17)=temp_AV_OVER_RUNS_FOR_TABLES_getting_single(:,18);
AV_OVER_RUNS_FOR_TABLES_getting_closest_single_structure(:,18)=temp_AV_OVER_RUNS_FOR_TABLES_getting_single(:,20);
AV_OVER_RUNS_FOR_TABLES_getting_closest_single_structure(:,19)=temp_AV_OVER_RUNS_FOR_TABLES_getting_single(:,21);
AV_OVER_RUNS_FOR_TABLES_getting_closest_single_structure(:,20)=temp_AV_OVER_RUNS_FOR_TABLES_getting_single(:,19);
end

temp_AV_OVER_RUNS_FOR_TABLES_getting_combo=AV_OVER_RUNS_FOR_TABLES_vs_all_examples_full_table([1:15] , : );
AV_OVER_RUNS_FOR_TABLES_getting_closest_combo(:,1)=temp_AV_OVER_RUNS_FOR_TABLES_getting_combo(:,12);
AV_OVER_RUNS_FOR_TABLES_getting_closest_combo(:,2)=temp_AV_OVER_RUNS_FOR_TABLES_getting_combo(:,13);
AV_OVER_RUNS_FOR_TABLES_getting_closest_combo(:,3)=temp_AV_OVER_RUNS_FOR_TABLES_getting_combo(:,14);
AV_OVER_RUNS_FOR_TABLES_getting_closest_combo(:,4)=temp_AV_OVER_RUNS_FOR_TABLES_getting_combo(:,5);
AV_OVER_RUNS_FOR_TABLES_getting_closest_combo(:,5)=temp_AV_OVER_RUNS_FOR_TABLES_getting_combo(:,6);
AV_OVER_RUNS_FOR_TABLES_getting_closest_combo(:,6)=temp_AV_OVER_RUNS_FOR_TABLES_getting_combo(:,7);
AV_OVER_RUNS_FOR_TABLES_getting_closest_combo(:,7)=temp_AV_OVER_RUNS_FOR_TABLES_getting_combo(:,8);
AV_OVER_RUNS_FOR_TABLES_getting_closest_combo(:,8)=temp_AV_OVER_RUNS_FOR_TABLES_getting_combo(:,9);
AV_OVER_RUNS_FOR_TABLES_getting_closest_combo(:,9)=temp_AV_OVER_RUNS_FOR_TABLES_getting_combo(:,10);
AV_OVER_RUNS_FOR_TABLES_getting_closest_combo(:,10)=temp_AV_OVER_RUNS_FOR_TABLES_getting_combo(:,1);
AV_OVER_RUNS_FOR_TABLES_getting_closest_combo(:,11)=temp_AV_OVER_RUNS_FOR_TABLES_getting_combo(:,2);
AV_OVER_RUNS_FOR_TABLES_getting_closest_combo(:,12)=temp_AV_OVER_RUNS_FOR_TABLES_getting_combo(:,3);
AV_OVER_RUNS_FOR_TABLES_getting_closest_combo(:,13)=temp_AV_OVER_RUNS_FOR_TABLES_getting_combo(:,15);
AV_OVER_RUNS_FOR_TABLES_getting_closest_combo(:,14)=temp_AV_OVER_RUNS_FOR_TABLES_getting_combo(:,16);
AV_OVER_RUNS_FOR_TABLES_getting_closest_combo(:,15)=temp_AV_OVER_RUNS_FOR_TABLES_getting_combo(:,17);
AV_OVER_RUNS_FOR_TABLES_getting_closest_combo(:,16)=temp_AV_OVER_RUNS_FOR_TABLES_getting_combo(:,4);
if deep ==1;
AV_OVER_RUNS_FOR_TABLES_getting_closest_combo(:,17)=temp_AV_OVER_RUNS_FOR_TABLES_getting_combo(:,18);
AV_OVER_RUNS_FOR_TABLES_getting_closest_combo(:,18)=temp_AV_OVER_RUNS_FOR_TABLES_getting_combo(:,19);
end
if deep ==2;
AV_OVER_RUNS_FOR_TABLES_getting_closest_combo(:,17)=temp_AV_OVER_RUNS_FOR_TABLES_getting_combo(:,18);
AV_OVER_RUNS_FOR_TABLES_getting_closest_combo(:,18)=temp_AV_OVER_RUNS_FOR_TABLES_getting_combo(:,20);
AV_OVER_RUNS_FOR_TABLES_getting_closest_combo(:,19)=temp_AV_OVER_RUNS_FOR_TABLES_getting_combo(:,19);
end
if deep ==3;
AV_OVER_RUNS_FOR_TABLES_getting_closest_combo(:,17)=temp_AV_OVER_RUNS_FOR_TABLES_getting_combo(:,18);
AV_OVER_RUNS_FOR_TABLES_getting_closest_combo(:,18)=temp_AV_OVER_RUNS_FOR_TABLES_getting_combo(:,20);
AV_OVER_RUNS_FOR_TABLES_getting_closest_combo(:,19)=temp_AV_OVER_RUNS_FOR_TABLES_getting_combo(:,21);
AV_OVER_RUNS_FOR_TABLES_getting_closest_combo(:,20)=temp_AV_OVER_RUNS_FOR_TABLES_getting_combo(:,19);
end

%% new consistency output for stats (does change if change v's)
%is model areas across (6div of HU1, full HU1, HU2, all HU) by runs down
if deep == 0;
    consistency_for_stats = vertcat(leave_one_out_consistency_results(5,:),leave_one_out_consistency_results(6,:),leave_one_out_consistency_results(7,:),leave_one_out_consistency_results(8,:),leave_one_out_consistency_results(9,:),leave_one_out_consistency_results(10,:),leave_one_out_consistency_results(4,:));
end
if deep == 1;
    consistency_for_stats = vertcat(leave_one_out_consistency_results(5,:),leave_one_out_consistency_results(6,:),leave_one_out_consistency_results(7,:),leave_one_out_consistency_results(8,:),leave_one_out_consistency_results(9,:),leave_one_out_consistency_results(10,:),leave_one_out_consistency_results(4,:),leave_one_out_consistency_results(18,:),leave_one_out_consistency_results(19,:));
end
if deep == 2;
    consistency_for_stats = vertcat(leave_one_out_consistency_results(5,:),leave_one_out_consistency_results(6,:),leave_one_out_consistency_results(7,:),leave_one_out_consistency_results(8,:),leave_one_out_consistency_results(9,:),leave_one_out_consistency_results(10,:),leave_one_out_consistency_results(4,:),leave_one_out_consistency_results(18,:),leave_one_out_consistency_results(20,:),leave_one_out_consistency_results(19,:));
end
if deep == 3;
    consistency_for_stats = vertcat(leave_one_out_consistency_results(5,:),leave_one_out_consistency_results(6,:),leave_one_out_consistency_results(7,:),leave_one_out_consistency_results(8,:),leave_one_out_consistency_results(9,:),leave_one_out_consistency_results(10,:),leave_one_out_consistency_results(4,:),leave_one_out_consistency_results(18,:),leave_one_out_consistency_results(20,:),leave_one_out_consistency_results(21,:),leave_one_out_consistency_results(19,:));
end

consistency_for_stats = consistency_for_stats';

consistency_for_stats_6_div = vertcat(consistency_for_stats(:,1), consistency_for_stats(:,2),consistency_for_stats(:,3),consistency_for_stats(:,4),consistency_for_stats(:,5),consistency_for_stats(:,6));

consistency_for_stats_temp = vertcat(leave_one_out_consistency_results(1,:),leave_one_out_consistency_results(2,:),leave_one_out_consistency_results(3,:));
consistency_for_stats_temp = consistency_for_stats_temp';
consistency_for_stats_3_div = vertcat(consistency_for_stats(:,1), consistency_for_stats(:,2),consistency_for_stats(:,3));

%% single structures arranged better for stats - DONE 3 DIV + 6 DIV + I-B SO EASIER

%old 3 div i.e. m1m2 + m1m3 + m2m3 for size matched stats
dist_from_single_structures_3_div_for_stats = zeros(size(all_files,1)*3,4);
dist_from_single_structures_3_div_for_stats(:,1) = vertcat(dist_from_single_structures_per_run_full_table(1:size(all_files,1),10),dist_from_single_structures_per_run_full_table(1:size(all_files,1),11),dist_from_single_structures_per_run_full_table(1:size(all_files,1),12));
dist_from_single_structures_3_div_for_stats(:,2) = vertcat(dist_from_single_structures_per_run_full_table((size(all_files,1)+1):(2*size(all_files,1)),10),dist_from_single_structures_per_run_full_table((size(all_files,1)+1):(2*size(all_files,1)),11),dist_from_single_structures_per_run_full_table((size(all_files,1)+1):(2*size(all_files,1)),12));
dist_from_single_structures_3_div_for_stats(:,3) = vertcat(dist_from_single_structures_per_run_full_table((size(all_files,1)*2+1):3*size(all_files,1),10),dist_from_single_structures_per_run_full_table((size(all_files,1)*2+1):3*size(all_files,1),11),dist_from_single_structures_per_run_full_table((size(all_files,1)*2+1):3*size(all_files,1),12));
dist_from_single_structures_3_div_for_stats(:,4) = vertcat(dist_from_single_structures_per_run_full_table((size(all_files,1)*3+1):4*size(all_files,1),10),dist_from_single_structures_per_run_full_table((size(all_files,1)*3+1):4*size(all_files,1),11),dist_from_single_structures_per_run_full_table((size(all_files,1)*3+1):4*size(all_files,1),12));

%6 div
dist_from_single_structures_6_div_for_stats = zeros(size(all_files,1)*6,4);
dist_from_single_structures_6_div_for_stats(:,1) = vertcat(dist_from_single_structures_per_run_full_table(1:size(all_files,1),4),dist_from_single_structures_per_run_full_table(1:size(all_files,1),5),dist_from_single_structures_per_run_full_table(1:size(all_files,1),6),dist_from_single_structures_per_run_full_table(1:size(all_files,1),7),dist_from_single_structures_per_run_full_table(1:size(all_files,1),8),dist_from_single_structures_per_run_full_table(1:size(all_files,1),9));
dist_from_single_structures_6_div_for_stats(:,2) = vertcat(dist_from_single_structures_per_run_full_table((size(all_files,1)+1):(2*size(all_files,1)),4),dist_from_single_structures_per_run_full_table((size(all_files,1)+1):(2*size(all_files,1)),5),dist_from_single_structures_per_run_full_table((size(all_files,1)+1):(2*size(all_files,1)),6),dist_from_single_structures_per_run_full_table((size(all_files,1)+1):(2*size(all_files,1)),7),dist_from_single_structures_per_run_full_table((size(all_files,1)+1):(2*size(all_files,1)),8),dist_from_single_structures_per_run_full_table((size(all_files,1)+1):(2*size(all_files,1)),9));
dist_from_single_structures_6_div_for_stats(:,3) = vertcat(dist_from_single_structures_per_run_full_table((size(all_files,1)*2+1):3*size(all_files,1),4),dist_from_single_structures_per_run_full_table((size(all_files,1)*2+1):3*size(all_files,1),5),dist_from_single_structures_per_run_full_table((size(all_files,1)*2+1):3*size(all_files,1),6),dist_from_single_structures_per_run_full_table((size(all_files,1)*2+1):3*size(all_files,1),7),dist_from_single_structures_per_run_full_table((size(all_files,1)*2+1):3*size(all_files,1),8),dist_from_single_structures_per_run_full_table((size(all_files,1)*2+1):3*size(all_files,1),9));
dist_from_single_structures_6_div_for_stats(:,4) = vertcat(dist_from_single_structures_per_run_full_table((size(all_files,1)*3+1):4*size(all_files,1),4),dist_from_single_structures_per_run_full_table((size(all_files,1)*3+1):4*size(all_files,1),5),dist_from_single_structures_per_run_full_table((size(all_files,1)*3+1):4*size(all_files,1),6),dist_from_single_structures_per_run_full_table((size(all_files,1)*3+1):4*size(all_files,1),7),dist_from_single_structures_per_run_full_table((size(all_files,1)*3+1):4*size(all_files,1),8),dist_from_single_structures_per_run_full_table((size(all_files,1)*3+1):4*size(all_files,1),9));

%% input based split - 3 div (m1_inputs, m2_inputs, m2_3inputs i.e. m1m3 + m1m2, etc) - NOW GETTING FOR ALL ARCH - IS REPEATING SOME CODE WHERE GOT IN FULL TABLE RESULTS

    consistency_output_input_based_div = [];
    consistency_output_input_based_div(1,1) =average_consistency_results(15);
    consistency_output_input_based_div(2,1) =average_consistency_results(16);
       consistency_output_input_based_div(3,1) =average_consistency_results(17);
       
      dist_from_fuller_structure_input_based_div = []; 
    dist_from_fuller_structure_input_based_div(1,1)=av_results_vs_all_examples(19,15);
    dist_from_fuller_structure_input_based_div(2,1)=av_results_vs_all_examples(19,16); 
    dist_from_fuller_structure_input_based_div(3,1)=av_results_vs_all_examples(19,17); 
    
    
     dist_from_fuller_structure_per_run_input_based_div = [size(all_files,1), 3];  
     dist_from_single_structures_per_run_input_based_div = [size(all_files,1)*4, 3]; 
     
       for r=1:size(all_files,1);
                dist_from_fuller_structure_per_run_input_based_div(r,1)=per_p_results_vs_all_examples(19,(length(v_name)*(r-1)+15));
                dist_from_fuller_structure_per_run_input_based_div(r,2)=per_p_results_vs_all_examples(19,(length(v_name)*(r-1)+16));
                dist_from_fuller_structure_per_run_input_based_div(r,3)=per_p_results_vs_all_examples(19,(length(v_name)*(r-1)+17));
                dist_from_single_structures_per_run_input_based_div(r,1)=per_p_results_vs_all_examples(1,(length(v_name)*(r-1)+15));
                dist_from_single_structures_per_run_input_based_div(r,2)=per_p_results_vs_all_examples(1,(length(v_name)*(r-1)+16));
                dist_from_single_structures_per_run_input_based_div(r,3)=per_p_results_vs_all_examples(1,(length(v_name)*(r-1)+17));
                dist_from_single_structures_per_run_input_based_div(r+size(all_files,1),1)=per_p_results_vs_all_examples(2,(length(v_name)*(r-1)+15));
                dist_from_single_structures_per_run_input_based_div(r+size(all_files,1),2)=per_p_results_vs_all_examples(2,(length(v_name)*(r-1)+16));
                dist_from_single_structures_per_run_input_based_div(r+size(all_files,1),3)=per_p_results_vs_all_examples(2,(length(v_name)*(r-1)+17));
                dist_from_single_structures_per_run_input_based_div(r+2*(size(all_files,1)),1)=per_p_results_vs_all_examples(3,(length(v_name)*(r-1)+15));
                dist_from_single_structures_per_run_input_based_div(r+2*(size(all_files,1)),2)=per_p_results_vs_all_examples(3,(length(v_name)*(r-1)+16));
                dist_from_single_structures_per_run_input_based_div(r+2*(size(all_files,1)),3)=per_p_results_vs_all_examples(3,(length(v_name)*(r-1)+17));
                dist_from_single_structures_per_run_input_based_div(r+3*(size(all_files,1)),1)=per_p_results_vs_all_examples(4,(length(v_name)*(r-1)+15));
                dist_from_single_structures_per_run_input_based_div(r+3*(size(all_files,1)),2)=per_p_results_vs_all_examples(4,(length(v_name)*(r-1)+16));
                dist_from_single_structures_per_run_input_based_div(r+3*(size(all_files,1)),3)=per_p_results_vs_all_examples(4,(length(v_name)*(r-1)+17));
       end
       
       dist_from_single_structures_for_stats_input_based_div= vertcat(dist_from_single_structures_per_run_input_based_div(:,1),dist_from_single_structures_per_run_input_based_div(:,2),dist_from_single_structures_per_run_input_based_div(:,3));
       dist_from_fuller_structure_per_run_input_based_div_FOR_STATS = vertcat(dist_from_fuller_structure_per_run_input_based_div(:,1),dist_from_fuller_structure_per_run_input_based_div(:,2),dist_from_fuller_structure_per_run_input_based_div(:,3));
        
       dist_from_single_structures_input_based_div_for_stats = zeros(size(all_files,1)*3,4);
dist_from_single_structures_input_based_div_for_stats(:,1) = vertcat(dist_from_single_structures_per_run_input_based_div(1:size(all_files,1),1),dist_from_single_structures_per_run_input_based_div(1:size(all_files,1),2),dist_from_single_structures_per_run_input_based_div(1:size(all_files,1),3));
dist_from_single_structures_input_based_div_for_stats(:,2) = vertcat(dist_from_single_structures_per_run_input_based_div((size(all_files,1)+1):(2*size(all_files,1)),1),dist_from_single_structures_per_run_input_based_div((size(all_files,1)+1):(2*size(all_files,1)),2),dist_from_single_structures_per_run_input_based_div((size(all_files,1)+1):(2*size(all_files,1)),3));
dist_from_single_structures_input_based_div_for_stats(:,3) = vertcat(dist_from_single_structures_per_run_input_based_div((size(all_files,1)*2+1):3*size(all_files,1),1),dist_from_single_structures_per_run_input_based_div((size(all_files,1)*2+1):3*size(all_files,1),2),dist_from_single_structures_per_run_input_based_div((size(all_files,1)*2+1):3*size(all_files,1),3));
dist_from_single_structures_input_based_div_for_stats(:,4) = vertcat(dist_from_single_structures_per_run_input_based_div((size(all_files,1)*3+1):4*size(all_files,1),1),dist_from_single_structures_per_run_input_based_div((size(all_files,1)*3+1):4*size(all_files,1),2),dist_from_single_structures_per_run_input_based_div((size(all_files,1)*3+1):4*size(all_files,1),3));

       
      getting_closest_single_ex_structure_input_based_div(:,1)=temp_getting_closest_single_ex_structure(:,15);
    getting_closest_single_ex_structure_input_based_div(:,2)=temp_getting_closest_single_ex_structure(:,16); 
    getting_closest_single_ex_structure_input_based_div(:,3)=temp_getting_closest_single_ex_structure(:,17); 
    getting_closest_combo_ex_structure_input_based_div(:,1)=temp_getting_closest_combo_ex_structure(:,15);
    getting_closest_combo_ex_structure_input_based_div(:,2)=temp_getting_closest_combo_ex_structure(:,16);    
    getting_closest_combo_ex_structure_input_based_div(:,3)=temp_getting_closest_combo_ex_structure(:,17);
       
     consistency_for_stats_input_based_div = vertcat(leave_one_out_consistency_results(15,:),leave_one_out_consistency_results(16,:),leave_one_out_consistency_results(17,:));
     consistency_for_stats_input_based_div = consistency_for_stats_input_based_div';
     consistency_for_stats_input_based_div_FOR_STATS = vertcat(consistency_for_stats_input_based_div(:,1),consistency_for_stats_input_based_div(:,2),consistency_for_stats_input_based_div(:,3));


%% arrange outputs properly for stats - ready for combination across arch then running anovas + all_uni is combined uni1-3 to run in a separate anova

STATS_FOR_ANOVA_6_DIV = horzcat(dist_from_fuller_structure_per_run_6_div_combined_areas, consistency_for_stats_6_div, dist_from_single_structures_6_div_for_stats);

STATS_FOR_ANOVA_INPUT_BASED = horzcat(dist_from_fuller_structure_per_run_input_based_div_FOR_STATS,consistency_for_stats_input_based_div_FOR_STATS ,dist_from_single_structures_input_based_div_for_stats);

STATS_FOR_ANOVA_HU1 = horzcat(dist_from_fuller_structure_per_run_full_table(:,16),consistency_for_stats(:,7), dist_from_single_structures_per_run_full_table(1:size(all_files,1), 16),dist_from_single_structures_per_run_full_table(size(all_files,1)+1:size(all_files,1)*2, 16),dist_from_single_structures_per_run_full_table(size(all_files,1)*2+1:size(all_files,1)*3, 16),dist_from_single_structures_per_run_full_table(size(all_files,1)*3+1:size(all_files,1)*4, 16));

if deep ==1;
STATS_FOR_ANOVA_HU2 = horzcat(dist_from_fuller_structure_per_run_full_table(:,17),consistency_for_stats(:,8), dist_from_single_structures_per_run_full_table(1:size(all_files,1), 17),dist_from_single_structures_per_run_full_table(size(all_files,1)+1:size(all_files,1)*2, 17),dist_from_single_structures_per_run_full_table(size(all_files,1)*2+1:size(all_files,1)*3, 17),dist_from_single_structures_per_run_full_table(size(all_files,1)*3+1:size(all_files,1)*4, 17));
STATS_FOR_ANOVA_all_HU = horzcat(dist_from_fuller_structure_per_run_full_table(:,18),consistency_for_stats(:,9), dist_from_single_structures_per_run_full_table(1:size(all_files,1), 18),dist_from_single_structures_per_run_full_table(size(all_files,1)+1:size(all_files,1)*2, 18),dist_from_single_structures_per_run_full_table(size(all_files,1)*2+1:size(all_files,1)*3, 18),dist_from_single_structures_per_run_full_table(size(all_files,1)*3+1:size(all_files,1)*4, 18));
end

STATS_FOR_ANOVA_old_3_DIV = horzcat(dist_from_fuller_structure_per_run_3_div_combined_areas, consistency_for_stats_3_div, dist_from_single_structures_3_div_for_stats);

all_uni_6_div = vertcat(STATS_FOR_ANOVA_6_DIV(:,4),STATS_FOR_ANOVA_6_DIV(:,5),STATS_FOR_ANOVA_6_DIV(:,6));

all_uni_3_div = vertcat(STATS_FOR_ANOVA_old_3_DIV(:,4),STATS_FOR_ANOVA_old_3_DIV(:,5),STATS_FOR_ANOVA_old_3_DIV(:,6));


all_uni_input_based = vertcat(STATS_FOR_ANOVA_INPUT_BASED(:,4),STATS_FOR_ANOVA_INPUT_BASED(:,5),STATS_FOR_ANOVA_INPUT_BASED(:,6));

all_uni_HU1 = vertcat(STATS_FOR_ANOVA_HU1(:,4),STATS_FOR_ANOVA_HU1(:,5),STATS_FOR_ANOVA_HU1(:,6));

if deep >0;
all_uni_HU2 = vertcat(STATS_FOR_ANOVA_HU2(:,4),STATS_FOR_ANOVA_HU2(:,5),STATS_FOR_ANOVA_HU2(:,6));
all_uni_all_HU = vertcat(STATS_FOR_ANOVA_all_HU(:,4),STATS_FOR_ANOVA_all_HU(:,5),STATS_FOR_ANOVA_all_HU(:,6));
end

%% save workspace
if no_runs == 8;
    if control == 1;
    save('sim_matrices_results_workspace_80runs_NEW_CONTROL') %change if change number of runs
    end
    if control == 2; 
save('sim_matrices_results_workspace_80runs_NEW_CONTROLLED_OUTPUT') %change if change number of runs
    end
    if control == 3; 
save('sim_matrices_results_workspace_80runs_NEW_OUTPUT_MODALITIES') %change if change number of runs
    end
end

if no_runs == 2;
    if control == 1;
    save('sim_matrices_results_workspace_20runs_NEW_CONTROL') %change if change number of runs
    end
    if control == 2; 
save('sim_matrices_results_workspace_20runs_NEW_CONTROLLED_OUTPUT') %change if change number of runs
    end
    if control == 3; 
save('sim_matrices_results_workspace_20runs_NEW_OUTPUT_MODALITIES') %change if change number of runs
    end

end

end