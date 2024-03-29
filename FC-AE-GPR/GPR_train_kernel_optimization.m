% Gaussian Process Regression for Localization
% Authors: Katarina Vuckovic
% Date: 3/29/2024
% Description: This script performs Gaussian Process Regression (GPR) for
% localization using a dataset of antenna array measurements.
% This code optimizes over multiple kernels. 


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
percent_all = [0.1]; % Percentage of data used for training

for i = 1:1 % i is the seed. 
    for p = 1:length(percent_all)
        rng(i, 'twister');
        perm = randperm(n);
        percent = percent_all(p) / 100;
        
        % Split data into training sets
        Ttrain1 = T1(perm(1:round(n*percent)), :);
        Ttrain2 = T2(perm(1:round(n*percent)), :);
        
        % Train GPR models for x and y locations
        fprintf('Start GP training for x location\n');
        gprMd1 = fitrgp(Ttrain1, 'x1', 'OptimizeHyperparameters', {'KernelFunction', 'Sigma'}, ...
                        'HyperparameterOptimizationOptions', struct('MaxObjectiveEvaluations', 15));
        
        fprintf('Start GP training for y location\n');
        gprMd2 = fitrgp(Ttrain2, 'x2', 'OptimizeHyperparameters', {'KernelFunction', 'Sigma'}, ...
                        'HyperparameterOptimizationOptions', struct('MaxObjectiveEvaluations', 15));
        
        % Save trained models
        filename = strcat('test_mld_BS1_ADP16_100MHz_encoded4_', num2str(percent_all(p)), 'p_seed', num2str(i), '_automatic');
        save(filename, 'gprMd1', 'gprMd2');
    end
end

% End timing
toc;
