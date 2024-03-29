% Gaussian Process Regression for Localization with Encoded Data
% Authors: Katarina Vuckovic
% Date: 3/29/2024
% Description: 
% Description: This script trains the Gaussian Process Regression (GPR) model for
% localization using a dataset of ADP samples. 
% The code is using a Matern 3/2 kernel. Replace with other kernels and repeat simulation to train the best model. 
% The example is for encoded 16x16 ADP. 

% References:
% 1. https://www.mathworks.com/help/stats/fitrgp.html

% Clear workspace and console
clear all;
close all;
clc;

% Start timing
tic;

% Load dataset
load('ADP_BS1_Nt16_Nc16_BW100MHz_yaxis_encoded_rev1.mat');

% Training input
Nt = 16;
Out = eADP;
x1 = loc(:,1);
x2 = loc(:,2);

% Convert output to table format
T = array2table(Out);
T1 = T;
T1.x1 = x1;
T2 = T;
T2.x2 = x2;

% Set number of samples and percentage for training
n = 72400;
percent_all = [10,5,1,0.5,0.25,0.1];

% Train GPR models for x and y locations
for i = 1:50 % i is hte number of folds 
    for p = 1:length(percent_all) %
        rng(i, 'twister');
        perm = randperm(n);
        percent = percent_all(p) / 100;
        
        % Split data into training sets
        Ttrain1 = T1(perm(1:round(n * percent)), :);
        Ttrain2 = T2(perm(1:round(n * percent)), :);
        
        % X location training 
        % Repeat evaluation with other kernels for optimal result
        fprintf('Start GP training for x location\n');
        gprMd1 = fitrgp(Ttrain1, 'x1', 'KernelFunction', 'matern32', ...
                        'KernelParameters', [0.01, 25], 'Sigma', 0.5);
        
        % Y location training
        % Repeat evaluation with other kernels for optimal rsult
        fprintf('Start GP training for y location\n');
        gprMd2 = fitrgp(Ttrain2, 'x2', 'KernelFunction', 'matern32', ...
                        'KernelParameters', [0.01, 25], 'Sigma', 0.5);
        
        % Save trained models
        filename = strcat('mld_BS1_ADP16_100MHz_encoded4_', num2str(percent_all(p)), 'p_seed', num2str(i)');
        save(filename, 'gprMd1', 'gprMd2');
    end
end

% End timing
toc;
