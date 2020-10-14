#!/bin/bash

#########################################################
## declare constants (DO NOT CHANGE THE NUMBERS BELOW!!!)

#solvers
MIPS=1;
MIPSsc=2;
FMINCON=3;
IPOPT=4;
KNITRO=5;
BELTISTOSopf=6;
MIPSscPardiso=7;
IPOPTHSL=8;
BELTISTOSmpopf=9;
BELTISTOSmem=10;

#OPFstart
FLAT=1;
MPC=2;
PF=3;

#OPFvoltage
POLAR=0;
CARTESIAN=1;

#OPFbalance
POWER=0;
CURRENT=1;

## end of constant declaration (DO NOT CHANGE THE NUMBERS ABOVE!!!)
###################################################################

## declare an array of the benchmarks
declare -a grids=(
    "case1951rte"
    "case2383wp"
    "case2736sp"
    "case2737sop"
    "case2746wop"
    "case2746wp"
    "case2868rte"
    "case2869pegase"
    "case3012wp"
    "case3120sp"
    "case3375wp" 
    "case6468rte"
    "case6470rte"
    "case6495rte"
    "case6515rte"
    "case9241pegase"
    "case_ACTIVSg2000"
    "case_ACTIVSg10k"
    "case13659pegase"
    "case_ACTIVSg25k"
    "case_ACTIVSg70k"
    "case21k"
    "case42k"
    "case99k"
    "case193k"
    ) 

## select initial points to be tested
declare -a OPFstarts=($FLAT $MPC $PF)

## select OPF formulations
declare -a OPFvoltages=($POLAR $CARTESIAN)
declare -a OPFbalances=($POWER $CURRENT)

## specify MPOPF parameters
declare -a Nperiods=(1)  #for OPF problems equals to 1
declare -a Nstorages=(0) #for OPF problems Nstorages is ignored but make the array length 1

## specify optimizer
#declare -a solvers=("$IPOPT")
#declare -a solvers=("$IPOPTHSL")
#declare -a solvers=("$KNITRO")
#declare -a solvers=("$FMINCON")
declare -a solvers=("$BELTISTOSopf")
#declare -a solvers=("$MIPSscPardiso")
#declare -a solvers=("$MIPSsc")

# structure exploiting MPOPF optimizers
#declare -a solvers=("$BELTISTOSmem")
#declare -a solvers=("$BELTISTOSmpopf")
