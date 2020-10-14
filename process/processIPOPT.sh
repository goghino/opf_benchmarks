#!/bin/bash

if [ $# -ne 2 ]; then
  echo "usage: $0 <logfile> <option>"
  echo "option in one of the following:"
  echo "   t - prints Matpower time to convergence (s)"
  echo "   m - prints maximum resident set size (MB)"
  echo "   i - prints number of iterations"
  echo "   f - prints final cost"
  echo "   c - prints constraint violation"
  exit 1;
fi
LOGFILE=$1
OPTION=$2

/usr/bin/awk -v opt="${OPTION}" \
              '/LinearSystemSymbolicFactorization..:/          { init=$2  }     \
              /LinearSystemFactorization..........:/           { fact=$2  }     \
              /LinearSystemBackSolve..............:/           { solve=$2 }     \
              /Total memory for OPF solver   : /               { memSolver=$7}  \
              /Maximum resident set size \(kbytes\):/          { mem=$6   }     \
              /Problem converged/                              { converged=1 }  \
              /Did NOT converge/                               { NOTconverged=1}\
              /Number of Iterations....:/                      { iter=$4  }     \
              /Time to Solution........:/                      { time=$4  }     \
              /Final cost..............:/                      { cost=$3  }     \
              /Constraint violation....:/                      { constr=$4  }   \
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
