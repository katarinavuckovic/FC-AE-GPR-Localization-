% Title: Non-parametric Correlation Method for Localization
% Author: Katarina Vuckovic
% Date: 3/29/2024
% Description:
%   This script implements a non-parametric correlation method for
%   localization using fingerprinting techniques. The method involves
%   training a model with a subset of known locations (fingerprints) and
%   then predicting the location of new samples based on their similarity
%   to the training set.
% Inputs:
%   - ADP_BS1_Nt16_Nc16_BW100MHz_rev1.mat: A MAT file containing the
%     fingerprint data and corresponding locations.
% Outputs:
%   - RMSE_1: Root Mean Square Error (RMSE) for each combination of seed
%     and percentage of training data.
%   - e: The Euclidean distance error for each test sample.
% Key Variables:
%   - ADP: The fingerprint data, reshaped into a 3D array.
%   - L: The corresponding locations for each fingerprint.
%   - percent_all: An array of percentages for splitting the data into
%     training and testing sets.
%   - Ai: The fingerprints used for training.
%   - A_new: A new fingerprint used for testing.
%   - L_pred: The predicted locations for the test fingerprints.
%

clear all;
close all;
clc;

% Load data
%load('ADP_BS1_Nt8_Nc8_BW100MHz_yaxis.mat') 
load('ADP_BS1_Nt16_Nc16_BW100MHz_rev1.mat');

% Reshape ADP
ADP = reshape(ADP, 16, 16, length(ADP)); # reshape based on the size of the input
total = length(ADP);

% Define percentages for training and testing
percent_all = [10, 5, 1, 0.5, 0.25, 0.1];
L = L(1:2, :);

% Iterate over different seeds and percentages
for seed = 1:50
    seed
    for p = 1:length(p) % Use a subset of percentages for this example
        p
        rng(seed, 'twister');
        perm = randperm(total);
        percent_test = 10/100;
        percent_train = percent_all(p)/100;
        index_train = perm(1:round(total * percent_train))';
        index_test = perm(round(total * percent_test):end)';

        % Split data into training and testing sets
        ADP_train = ADP(:, :, index_train);
        ADP_test = ADP(:, :, index_test);
        L_train = L(:, index_train);
        L_test = L(:, index_test);

        % Compute positions for each test sample
        tic;
        Ai = ADP_train;
        for i = 1:length(L_test)
            A_new = ADP_test(:, :, i);
            best_xi = compute_position(Ai, A_new, L_train);
            L_pred(:, i) = best_xi';
        end
        toc;

        % Calculate error metrics
        e_it = sqrt(sum((L_pred' - L_test').^2, 2));
        e(:, seed, p) = e_it;
        MSE = immse(L_test', L_pred');
        RMSE_1(seed, p) = sqrt(MSE);
    end
    toc;
end
mean_RMSE = mean(RMSE_1)
% Save results
save('Corr_based_RMSE_50fold_BS1_Nt16_Nc16_encoded.mat', 'RMSE_1', 'e');
