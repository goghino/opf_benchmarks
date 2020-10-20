function adjust_ipopt_opt(tol)
    A = regexp( fileread('beltistos.opt'), '\n', 'split');
    A{12} = ['dual_inf_tol   '   num2str(tol)];
    A{13} = ['compl_inf_tol    ' num2str(tol)];
    A{14} = ['constr_viol_tol    ' num2str(tol)];
    A{15} = ['tol    '        num2str(tol)];
    A{33} = ['acceptable_constr_viol_tol   '   num2str(tol/5)];
    A{34} = ['acceptable_tol   '   num2str(tol/5)];
    a = A(1:end-1);

    fid = fopen('beltistos.opt', 'w');
    fprintf(fid, '%s\n', a{:});
    fclose(fid);
end
