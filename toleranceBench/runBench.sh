#!/bin/bash

## specify tool for memory tracking
MEMORY_WRAPPER="/usr/bin/time -v"
TIMEOUT_WRAPPER="timeout --signal=KILL --verbose --foreground 5h"
MATLAB="/usr/global/bin/matlabR2018b"

export OMP_NUM_THREADS=1
export MKL_NUM_THREADS=1

/usr/global/bin/matlabR2018b -singleCompThread -nodisplay -nosplash -nodesktop  -r "try convergence_tol; catch; end; quit" 2>&1 
