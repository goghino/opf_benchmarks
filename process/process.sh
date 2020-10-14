#!/bin/bash

if [ $# -lt 2 ]; then
  echo "usage: $0 option prefix"
  echo "prefix is relative path to folder with output logs"
  echo "option in one of the following:"
  echo "   t - prints Matpower time to convergence (s)"
  echo "   m - prints maximum resident set size (MB)"
  echo "   i - prints number of iterations"
  echo "   f - prints final cost ($/h)"
  echo "   c - prints constraint violation"
  exit 1;
fi

OPTION=$1
PREFIX="$2"

## load benchmark configuration
echo "Loading configuration from config_process.sh"
. config_process.sh

#echo "Loading configuration from ../config.sh"
#. ../config.sh

## now loop through the cases and solvers and extract desired info
## prints the info to the stdout
##        s1 s2 s3 ... sN
## case1  .  .   .      .
## case2  .  .   .      .
## case3  .  .   .      .
for Nstorage in "${Nstorages[@]}"; do
      if [ ${#Nstorages[@]} -gt 1 ]; then
        printf "Ns=$Nstorage ";
        printf "\n"
      fi
      
      for MPcase in "${grids[@]}"; do
          printf "$MPcase "
          for OPFstart in "${OPFstarts[@]}"; do
            if [ ${#OPFstarts[@]} -gt 1 ]; then
              printf "x0=$OPFstart ";
            fi
          for OPFbalance in "${OPFbalances[@]}"; do
            if [ ${#OPFbalances[@]} -gt 1 ]; then
              printf "PF=$OPFbalance ";
            fi
          for OPFvoltage in "${OPFvoltages[@]}"; do
            if [ ${#OPFvoltages[@]} -gt 1 ]; then
              printf "V=$OPFvoltage ";
            fi
          for Nperiod in "${Nperiods[@]}"; do
            if [ ${#Nperiods[@]} -gt 1 ]; then
              printf "N=$Nperiod ";
            fi
          for Nstorage in "${Nstorages[@]}"; do
                if [ ${#Nstorages[@]} -gt 1 ]; then
                  printf "Ns=$Nstorage ";
                fi
          for solver in ${solvers[@]}; do
            if [ ${#solvers[@]} -gt 1 ]; then
              printf "solver=$solver ";
            fi
          done
          done
          done
          done
          done
          done
          printf "\n"
      done
      printf  "\n\n"
done
printf  "\n"
    
for Nstorage in "${Nstorages[@]}"; do
for MPcase in "${grids[@]}"; do
    #only one of the following arrays should have length > 1, it will represent columns of the table above
    for OPFstart in "${OPFstarts[@]}"; do
    for OPFbalance in "${OPFbalances[@]}"; do
    for OPFvoltage in "${OPFvoltages[@]}"; do
    for Nperiod in "${Nperiods[@]}"; do
    for Nstorage in "${Nstorages[@]}"; do
    for solver in ${solvers[@]}; do
        case $solver in
        $IPOPT)          ./processIPOPT.sh     ${PREFIX}/${MPcase}-${IPOPT}-$OPFstart$OPFvoltage$OPFbalance-$Nperiod-$Nstorage.out  ${OPTION}; ;;
        $BELTISTOSmpopf) ./processBELTISTOS.sh     ${PREFIX}/${MPcase}-${BELTISTOSmpopf}-$OPFstart$OPFvoltage$OPFbalance-$Nperiod-$Nstorage.out ${OPTION}; ;;
        $BELTISTOSmem)   ./processBELTISTOS.sh     ${PREFIX}/${MPcase}-${BELTISTOSmem}-$OPFstart$OPFvoltage$OPFbalance-$Nperiod-$Nstorage.out ${OPTION}; ;;
        $BELTISTOSopf)   ./processBELTISTOS.sh     ${PREFIX}/${MPcase}-${BELTISTOSopf}-$OPFstart$OPFvoltage$OPFbalance-$Nperiod-$Nstorage.out ${OPTION}; ;;
        $MIPS)           ./processMIPS.sh      ${PREFIX}/${MPcase}-${MIPS}-$OPFstart$OPFvoltage$OPFbalance-$Nperiod-$Nstorage.out    ${OPTION}; ;;
        $MIPSsc)         ./processMIPS.sh      ${PREFIX}/${MPcase}-${MIPSsc}-$OPFstart$OPFvoltage$OPFbalance-$Nperiod-$Nstorage.out  ${OPTION}; ;;
        $MIPSscPardiso)  ./processMIPS.sh      ${PREFIX}/${MPcase}-${MIPSscPardiso}-$OPFstart$OPFvoltage$OPFbalance-$Nperiod-$Nstorage.out  ${OPTION}; ;;
        $IPOPTHSL)       ./processIPOPT.sh     ${PREFIX}/${MPcase}-${IPOPTHSL}-$OPFstart$OPFvoltage$OPFbalance-$Nperiod-$Nstorage.out   ${OPTION}; ;;
        $KNITRO)         ./processKnitro.sh    ${PREFIX}/${MPcase}-${KNITRO}-$OPFstart$OPFvoltage$OPFbalance-$Nperiod-$Nstorage.out  ${OPTION}; ;;
        $FMINCON)        ./processFMINCON.sh   ${PREFIX}/${MPcase}-${FMINCON}-$OPFstart$OPFvoltage$OPFbalance-$Nperiod-$Nstorage.out ${OPTION}; ;;
        *) echo "solver=$solver IS NOT A VALID SOLVER"; ;;
        esac;
    done
    done
    done
    done
    done
    done
    printf "\n"
done
printf "\n\n"
done
