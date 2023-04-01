function [X_out, U_out, V_out, Theta_out] = ADMM_solver(I_lrms, Ref_pan, Rec_E, Xlast, par, paras, U, V, Theta)
%
eta = paras.eta;
F_it = paras.F_it;
ratio = paras.ratio;
Nways = paras.Nways;
sensor = paras.sensor;
lambda = paras.lambda;
%
if (isempty(U))
    U = zeros(Nways);
    V = U; 
    Theta = {U, V};
end
%
for nstep = 1:F_it
    % update X
    X = X_solver(U, V, Xlast, Theta, par, paras);
    % update U
    U = U_solver(I_lrms, X, Theta{1}, par, paras);
    % update V
    V = (2*lambda{1}*(Rec_E+Ref_pan) + eta{2}*X+Theta{2})/(2*lambda{1}+eta{2}); 
    % update Theta
    Theta{1} = Theta{1} + eta{1}*(MTF_lrms(X, sensor, '', ratio) - U);
    Theta{2} = Theta{2} + eta{2}*(X - V);
end
%
X_out = X;
U_out = U;
V_out = V;
Theta_out = Theta;
%
end 