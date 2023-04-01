function U_out = U_solver(I_lrms, X, Theta, par, paras)
%
sz = paras.sz;
eta = paras.eta;
ratio = paras.ratio;
Nways = paras.Nways;
%
temp_Up = par.ST(I_lrms)+eta{1}*par.B(X)+Theta;
%
D_sst = zeros(sz);
s0 = 3;
D_sst(s0:ratio:end,s0:ratio:end) = ones(sz/ratio);
%
temp_Down_band = D_sst+eta{1};
temp_Down = repmat(temp_Down_band, [1 1 Nways(3)]);
%
U_out = temp_Up ./ temp_Down;
%
end