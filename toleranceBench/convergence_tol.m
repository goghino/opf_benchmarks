clc
close all

% path to the MATPOWER library (update to reflect the location at your system)
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
    'beltistos', ...
    '-end' );

% path to the KNITRO library (update to reflect the location at your system)
addpath( ...
    'knitro-12.2.0-Linux-64/knitromatlab',...
    '-end' );


setenv('OMP_NUM_THREADS', '1')

warning('off','all');

define_constants;
%%
% [   0 - default, use interior point estimate for fmincon, Ipopt,    ]
% [       Knitro and MIPS; use current state for other solvers        ]
% [   1 - ignore current state when initializing OPF (only applies to ]
% [       fmincon, Ipopt, Knitro and MIPS), currently identical to 0  ]
% [   2 - use current state to initialize OPF                         ]
% [   3 - attempt to solve power flow to initialize OPF               ]
init_mode = 3;

mpopt = mpoption('verbose', 2, 'out.all', 0);
mpopt = mpoption(mpopt, 'opf.start', init_mode);

%% solvers
%mpopt = mpoption(mpopt, 'opf.ac.solver', 'KNITRO'); mpopt.knitro.opt_fname='knitro.opt';
KNITRO_ADJUST_TOL=0;

mpopt = mpoption(mpopt, 'opf.ac.solver', 'IPOPT');
mpopt = mpoption(mpopt, 'opf.v_cartesian', 0, 'opf.current_balance', 0);
mpopt.ipopt.opts = struct('linear_solver', 'beltistos-opf');
IPOPT_ADJUST_TOL=1;

%mpopt = mpoption(mpopt, 'opf.ac.solver', 'MIPS', 'mips.step_control', 1);
%mpopt.mips.max_it  = 500;
MIPS_ADJUST_TOL=0;

%mpopt = mpoption(mpopt, 'opf.ac.solver', 'FMINCON');
%mpopt.fmincon.max_it = 500;
FMINCON_ADJUST_TOL=0;

%% tolerances and errors

tolerances = [1e-2 1e-3 1e-4 1e-5 1e-6 1e-7 1e-8 1e-9 1e-10 1e-11 1e-12];

err_abs_inf = [];
err_rel_inf = [];
err_abs_2 = [];
err_rel_2 = [];
err_g_inf = [];
err_g_2 = [];
err_h_inf = [];
err_h_2 = [];
err_abs_f = [];
err_rel_f = [];
    
%% select cases
cases = { 
    'case1951rte'
    'case2383wp'
    'case2736sp'
    'case2737sop'
    'case2746wop'
    'case2746wp'
    'case2868rte'
    'case2869pegase'
    'case3012wp'
    'case3120sp'
    'case3375wp'
    'case6468rte'
    'case6470rte'
    'case6495rte'
    'case6515rte'
    'case9241pegase'
    'case_ACTIVSg2000'
    'case_ACTIVSg10k'
    'case13659pegase'
    };

for c = 1:length(cases)

    mpc = loadcase(cases{c});

    %% Solve the case with different tolerances
    solutions = [];
    values = [];
    g_constraints = [];
    h_constraints = [];

    for i = 1:length(tolerances)
        tolerance = tolerances(i);
        
        mpopt.opf.violation = tolerance;
        if (IPOPT_ADJUST_TOL)
        adjust_ipopt_opt(tolerance);
        end
        if (KNITRO_ADJUST_TOL)
        adjust_knitro_opt(tolerance);
        end
        if (FMINCON_ADJUST_TOL)
        mpopt.fmincon.tol_x = 1e-16; %step tolerance, do not consider
        mpopt.fmincon.tol_f = tolerance; %optimality error
        end
        if (MIPS_ADJUST_TOL)
        mpopt.mips.feastol = tolerance;
        mpopt.mips.gradtol = tolerance;
        mpopt.mips.comptol = tolerance;
        mpopt.mips.costtol = 1; %do not consider rel. improvement in objective
        end
        
        fprintf("\n\n\nRunning with tol=%e\n", tolerance);
        [res, SUCCESS] = runopf(mpc, mpopt);
        iterations(c,i) = res.raw.output.iterations;
        successes(c,i) = SUCCESS;

        solutions  = [solutions res.x];
        values     = [values res.f];
        g_constraints = [g_constraints res.g];
        h_constraints = [h_constraints res.h];   
    end

    %%

    %the x with the tightest tolerance will be used as a reference
    xstar = res.x;
    fstar = res.f;

    for i = 1:length(tolerances)
        x = solutions(:,i);
        f = values(i);
        g = g_constraints(:,i);
        h = max(h_constraints(:,i), 0); %h(x) < 0, ignore h<0 values

        %error in inf-norm
        err_abs_inf(c,i) = norm(x-xstar,Inf);
        err_rel_inf(c,i) = norm(x-xstar,Inf)/norm(xstar,Inf); 

        %error in 2-norm
        err_abs_2(c,i) = norm(x-xstar,2);
        err_rel_2(c,i) = norm(x-xstar,2)/norm(xstar,2);

        %error in constraints
        err_g_inf(c,i) = norm(g,Inf);
        err_g_2(c,i) = norm(g,2);

        err_h_inf(c,i) = norm(h,Inf);
        err_h_2(c,i) = norm(h,2);

        %difference in objective function
        err_abs_f(c,i) = f - fstar;
        err_rel_f(c,i) = (f - fstar)/fstar;
    end

format long e;

string(cases)
num2str(tolerances, '%1.0e\n')

fprintf("\n\n\nerr_rel_2");
array2table(err_rel_2','VariableNames', cases(1:c))
fprintf("\n\n\nerr_g_inf");
array2table(err_g_inf','VariableNames', cases(1:c))
fprintf("\n\n\nerr_h_inf");
array2table(err_h_inf','VariableNames', cases(1:c))
fprintf("\n\n\nerr_rel_f");
array2table(err_rel_f','VariableNames', cases(1:c))
fprintf("\n\n\niterations");
array2table(iterations','VariableNames', cases(1:c))
fprintf("\n\n\nsuccess");
array2table(successes','VariableNames', cases(1:c))
end
