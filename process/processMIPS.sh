#!/bin/bash

if [ $# -ne 2 ]; then
  echo "usage: $0 <logfile> <option>"
  echo "option in one of the following:"
  echo "   t - prints Matpower time to convergence (s)"
  echo "   m - prints maximum resident set size (MB)"
  echo "   i - prints number of iterations"
  echo "   f - prints final cost"
  exit 1;
fi
LOGFILE=$1
OPTION=$2

/usr/bin/awk -v opt="${OPTION}" \
             '/Maximum resident set size \(kbytes\):/          { mem=$6   }     \
              /Problem converged/                              { converged=1 }  \
              /Did NOT converge/                               { NOTconverged=1}\
              /Number of Iterations....:/                      { iter=$4  }     \
              /Time to Solution........:/                      { time=$4  }     \
              /Final cost..............:/                      { cost=$3  }     \
              END { 
                if (converged && opt == "t")
                  printf " %.2f", time;
                else if (converged && opt == "m")
                  printf " %.2f", mem/1024;
                else if (converged && opt == "i")
                  printf " %d", iter;
                else if (converged && opt == "f")
                  printf " %.4f", cost;
                else
                  printf " %.2f", 1e10;
              } ' ${LOGFILE}
