% Test Gaussian Process Regression Model for Localization with Encoded ADP data
% Authors: Katarina Vuckovic
% Date: 3/29/2024
% Description: Test the GPR models trained in GPR_train_kfold.m.
% After training the models using GPR_train_kfold.m., this script evalutes the perfrmance of those models. 
% The script uses the GPR models previously trained to predict the location. 
% The it calculates the mean Root Mean Square Error (RMSE) over all the folds for each of the training dataset sizes. 
%
% References:
% - https://www.mathworks.com/help/stats/fitrgp.html
%
% -----------------------------------------------------------------------------

clear all;
close all;
clc;
tic;

% Load Model
load('ADP_BS1_Nt16_Nc16_BW100MHz_yaxis_encoded_rev1.mat');

% Training input
Nt = 4;
Nc = Nt;
Out = eADP;
n = Nt * Nc;
loc = loc';
x1 = loc(:,1);
x2 = loc(:,2);
T = array2table(Out);
T1 = T;
T1.x1 = x1;
T2 = T;
T2.x2 = x2;

percent_all = [10,5,1,0.5,0.25,0.1];
total = length(Out);
index_all = 1:total;

for i = 1:50
    i
    for p = 1:6
        clear index_test_i index_train;
        rng(i,'twister');
        perm = randperm(total);
        percent_test = 10 / 100;
        index_train = perm(1:round(total * percent_test))';
        index_test_i = perm(round(total * percent_test):(round(total * percent_test) + 1000))';

        Ttest1 = T1(index_test_i,:);
        Ttest2 = T2(index_test_i,:);

        clear gprMd1 gprMd2 ypred1 ypred2;

        filename = strcat('mld_BS1_ADP16_100MHz_encoded4_', num2str(percent_all(p)), 'p_seed', num2str(i)');
        load(filename);

        [ypred1] = predict(gprMd1, table2array(Ttest1(:,1:Nt * Nc)));
        [ypred2] = predict(gprMd2, table2array(Ttest2(:,1:Nt * Nc)));

        test1 = table2array(Ttest1(:,Nt * Nc + 1));
        test2 = table2array(Ttest2(:,Nt * Nc + 1));
        test = [test1, test2];
        ypred = [ypred1, ypred2];
        test = double(test);
        e_it = sqrt(sum((ypred - test).^2, 2));
        e(:,i,p) = e_it;
        MSE = immse(test, ypred);
        RMSE(i,p) = sqrt(MSE);
    end
end

% save('GPR_ADP64x64_O1_results.mat', 'RMSE', 'e');
toc;
