% Date & Time: 2020/05/30 09:02
% Project: Reconstruction of 3D Needle-punched C/C Composites
% Step: Triangulation 
% Aim of this program: Triangulation
% Improvement: Reduce the search range to avoid long-distance mismatch (refer to error2,Problem6)
clf;
clear;
tic;

% Get the names of input mat files
input_folder=fullfile('F:\CR\matlab\triangulation\feature_points_mat\');
dirOutput=dir(fullfile(input_folder,'*.mat'));
in_fileNames={dirOutput.name}';
in_fileNames=char(in_fileNames);
input_fullNames= char(input_folder + string(in_fileNames));   % char to string, then string to char 
file_numbers=size(input_fullNames,1);

%Create the outputfolder
output_folder=fullfile('F:\CR\matlab\triangulation\triangles_and_points\');
if exist(output_folder,'dir')==0
	mkdir(output_folder);         % Create an output_folder if it isn't exist 
else
    rmdir(output_folder, 's');    %Remove the output_folder if it is exist already
    mkdir(output_folder);         % Create a new one  
end

S=[];   % S is a 3 dimensions array. Each element represents a point's Serial number which is indexed by (x,y,z) coordinate value.
P=[];   % Each row of Matrix P stands for the values of x,y,z axis, while the Serial number of a point is the corresponding row number in P. 
T =[];  % Triangulation connectivity array. Each row of T represents the points of a triangle  
slices_dist=10;         % the distance between two adjacent slices
points_num=0;             % Count the total number of feature points on all pictures
% img0=imread(input_fullNames(1,:));
% [x_range, y_range]=size(img0);
% locations0= find(img0>=128);  % Get the locations of feature points on img0 
% [row0,col0]=ind2sub([x_range, y_range],locations0);  %Convert linear indices to subscripts
load(input_fullNames(1,:));  % load feature points named locs1
locs0=locs1;

for i = points_num+1:points_num + size(locs0,1)   % Traverse in the order of Serial number
        x0 = locs0(i-points_num,2);
        y0 = locs0(i-points_num,1);
        z0 = 1*slices_dist;               % The z coordinate value of the first layer is 1*slices_dist  
        S(x0,y0,z0)=i;
        P(i,1)=x0;
        P(i,2)=y0;
        P(i,3)=z0;
end
points_num=points_num + size(locs0,1);   


for pic_index = 1:file_numbers-1 
    
    %批量读取各层feature points数据 
    load(input_fullNames(pic_index+1,:));     % load feature points named locs1
%     locs1=locs1;
%     locations1= find(img1>=128);  % Get the locations of feature points on img1 
%     [row1,col1]=ind2sub([x_range, y_range],locations1);  %Convert linear indices to subscripts    
    
    for i = points_num+1:points_num + size(locs1,1)    % Traverse in the order of Serial number
        x1 = locs1(i-points_num,2);
        y1 = locs1(i-points_num,1);
        z1 = (pic_index+1)*slices_dist;     % The z coordinate value of the first layer is 1*slices_dist 
        S(x1,y1,z1)=i;
        P(i,1)=x1;
        P(i,2)=y1;
        P(i,3)=z1; 
    end
    points_num=points_num +size(locs1,1); 
    
    % match
    for i = 1:size(locs0,1)   % Traverse in the order of column
        x0 = locs0(i,2);
        y0 = locs0(i,1);
        [point2,point3]=match3(x0,y0,(pic_index+1)*slices_dist,S); % 相邻两层两两 match3()匹配  range(0,12) 
        
        if point2~=0 && point3~=0    %
            point=S(x0,y0,pic_index*slices_dist);   
            T=[T;[point point2 point3]];   
        end
    end
    
    % reverse match    
    for i = 1:size(locs1,1)   % Traverse in the order of column
        x0 = locs1(i,2);
        y0 = locs1(i,1);
        [point2,point3]=match3(x0,y0,pic_index*slices_dist,S); % 相邻两层两两 match3()匹配  range(0,12) M返回两个匹配点的x,y坐标
        
        if point2~=0 && point3~=0    
            point=S(x0,y0,(pic_index+1)*slices_dist);
            T=[T;[point point2 point3]];
        end
       
    end
    
    locs0=locs1;
%     img0=img1;
%     row0=row1;
%     col0=col1;
%     locations0=locations1;
    
end


% 删除重复点对
T=sort(T,2,'ascend'); %Sort the elements of each row in ascending order 
T=unique(T,'rows','stable'); % Delete identical rows and keep the origanl order('stable').


% Triangulation and Store triangulation data
TR = triangulation(T,P);
matName=char(output_folder + "TR.mat");
save(matName,'TR')
matName=char(output_folder + "S.mat");
save(matName,'S')
matName=char(output_folder + "P.mat");
save(matName,'P')
matName=char(output_folder + "T.mat");
save(matName,'T')

% stlwrite(TR,char(output_folder+"3d_needle_punched_test.stl"));     % writes the triangulation TR to a binary(default) STL file filename
% stlwrite(TR,char(output_folder+"3d_needle_punched_test_in_text.stl"),'text');  %writes the triangulation TR to a text STL file filename

trisurf(TR);   
% trimesh(TR)
axis equal;
toc;

