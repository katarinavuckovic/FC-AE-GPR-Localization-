% Data Augmentation for AE Training
% This notebook is dedicated to augmenting the ADP dataset for use in training an Autoencoder (AE).
% Author: Katarina Vuckovic, UCF
% Date: 9/20/2023
clear all
close all
clc


% Load dataset for 16x16
load('ADP_BS1_Nt16_Nc16_BW100MHz_yaxis.mat')
ADPr = reshape(ADP,16,16,72400);
len = length(ADPr);
perm = randperm(len); 
percent = 0.005;

ADP_train = ADPr(:,:,perm(1:round(len*percent)));
ADP_test = ADPr(:,:,perm(round(len*percent):end));

% Augment data with shifts
ii = 1;
for i = 1:length(ADP_train)
    for x = 0:2:16
        for y = 0:2:16
            ADPshift(:,:,ii) = circshift(ADP_train(:,:,i),[x,y]);
            ii = ii + 1;
        end
    end
end

% Augment data with rotations and flips
ii = 1;
for i = 1:length(ADP_train)
    ADP_rotate90 = imrotate(ADP_train(:,:,i),90);
    ADP_rotaten90 = imrotate(ADP_train(:,:,i),-90);
    ADP_rotate180 = imrotate(ADP_train(:,:,i),180);
    ADP_flipud = flipud(ADP_train(:,:,i));
    ADP_fliplr = fliplr(ADP_train(:,:,i));
    for x = 0:2:16
        for y = 0:2:16
            ADProtate90(:,:,ii) = circshift(ADP_rotate90,[x,y]);
            ADProtaten90(:,:,ii) = circshift(ADP_rotaten90,[x,y]);
            ADProtate180(:,:,ii) = circshift(ADP_rotate180,[x,y]);
            ADPFlipud(:,:,ii) = circshift(ADP_flipud,[x,y]);
            ADPFliplr(:,:,ii) = circshift(ADP_fliplr,[x,y]);
            ii = ii + 1;
        end
    end
end

augADP = cat(3, ADPshift, ADProtate90, ADProtaten90, ADProtate180, ADPFlipud, ADPFliplr);

save('augmentedADP_BS1_Nt16_Nc16_BW100MHz_yaxis_0p5_v2.mat', 'augADP');
save('ADP_BS1_Nt16_Nc16_BW100MHz_yaxis_0p5_test.mat', 'ADP_test');
%---------------------------------------------------------------------------
% 
clear all
close all
clc
% Load dataset for 32x32
load('ADP_BS1_Nt32_Nc32_BW100MHz_O1_3p5.mat','ADP','L')
ADPr = reshape(ADP, 64, 64, 72400);
len = length(ADPr);
perm = randperm(len);
percent = 0.005;

ADP_train = ADPr(:,:,perm(1:round(len*percent)));
ADP_test =  ADPr(:,:,perm(round(len*percent):end));
L_train = L(:,:,perm(1:round(len*percent)));
L_test =  L(:,:,perm(round(len*percent):end));

% end
ii=1
for i=1:length(ADP_train)
for x= 0:4:32
    for y = 0:4:32
        ADPshift(:,:,ii) = circshift(ADP_train(:,:,i),[x,y]);
        ii=ii+1;
    end 
end
end

%rotate+translate
ii = 1

for i=1:length(ADP_train)
    ADP_rotate90 = imrotate(ADP_train(:,:,i),90);
    ADP_rotaten90 = imrotate(ADP_train(:,:,i),-90);
    ADP_rotate180 = imrotate(ADP_train(:,:,i),180);
    ADP_flipud  = flipud(ADP_train(:,:,i));
    ADP_fliplr  = fliplr(ADP_train(:,:,i));
    for x= 0:4:32
        for y = 0:4:32
            ADProtate90(:,:,ii) = circshift(ADP_rotate90,[x,y]);
            ADProtaten90(:,:,ii) = circshift(ADP_rotaten90,[x,y]);
            ADProtate180(:,:,ii) = circshift(ADP_rotate180,[x,y]);
            ADPFlipud(:,:,ii) = circshift(ADP_flipud,[x,y]);
            ADPFliplr(:,:,ii) = circshift(ADP_fliplr,[x,y]);
            ii=ii+1;
        end 
    end
end

augADP = cat(3,ADPshift,ADProtate90,ADProtaten90,ADProtate180, ADPFlipud, ADPFliplr);



save('augmentedADP_BS1_Nt32_Nc32_BW100MHz_O1_0p5.mat', 'augADP','L_train','-v7.3');
save('augmentedADP_BS1_Nt32_Nc32_BW100MHz_01_0p5_test.mat', 'ADP_test','L_test','-v7.3');
%-------------------------------------------------------------------------

clear all
close all
clc
%-------------------
% Load dataset for 32x32
load('ADP_BS1_Nt64_Nc64_BW100MHz_O1_3p5.mat','ADP','L')

ADPr = reshape(ADP,64,64,72400);
i = 0
len = length(ADPr);
perm = randperm(len); 
percent = 0.005

ADP_train = ADPr(:,:,perm(1:round(len*percent)));

ADP_test =  ADPr(:,:,perm(round(len*percent):end));
L_train = L(:,:,perm(1:round(len*percent)));
L_test =  L(:,:,perm(round(len*percent):end));

ii = 1
for i=1:length(ADP_train)
for x= 0:4:64
    for y = 0:4:64
        ADPshift(:,:,ii) = circshift(ADP_train(:,:,i),[x,y]);
        ii=ii+1;
    end 
end
end

%rotate+translate
ii = 1
for i=1:length(ADP_train)
    ADP_rotate90 = imrotate(ADP_train(:,:,i),90);
    ADP_rotaten90 = imrotate(ADP_train(:,:,i),-90);
    ADP_rotate180 = imrotate(ADP_train(:,:,i),180);
    ADP_flipud  = flipud(ADP_train(:,:,i));
    ADP_fliplr  = fliplr(ADP_train(:,:,i));
    for x= 0:8:64
        for y = 0:8:64
            ADProtate90(:,:,ii) = circshift(ADP_rotate90,[x,y]);
            ADProtaten90(:,:,ii) = circshift(ADP_rotaten90,[x,y]);
            ADProtate180(:,:,ii) = circshift(ADP_rotate180,[x,y]);
            ADPFlipud(:,:,ii) = circshift(ADP_flipud,[x,y]);
            ADPFliplr(:,:,ii) = circshift(ADP_fliplr,[x,y]);
            ii=ii+1;
        end 
    end
end

augADP = cat(3,ADPshift,ADProtate180, ADPFlipud, ADPFliplr);

save('your_file_name.mat', 'augADP', '-v7.3');

save('augmentedADP_BS1_Nt64_Nc64_BW100MHz_O1_3p5_0p5.mat', 'augADP', 'L_train','-v7.3');
save('augmentedADP_BS1_Nt64_Nc64_BW100MHz_O1_3p5_0p5_test.mat', 'ADP_test','L_test','-v7.3');
