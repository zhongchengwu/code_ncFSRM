%% =================================================================
% This script runs the ncFSRM code.
%
% Please make sure your data is in range [0, 1].
%
% Reference: Zhong-Cheng Wu, Ting-Zhu Huang*, Liang-Jian Deng*, Gemine Vivone
%            "A Framelet Sparse Reconstruction Method for Pansharpening with Guaranteed Convergence"
%             Inverse Problems and Imaging (IPI), 2023.
%
% Created by Zhong-Cheng Wu (wuzhch97@163.com)
% Oct. 31, 2021
% Updated by 
% Apr. 01, 2023

%% =================================================================
clc;
clear;
close all;
addpath(genpath([pwd,'/lib']));
%
load 'Sim_pleiades_pleiades2.mat'
%
if max(I_lrms(:))>1 || max(I_pan(:))>1
    error('Range: [0 1]')
end
%
fprintf('###################### Please wait......######################\n')
%% Perform interpolated image (i.e., EXP)
I_exp = interp23tap(I_lrms, ratio);
Metrics_exp = indexes_eval(Ref_I_gt, I_exp, ratio, 'print'); 

%% Perform ncFSRM algorithm
% Parameter settings
paras = parasetting(dataindex, type, I_lrms, I_pan);
% Such parameter configuration can be further fine-tuned
paras.ratio = ratio;
paras.sensor = sensor;
%
t_start = tic; 
[I_hrms] = main_ncFSRM(I_lrms, I_pan, paras);
time_ncFSRM = toc(t_start);
Metrics_fused = indexes_eval(Ref_I_gt, I_hrms, ratio, 'print');
%
fprintf('###################### Complete execution! ! !######################\n')

%% Print result
location = [20 60 50 150];
range_bar = [0, 0.05];
%
Re_images{1} = I_exp;
Re_images{2} = I_hrms;
Image_truncate(Ref_I_gt, Re_images, location)    % Display the RGB images
%
Image_residual(Ref_I_gt, Re_images, range_bar)   % Display the error maps
%