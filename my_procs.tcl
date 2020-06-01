# prints the activation of a unit
# use with printUnitValues to write to a file for whole groups
# Adapted by Chen Lan to work with SRNs
proc printActivation {group unit} {format "%.3f " [getObj $unit.output]}

proc saveActivations {fname groups} {
    # open a channel to fname, output to be appended
    set outfile [open $fname a]
    puts $outfile "[getObj currentExample.num] [getObj currentExample.name] [getObj currentTick] " nonewline
    printUnitValues -$outfile printActivation $groups
    puts $outfile "\n" nonewline
    close $outfile
}

proc testAllFinalActs {fname groups} {
    resetExampleSet [getObj testingSet.name]
    set nex [getObj testingSet.numExamples]
    for {set i 0} {$i < $nex} {incr i} {
	doExample -set [getObj testingSet.name]
	saveActivations $fname $groups
    }
}

proc testAllActs {fname groups} {
    useTrainingSet {}
    resetExampleSet [getObj testingSet.name]
    set nex [getObj testingSet.numExamples]
    set outfile [open $fname a]

    setObj testGroupCrit 0.0

    for {set iex 0} {$iex < $nex} {incr iex} {
	     doExample
	    set nticks [getObj ticksOnExample]
	    set mticks [getObj historyLength]
	    set startps [getObj exampleHistoryStart]
	for {set itick 0} {$itick < $nticks} {incr itick} {
        set actps [expr ($itick + $startps)%$mticks]
		puts $outfile "$iex [getObj currentExample.name] $itick " nonewline
	    foreach igroup $groups {
		set nunits [getObj "$igroup.numUnits"]
		for {set iunit 0} {$iunit < $nunits} {incr iunit} {
		    puts $outfile [format "%.3f " [getObj "$igroup.unit($iunit).outputHistory($actps)"]] nonewline
		}
	    }
	    puts $outfile "\n" nonewline
	}
    }
    close $outfile
}