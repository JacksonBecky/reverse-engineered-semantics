README

To run the simulations in LENS-
Set up LENS with the my_procs.tcl file in its path and run using -
source my_procs.tcl 

Make sure the examples files are in the same directory.

Comment out the simulations where instructed and run using either optimal.net (for the best performing model) or hierarchy.net (where you can use the comments to construct any of the architectures, with or without control.

Run in LENS -
source optimal.net

Save the activation results, for deep architectures use - 
testAllActs results.txt {m1rep m2rep m3rep m1m2 m2m1 m1m3 m3m1 m2m3 m3m2 HL2}

For shallow architectures use -
testAllActs results.txt {m1rep m2rep m3rep m1m2 m2m1 m1m3 m3m1 m2m3 m3m2 HL2}

The number of epochs taken to learn may be read out from the LENS terminal. To assess the similarity to the example structure and determine teh level of conceptual abstraction run 80 models and save them with a given name and then the numbers 1-80.

To process these results in Matlab-
Run NEW_input_data_CONTROL_GIT.m or NEW_input_data_NO_CONTROL_GIT.m if the simulations were ran without the additional constraint of conext-sensitivity.

This will give the conceptual abstraction of a given architecture (average over model runs and take the layer with the highest value to get a single value). If you wish to compare architectures take the results variables as input to statistical tests.

Additional analyses in Matlab -

The univariate activation changes by context can be assessed using - 
get_similarity_of_activity_across_contexts.m

The functional connectivity changes by context can be assessed using - 
FUNCTIONAL_CONNECTIVITY_CONTEXT_DEPENDENT_HUB_TO_SPOKES.m