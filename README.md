This repository contains demo example intended to demonstrate the
structure exploiting solution method of the MPOPF problems. Additionaly,
it contains benchmark environment that can be used to reproduce the results
from the technical report: 

@misc{kardos2018complete,
    title={Complete results for a numerical evaluation of interior point solvers for large-scale optimal power flow problems},
    author={Juraj Kardos and Drosos Kourounis and Olaf Schenk and Ray Zimmerman},
    year={2018},
    eprint={1807.03964},
    archivePrefix={arXiv},
    primaryClass={math.OC}
}


Dependencies:
=============

MATPOWER Version 7.0, 19-Jun-2019. MATPOWER is a package of Matlab
M-files for solving power flow and optimal power flow problems. It is
intended as a simulation tool for researchers and educators that is easy
to use and modify. For more information visit https://matpower.org

MIPS MATPOWER Interior Point Solver for nonlinear programming. For more
information see: H. Wang, C.E. Murillo-Sanchez, R.D. Zimmerman, R.j.Thomas,
"On Computational Issues of Market-Based Optimal power flow",
IEEE Transactions on power Systems, Vol. 22, No. 3, Aug. 2007, pp. 1185-1193.

IPOPT Version 3.12.10, a library for large-scale nonlinear optimization.
Ipopt is released as open source code under the Eclipse Public License (EPL).
For more information visit http://projects.coin-or.org/Ipopt. The precompiled 
binary for the Linux system can be obtained from http://www.beltistos.com

BELTISTOS, suite of high-performance OPF algorithms including extremely
scalable and low memory multiperiod OPF solver. For more information visit
http://www.beltistos.com

PARDISO Vers. 6.0, Runtime Modules of Parallel Sparse Linear Solver.
Copyright Universita della Svizzera Italiana 2000-2018. All Rights Reserved.
For more information visit https://www.pardiso-project.org

For third party solvers visit https://www.artelys.com/solvers/knitro/ (KNITRO).

INSTALL:
========

Obtain the framework at http://www.beltistos.com. You will also need to
obtain the licence from the same website. The licence should
be located in `$(HOME)/pardiso.lic` file. When running also the MPOPF benchmarks,
you will need a Matpower add-on implementing the MPOPF model (available at
http://beltistos.com/#download). When you have all the dependencies, please updates
the paths in the `benchmark_MATPOWER.m` script to reflect their location at your system.


RUN:
=======

The idea of the benchmark suite is to specify all parameters for a series of benchmarks
that shall be run, and execute the run script which iterates over all benchmark configurations.
Set the parameters related to the problem specification and solver in the
configuration file `config.sh` and execute the file `runBench.sh` to run the benchmarks.

#### Problem configuration:
The file `config.sh` allows the user to specify which benchmarks to run. First,
specify the power grids using the array `grids`.
The initial point is configured using `OPFstarts`.
The OPF problem formulation is specified via `OPFvoltages` and `OPFbalances` arrays.
Next, specify the number of time periods (`Nperiods`) and storage devices (`Nstorages`).
If `Nperiod=1` a standard OPF problem is run. For `Nperiod>1` the MPOPF problem with
Nstorage devices is run. 
Finally, specify which solvers should be used to solve the benchmarks using `solvers` array.

The benchmarks are executed using the parameters specified in these array as following:
```
for OPFcase in "${grids[@]}"; do
for OPFsolver in "${solvers[@]}"; do
for OPFstart in "${OPFstarts[@]}"; do
for OPFvoltage in "${OPFvoltages[@]}"; do
for OPFbalance in "${OPFbalances[@]}"; do
for Nperiod in "${Nperiods[@]}"; do
for Nstorage in "${Nstorages[@]}"; do

benchmark_MATPOWER($Nperiod, $Nstorage, '$OPFcase',$OPFsolver, $OPFstart, $OPFvoltage, $OPFbalance)
```

#### Notes
In order to properly extract the values from the Matpower, you need to apply the patch 'matpower.patch'. Please make sure you apply the patch to the Matpower v7.0 (e.g. do  `git checkout 7.0` in the matpower git repository).
