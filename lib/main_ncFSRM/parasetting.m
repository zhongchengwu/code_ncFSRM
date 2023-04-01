function [paras] = parasetting(dataindex, type, I_lrms, I_pan)
% 
[~, ~, l] = size(I_lrms);
sz = size(I_pan);
Nways = [sz, l];
paras = [];
paras.sz = sz;
paras.Nways = Nways;
paras.F_it = 2;
paras.tol = 2*1e-5;
paras.maxit = 200;
% Such parameter configuration can be further fine-tuned
% on your data, if need.
%% =====Paras setting========
switch dataindex
    case 'pleiades2'   % (sensor: Pleiades)
        lambda{1} = 0.00057;
        lambda{2} = 0.00000017;
        eta{1} = 0.30;
        eta{2} = 0.000041;
        rho = 0.058;
        paras.eta = eta;
        paras.rho = rho;
        paras.lambda = lambda;
    case 'guangzhou'   % (sensor: GF-2)
        if strcmp(type, 'R')
            lambda{1} = 0.00057;
            lambda{2} = 0.00000073;
            eta{1} = 0.038;
            eta{2} = 0.00004;
            rho = 0.19;
            paras.eta = eta;
            paras.rho = rho;
            paras.lambda = lambda;
        elseif strcmp(type, 'F')
            lambda{1} = 0.00037;
            lambda{2} = 0.00000043;
            eta{1} = 0.001;
            eta{2} = 0.00004;
            rho = 0.19;
            paras.eta = eta;
            paras.rho = rho;
            paras.lambda = lambda;
        end
    case 'alice'   % (sensor: WV-4)
        lambda{1} = 0.00045;
        lambda{2} = 0.00001;
        eta{1} = 0.022;
        eta{2} = 0.000022;
        rho = 0.13;
        paras.eta = eta;
        paras.rho = rho;
        paras.lambda = lambda;
    case 'tripoli'   % (sensor: WV-3)
        if strcmp(type, 'R')
            lambda{1} = 0.00041;
            lambda{2} = 0.0000009;
            eta{1} = 0.022;
            eta{2} = 0.000014;
            rho = 0.12;
            paras.eta = eta;
            paras.rho = rho;
            paras.lambda = lambda;
        elseif strcmp(type, 'F')
            lambda{1} = 0.0022;
            lambda{2} = 0.0000013;
            eta{1} = 0.0006;
            eta{2} = 0.00003;
            rho = 0.14;
            paras.eta = eta;
            paras.rho = rho;
            paras.lambda = lambda;
        end
end
%
end