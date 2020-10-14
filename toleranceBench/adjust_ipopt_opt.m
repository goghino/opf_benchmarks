function adjust_ipopt_opt(tol)
    A = regexp( fileread('beltistos.opt'), '\n', 'split');
    A{17} = ['dual_inf_tol   '   num2str(tol)];
    A{18} = ['compl_inf_tol    ' num2str(tol)];
    A{19} = ['constr_viol_tol    ' num2str(tol)];
    A{20} = ['tol    '        num2str(tol)];
    a = A(1:end-1);

    fid = fopen('beltistos.opt', 'w');
    fprintf(fid, '%s\n', a{:});
    fclose(fid);
end
