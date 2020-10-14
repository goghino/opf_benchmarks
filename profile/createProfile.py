#!/usr/bin/python

from __future__ import print_function
import sys
import csv
from sys import argv
from operator import add
import numpy as np

if len(sys.argv) < 4:
    print("usage: " + argv[0] + " <times.dat> <max_alpha> <step_alpha>")
    exit(1)

infile = argv[1]
max_alpha = int(argv[2])
step_alpha = float(argv[3])
alpha_range = np.arange(1.0, max_alpha+step_alpha, step_alpha)

#load timings
#expect times of problem_i in i-th row and solver_j in j_th column
#    s1 s2 s3
# p1
# p2
# p3
# !!! Requires times separated by a single SPACE, no trailing SPACES, skips
# SPACES at the beginning of each line
with open(infile, 'rb') as f:
    reader = csv.reader(f, skipinitialspace=True, delimiter=' ')
    times = []
    for row_i in reader:
        row_i = map(float, row_i)
        times.append(row_i)


#compute ratios w.r.t the best time for given problem p_i
ratios = []
for p_i in times:
    min_t = min(p_i) #best time for problem_i
    if (min_t > 1e9): #no solver solved this instance
        ratios.append([1e9 for p_ij in p_i]) #scale times for problem_i by the best time over j \in solvers
        print("Assuming no solver solved this problem: ", p_i, "\n")
    else:
        ratios.append([p_ij / min_t for p_ij in p_i]) #scale times for problem_i by the best time over j \in solvers

#create performance profile
# s1 s2 ... sN [for alpha=1]
# s1 s2 ... sN [for alpha=2]
# s1 s2 ... sN [for alpha=3]
profile = []
np = len(ratios) # number of problems
ns = len(ratios[0]) # number of solvers
for alpha in alpha_range:
    profile_alpha = [0 for x in range(ns)]
    for r_p in ratios:
        partial_sum = [1.0/np if r_ps <= alpha else 0.0 for r_ps in r_p ]
        profile_alpha = map(add, profile_alpha, partial_sum)
    profile.append(profile_alpha)

#output the profile
# alpha_1 s1 s2 ... sN
# alpha_2 s1 s2 ... sN
# alpha_3 s1 s2 ... sN

#header
print("ALPHA", end='')
for s in range(ns):
    print("         SOLVER" + str(s+1), end='')
print()

#data
i = 0
for alpha_i in profile:
    print(alpha_range[i], end='')
    for s in alpha_i:
        print(" %15.5f" % (s) , end='')
    print()
    i = i + 1

#print(times)
#print(ratios)
#print(profile)
