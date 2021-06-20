% Date & Time: 2020/05/19 16:01
% Project: Reconstruction of 3D Needle-punched C/C Composites
% Step: Simplify CT slices/Feature Detection
% Aim of this program: Test the order of output points
% Improvement: Points are output by column

clf;
clear;
% Get the names of input pics
input_folder=fullfile('F:\CR\pics\interpolation_output 00890_00895 4.1 ip2\');
dirOutput=dir(fullfile(input_folder,'*.jpg'));
in_fileNames={dirOutput.name}';
in_fileNames=char(in_fileNames);
input_fullNames= char(input_folder + string(in_fileNames));   % char to string, then string to char 
pic_numbers=size(input_fullNames,1);

%Create the outputfolder
output_folder=fullfile('F:\CR\matlab\triangulation\feature_points_txt_output_order\');

if exist(output_folder,'dir')==0
	mkdir(output_folder);         % Create an output_folder if it isn't exist 
else
    rmdir(output_folder, 's');    %Remove the output_folder if it is exist already
    mkdir(output_folder);         % Create a new one  
end

for pic_index = 1:pic_numbers
    % I1=imread('F:\CR\pics\interpolation_output 00890_00895 4.1 ip2\00890_2_ip.jpg');
    
    I1=imread(input_fullNames(pic_index,:));
    [x_range, y_range]=size(I1);
    
    % Feature/Corner detection
    corners1 =  detectMinEigenFeatures(I1,'MinQuality',0.01,'FilterSize',5);  
    locs1 = corners1.Location;    % locs1 is a matrix stands for feature_points_number*[y_value x_value]
    locs1=ceil(locs1);

%     locs1=sortrows(locs1,2);  % Sort rows of the "locs1" matrix by the 2nd column
    locs1=unique(locs1,'rows','stable'); % Delete identical rows and keep the origanl order('stable').
    [rows,cols]=size(locs1);
    s=size(locs1);
    
    % Store feature points in txt files
    filename= string(output_folder) + in_fileNames(pic_index,1:end-6)+"fd"+".txt";
    file=fopen(filename,'wt');
    for i=1:rows
        for j=1:cols
            fprintf(file,'%g\t',locs1(i,j));
        end
        fprintf(file,'\n');
    end
    fclose(file);

    % imshow() and imwrite() feature points
    img_output=zeros(x_range, y_range);              % 373*1050
    for cor = 1:100*pic_index
        img_output(locs1(cor,2),locs1(cor,1))=255;
    end
    % locs1(:,1) is coordinate value of y-axis and in the range of 0-1050,while
    % locs1(:,2) is coordinate value of x-axis and in the range of 0 to 373
    
    figure(pic_index);
    imshow(img_output);
    axis equal;
    
    
    % Save figures in .fig,.mat format
%     picName= char(string(output_folder_pic) + in_fileNames(pic_index,1:end-6)+"fd"+".fig");
%     saveas(pic_index,picName);    
    
  
    
end  % the end of "for name_index = 1:pic_numbers"




