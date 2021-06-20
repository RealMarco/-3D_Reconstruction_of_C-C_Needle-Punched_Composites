% Date & Time: 2020/05/20 08:00
% Project: Reconstruction of 3D Needle-punched C/C Composites
% Step: Triangulation 
% Details: Triangulation with images in “.jpg”format.
% Error:1.x2=x3 and y2=y3 extensively because of a wrong algorithm in  function called match1()  
% 2. The range of search in function match1() is out of range on the upper and lower boundaries of the input images 
clf;
clear;

% Get the names of input mat files
input_folder=fullfile('F:\CR\matlab\triangulation\feature_points_pic_test\');
dirOutput=dir(fullfile(input_folder,'*.jpg'));
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
img0=imread(input_fullNames(1,:));
[x_range, y_range]=size(img0);
locations0= find(img0>=128);  % Get the locations of feature points on img0 
[row0,col0]=ind2sub([x_range, y_range],locations0);  %Convert linear indices to subscripts

for i = points_num+1:points_num + length(locations0)    % Traverse in the order of Serial number
        x0 = row0(i-points_num);
        y0 = col0(i-points_num);
        z0 = 1*slices_dist;
        S(x0,y0,z0)=i;
        P(i,1)=x0;
        P(i,2)=y0;
        P(i,3)=z0;
end
points_num=points_num + length(locations0);   


for pic_index = 1:file_numbers-1 
    
    %批量读取各层feature points数据 
    img1=imread(input_fullNames(pic_index+1,:));
    locations1= find(img1>=128);  % Get the locations of feature points on img1 
    [row1,col1]=ind2sub([x_range, y_range],locations1);  %Convert linear indices to subscripts
     
    
    for i = points_num+1:points_num + length(locations1)    % Traverse in the order of Serial number
        x1 = row1(i-points_num);
        y1 = col1(i-points_num);
        z1 = (pic_index+1)*slices_dist;
        S(x1,y1,z1)=i;
        P(i,1)=x1;
        P(i,2)=y1;
        P(i,3)=z1; 
    end
    points_num=points_num +length(locations1); 
    
    for i = 1:length(locations0)   % Traverse in the order of column
        x0 = row0(i);
        y0 = col0(i);
        [x2,y2,x3,y3]=match1(x0,y0,img1); % 相邻两层两两 match1()匹配  range(0,12) 
        point=S(x0,y0,pic_index*slices_dist);
        point1 = S(x2,y2,(pic_index+1)*slices_dist);
        point2 = S(x3,y3,(pic_index+1)*slices_dist);
        T=[T;[point point1 point2]];
       
    end
    
    % reverse match1（）    
    for i = 1:length(locations1)   % Traverse in the order of column
        x0 = row1(i);
        y0 = col1(i);
        [x2,y2,x3,y3]=match1(x0,y0,img0); % 相邻两层两两 match1()匹配  range(0,12) M返回两个匹配点的x,y坐标
        point=S(x0,y0,(pic_index+1)*slices_dist);
        point1 = S(x2,y2,pic_index*slices_dist);
        point2 = S(x3,y3,pic_index*slices_dist);
        T=[T;[point point1 point2]];
       
    end
    
    img0=img1;
    row0=row1;
    col0=col1;
    locations0=locations1;
    
end


% 删除重复点对
T=sort(T,2,'ascend'); %Sort the elements of each row in ascending order 
T=unique(T,'rows','stable'); % Delete identical rows and keep the origanl order('stable').


% Triangulation
TR = triangulation(T,P);
trisurf(TR);   
% trimesh(TR)
axis equal;
