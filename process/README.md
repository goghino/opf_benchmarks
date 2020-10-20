The script `process.sh` can be used to extract the desired information from the benchmark logs. The benchmark configuration is assumed to be specified in `config_process.sh`. 

```
usage: ./process.sh option prefix
prefix is relative path to folder with the output logs
option in one of the following:
   t - prints Matpower time to convergence (s)
   m - prints maximum resident set size (MB)
   i - prints number of iterations
   f - prints final cost ($/h)
   c - prints constraint violation
```
