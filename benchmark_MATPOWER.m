function benchmark_MATPOWER(N, Ns, OPFcase ,OPFsolver, OPFstart, OPFvoltage, OPFbalance)

% path to the Matpower library (update to reflect the location at your system)
addpath( ...
    'matpower7.0/lib', ...
    'matpower7.0/lib/t', ...
    'matpower7.0/data', ...
    'matpower7.0/mips/lib', ...
    'matpower7.0/mips/lib/t', ...
    'matpower7.0/most/lib', ...
    'matpower7.0/most/lib/t', ...
    'matpower7.0/mptest/lib', ...
    'matpower7.0/mptest/lib/t', ...
    '-end' );    

% path to the BELTISTOS library (update to reflect the location at your system)
addpath( ...
    '../beltistos', ...
    '-end' );

% path to the KNITRO library (update to reflect the location at your system)
addpath( ...
    'knitro/knitro-12.2.0-Linux-64/knitromatlab',...
    '-end' );

% path to Matlab interface to the Pardiso linear solver
%addpath( ...
%    'pardisomatlab',...
%    '-end' );

% path to the auxiliary files containing also the MPOPF demo (update to reflect the location at your system)
addpath( ...
    'demo', ...
    'demo/data', ...
    '-end' );

constants;

%% load the Matpower case and create Matpower options

mpc        = loadcase(char(OPFcase));
mpopt      = create_options(mpc, N, Ns, OPFsolver, OPFstart, OPFvoltage, OPFbalance);

if (N>1)
    % load scaling profile
    LoadScaling  = create_load_profile(mpc, N, 'TI240hrs.dat');
    
    % prepare storage data
    Emax = 2.0; E0 = 0.7; rmax = 1/3; rmin = -1/2; eta_d = 0.97; eta_c = 0.95;
    Storages = create_storage_devices(mpc, Ns, Emax, E0, rmax, rmin, eta_d, eta_c);
    
    % create the multiperiod case
    mpc = create_multiperiod_mpc(mpc, N, LoadScaling, Storages);
end

% solve the OPF/MPOPF
[RESULTS, SUCCESS] = runopf(mpc, mpopt);

% log some information
fprintf('========== Results =========\n');
if (SUCCESS)
  fprintf('Problem converged\n');
else
  fprintf('Did NOT converge\n');
end

fprintf('Number of Iterations....: %d\n', RESULTS.raw.output.iterations);
fprintf('Time to Solution........: %f\n', RESULTS.et);
fprintf('Final cost..............: %f\n', RESULTS.f);
