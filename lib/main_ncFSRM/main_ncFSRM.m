function [X_out] = main_ncFSRM(I_lrms, I_pan, paras)
% Initiation
if isfield(paras,'tol');     tol = paras.tol;         else  error('missing tol!');     end
if isfield(paras,'maxit');   maxit = paras.maxit;     else  error('missing maxit!');   end
if isfield(paras,'lambda');  lambda = paras.lambda;   else  error('missing lambda!');  end
%
rho = paras.rho;
ratio = paras.ratio;
sensor = paras.sensor;
Nways = paras.Nways;
X = interp23tap(I_lrms, ratio); % Initialize the X
% Framelet parameters
frame = 1;
Level = 1;
wLevel = 1/2;
[D, R] = GenerateFrameletFilter(frame);
nD = length(D);
% Histogram matching
Ref_pan = generate_ref_im(I_lrms, I_pan, paras);
par = FFT_kernel(ratio, sensor, Nways);
%
rng('default')
X_transition = zeros(Nways(1), Nways(2)*Nways(3));
E = FraDecMultiLevel(X_transition, D, Level);
%%
X_last = X;
for iter = 1:maxit
    Rec_E = Fold(FraRecMultiLevel(E, R, Level), Nways, 1);
    % Update X
    if iter==1
        [X, U, V, Theta] = ADMM_solver(I_lrms, Ref_pan, Rec_E, X, par, paras, [], [], []);
    else
        [X, U, V, Theta] = ADMM_solver(I_lrms, Ref_pan, Rec_E, X, par, paras, U, V, Theta);
    end
    % Update E
    block_transition = Unfold(X - Ref_pan, Nways, 1);
    C = FraDecMultiLevel(block_transition, D, Level);
    Thresh = sqrt(2*lambda{2} / (2*lambda{1} + rho));
    for ki=1:Level
        for ji=1:nD-1
            for jj=1:nD-1
                F_coeffs = (2*lambda{1}*C{ki}{ji,jj} + rho*E{ki}{ji,jj}) / (2*lambda{1} + rho);
                E{ki}{ji,jj} = wthresh(F_coeffs, 'h', Thresh);
            end
        end
        if wLevel<=0
            Thresh=Thresh*norm(D{1});
        else
            Thresh=Thresh*wLevel;
        end
    end
    %%
    Rel_Err = norm(Unfold(X-X_last, Nways, 3), 'fro')/norm(Unfold(X_last, Nways, 3), 'fro');
    if Rel_Err < tol  
        break;
    end
    X_last = X;
end
%
X_out = X;
% fprintf('Actual iterations = %d.       ' ,  iter);
end