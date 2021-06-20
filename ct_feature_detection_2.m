% Date & Time: 2020/05/18 22:30
% Project: Reconstruction of 3D Needle-punched C/C Composites
% Step: Simplifying CT slices/Feature Detection
% Aim of this program: Simplifying a CT slice by a Feature Detection method
% Improvement: Adding post-feature points equidistantly on long straight(actually a horizontal line) edges

clf;
clear;
I1=imread('F:\CR\pics\interpolation_output 00890_00895 4.1 ip2\00890_2_ip.jpg');
[x_range, y_range]=size(I1);
% I1=rgb2gray(I1);

% Feature/Corner detection
corners1 =  detectMinEigenFeatures(I1,'MinQuality',0.01,'FilterSize',9);  
locs1 = corners1.Location;    % locs1 is a matrix stands for feature_points_number*[y_value x_value]
locs1=ceil(locs1);

% Adding post-feature points equidistantly on long straight(actually a vertical line) edges
for x = 1:x_range
    count=0;
    for y = 1:y_range
        if I1(x,y)>=30
            count=count+1;  
        else
            count=0;
        end 
        
        if count >= 12  % the distance between 2 post-feature points is 12
            locs1=[locs1; y x]; % Add post-feature points into the list
            count=0;
        end
    end
end

locs1=sortrows(locs1,1);  % Sort rows of the "locs1" matrix by the 1st column
locs1=unique(locs1,'rows','stable'); % Delete identical rows and keep the origanl order('stable').
[rows,cols]=size(locs1);
% Store feature points in txt files
filename= 'F:\CR\matlab\triangulation\feature_points\00890_2_ip.txt';
file=fopen(filename,'wt');
for i=1:rows
    for j=1:cols
        fprintf(file,'%g\t',locs1(i,j));
    end
    fprintf(file,'\n');
end
fclose(file);

% Plot
% subplot(2,1,1);
imshow(uint8(255)-I1);
hold on;
plot(locs1(:,1),locs1(:,2),'.b');  
% locs1(:,1) is coordinate value of y-axis and in the range of 0-1050,while
% locs1(:,2) is coordinate value of x-axis and in the range of 0 to 373
axis equal;

% locs2=sortrows(locs1,1);
% subplot(2,1,2);
% imshow(uint8(255)-I1);
% hold on;
% plot(locs2(:,1),locs2(:,2),'.b'); 
% axis equal;


