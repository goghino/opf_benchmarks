#!/bin/bash

if [ $# -ne 2 ]; then
  echo "usage: $0 <logfile> <option>"
  echo "option in one of the following:"
  echo "   t - prints Matpower time to convergence (s)"
  echo "   m - prints maximum resident set size (MB)"
  echo "   i - prints number of iterations"
  echo "   c - prints constraint violation"
  echo "   f - prints final cost"
  exit 1;
fi
LOGFILE=$1
OPTION=$2

/usr/bin/awk -v opt="${OPTION}" \
              '
              /Total memory for MPOPF        :/                { memSolver=$6}  \
              /Total memory for PARDISO      :/                { memSolver=$6}  \
              /Maximum resident set size \(kbytes\):/          { mem=$6   }     \
              /EXIT: Solved To Acceptable Level./              { converged=1 }  \
              /EXIT: Optimal Solution Found./                  { converged=1 }  \
              /Did NOT converge/                               { NOTconverged=1}\
              /Time to Solution........:/                      { time=$4  }     \
              /Number of Iterations....:/                      { iter=$4  }     \
              /Final cost..............:/                      { cost=$3  }     \
              /Constraint violation....:/                      { constr=$4  }   \
              /Initialization phase:/                          { init=$3}  \
              /Factorization  phase:/                          { fact=$3}  \
              /Solution       phase:/                          { solve=$3}  \
              /Total OPFSolver Time:/                          { total=$4}  \
              END { 
                if (converged && opt == "t")
                  printf " %.2f", time; 
                  #printf " %.2f", fact+solve;
                else if (converged && opt == "m")
                  printf " %.2f", mem/1024;
                else if (converged && opt == "i")
                  printf " %d", iter;
                else if (converged && opt == "f")
                  printf " %.4f", cost;
                else if (converged && opt == "c")
                  {printf " "; printf constr;}
                else
                  printf " %.2f", 1e10;
              } ' ${LOGFILE}
