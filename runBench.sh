#!/bin/bash

## load benchmark configuration
. config.sh

## specify tool for memory tracking
MEMORY_WRAPPER="/usr/bin/time -v"
TIMEOUT_WRAPPER="timeout --signal=KILL --verbose --foreground 5h"
MATLAB="/usr/global/bin/matlabR2018b"

export OMP_NUM_THREADS=1
export MKL_NUM_THREADS=1

## now loop through the cases and solvers
for OPFcase in "${grids[@]}"; do
for OPFsolver in "${solvers[@]}"; do
for OPFstart in "${OPFstarts[@]}"; do
for OPFvoltage in "${OPFvoltages[@]}"; do
for OPFbalance in "${OPFbalances[@]}"; do
for Nperiod in "${Nperiods[@]}"; do
for Nstorage in "${Nstorages[@]}"; do

${MEMORY_WRAPPER} ${TIMEOUT_WRAPPER} /usr/global/bin/matlabR2018b -singleCompThread -nodisplay -nosplash -nodesktop -r "try benchmark_MATPOWER($Nperiod, $Nstorage, '$OPFcase',$OPFsolver, $OPFstart, $OPFvoltage, $OPFbalance); catch; end; quit" 2>&1 | tee data/$OPFcase-$OPFsolver-$OPFstart$OPFvoltage$OPFbalance-$Nperiod-$Nstorage.out

done
done
done
done
done
done
done
