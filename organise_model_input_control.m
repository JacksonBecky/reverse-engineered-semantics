
function [ final_results_ordered, IO, pairwise, atl,pairs_plus_atl] = organise_model_input_control(results_data, deep, num_ex, control)
%NEED DIFF IF NO ATL - ALL LAYER SEPARATIONS DIFF - 1st same, 2nd up to 96,
%last del
%TAKES RESULTS DATA - TAKES THE FINAL EPOCHS ACTIVATION ONLY - ORDERS BY EXAMPLES (1ST EX IN 1ST MODALITY/CONTEXT THEN 1ST EX IN
%2ND MODALITY/CONTEXT ETC) + SPLITS INTO LAYERS
%MODALITY/CONTEXT ORDER IS M1_M1, M2_M1, M3_M1, M1_M2, M2_M2, M3_M2, M1_M3
%M2_M3, M3_M3 AS IN LENS

final_results = zeros(num_ex, 96);
final_results_ordered = zeros(num_ex, 96);
%take every 25th row = final acts
f=25; %is no of epochs in trial
m=1;
for m=1:num_ex;  %is number of examples  - TAKES LAST EPOCH OF TRIAL ONLY
final_results(m,:) =results_data(f, :);
f=f+25;
m=m+1;
end
%reorder so diff mod versions of same example together
i=1;
j=17;
k=33;% is 1st to 3rd version of examples - needs 9 for basic control
if control >0;
n=49;
o=65;
p=81;
q=97;
r=113;
s=129;
t=145;
end

m=1;
for l=1:16;
final_results_ordered(m,:) = final_results(i, :);
m=m+1;
final_results_ordered(m,:) = final_results(j, :);
m=m+1;
final_results_ordered(m,:) = final_results(k, :);
m=m+1;
if control >0;
final_results_ordered(m,:) = final_results(n, :);
m=m+1;
final_results_ordered(m,:) = final_results(o, :);
m=m+1;
final_results_ordered(m,:) = final_results(p, :);
m=m+1;
final_results_ordered(m,:) = final_results(q, :);
m=m+1;
final_results_ordered(m,:) = final_results(r, :);
m=m+1;
final_results_ordered(m,:) = final_results(s, :);
m=m+1;
n=n+1;
o=o+1;
p=p+1;
q=q+1;
r=r+1;
s=s+1;
end
i=i+1;
j=j+1;
k=k+1;
end

%split into layers - differs by arch inc ATL/not or change no HUs
IO = final_results_ordered(:, 1:36);

if deep ==1;
    pairwise = final_results_ordered(:, 37:78);
    atl = final_results_ordered(:, 79:96);
    pairs_plus_atl = final_results_ordered(:, 37:96);
else
    pairwise = final_results_ordered(:, 37:96);

end
