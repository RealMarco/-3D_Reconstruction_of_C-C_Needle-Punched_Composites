% Date & Time: 2020/05/01 
% Project: Reconstruction of 3D Needle-punched C/C Composites
% Step: Simplifying CT slices/Feature Detection
% Aim of this program: Simplifying a CT slice by diverse Feature Detection methods and Choosing optimal methods from them. 
% Result: "detectHarrisFeatures" and "detectMinEigenFeatures" were Chosen.

clf;
clear;
I1=imread('F:\CR\pics\interpolation_output 00890_00895 4.1 ip2\00890_2_ip.jpg');
% I1=rgb2gray(I1);
corners1 =  detectHarrisFeatures(I1,'MinQuality',0.01,'FilterSize',9);  
locs1 = corners1.Location;
locs1=ceil(locs1);
subplot(2,1,1);
imshow(uint8(255)-I1);
hold on;
plot(locs1(:,1),locs1(:,2),'.b');
axis equal;

corners2 = detectMinEigenFeatures(I1,'MinQuality',0.01,'FilterSize',9); %developed by Shi and Tomasi
locs2 = corners2.Location;
locs2=round(locs2);
subplot(2,1,2);
imshow(uint8(255)-I1);
hold on;
plot(locs2(:,1),locs2(:,2),'.b');
axis equal;

% corners3 = detectFASTFeatures(I1,'MinQuality',0.01,'MinContrast',0.5); %developed by Shi and Tomasi
% locs2 = corners2.Location;
% locs2=round(locs2);
% subplot(3,1,3);
% plot(locs2(:,1),locs2(:,2),'.b');
% axis equal;

% detectFASTFeatures
% detectHarrisFeatures
% detectMinEigenFeatures(I1,'MinQuality',0.005,'FilterSize',3)  %developed by Shi and Tomasi
% detectBRISKFeatures
% detectMSERFeatures
% detectORBFeatures
% detectSURFFeatures
% extractFeatures
% extractHOGFeatures
% matchFeatures

