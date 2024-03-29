clear all
close all
clc
%Channel Parameters

Nt = 64;
Nc = 64;
BW = 0.100; %GHz
scenario = 'O1_3p5';
Ri = 300
Rf = 700
BS= 1


[Dataset,params]= DeepMIMO_Dataset_Generator(Nt,Nc,BW,BS,Ri,Rf, scenario);
num_BS = 1; 
step = 1;
p =  72400 

for p =1:p
    %location
    L(:,p) = Dataset{1,1}.user{1,p*step}.loc;
    %channel -  for location P
    H1= Dataset{1,1}.user{1,p*step}.channel;
    CSI =  reshape(H1,[Nt Nc]);
    A1(:,:,p) = abs(CSI2ADP_theta(CSI,Nt,Nc));
    ADP(:,p) = reshape(A1(:,:,p),[Nt*Nc 1]);

end
save('ADP_BS1_Nt64_Nc64_BW100MHz_O1_3p5_V2.mat','ADP','L','-v7.3');
