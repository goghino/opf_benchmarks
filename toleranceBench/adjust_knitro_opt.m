function adjust_knitro_opt(tol)
    A = regexp( fileread('knitro.opt'), '\n', 'split');
    A{4} = ['feastol_abs    ' num2str(tol)];
    A{5} = ['opttol_abs    ' num2str(tol)];
    a = A(1:end-1);

    fid = fopen('knitro.opt', 'w');
    fprintf(fid, '%s\n', a{:});
    fclose(fid);
end
