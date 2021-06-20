% Date & Time: 2020/05/19 16:01
% Project: Reconstruction of 3D Needle-punched C/C Composites
% Step: Simplify CT slices/Feature Detection
% Aim of this program: Simplify a CT slice by a Feature Detection method
% Improvement: 1."Imread" from jpg pics and "fprintf"  into txt files automatically.
%              2. Store feature points in the format of txt, jpg, mat, etc
%              3. Adding post-feature points equidistantly on long straight(actually a vertical line) edges 

clf;
clear;
tic;
% Get the names of input pics
input_folder=fullfile('F:\CR\pics\interpolation_output all 5.19 ip2\');
dirOutput=dir(fullfile(input_folder,'*.jpg'));
in_fileNames={dirOutput.name}';
in_fileNames=char(in_fileNames);
input_fullNames= char(input_folder + string(in_fileNames));   % char to string, then string to char 
pic_numbers=size(input_fullNames,1);

%Create the outputfolder
output_folder=fullfile('F:\CR\matlab\triangulation\feature_points_txt\');
output_folder_pic=fullfile('F:\CR\matlab\triangulation\feature_points_pic\');
output_folder_mat=fullfile('F:\CR\matlab\triangulation\feature_points_mat\');

if exist(output_folder,'dir')==0
	mkdir(output_folder);         % Create an output_folder if it isn't exist 
else
    rmdir(output_folder, 's');    %Remove the output_folder if it is exist already
    mkdir(output_folder);         % Create a new one  
end

if exist(output_folder_pic,'dir')==0
	mkdir(output_folder_pic);         % Make an output_folder if it isn't exist 
else
    rmdir(output_folder_pic, 's');    %Remove the output_folder if it is exist already
    mkdir(output_folder_pic);         % Create a new one  
end

if exist(output_folder_mat,'dir')==0
	mkdir(output_folder_mat);         % Make an output_folder if it isn't exist 
else
    rmdir(output_folder_mat, 's');    %Remove the output_folder if it is exist already
    mkdir(output_folder_mat);         % Create a new one  
end

for pic_index = 1:pic_numbers
    % I1=imread('F:\CR\pics\interpolation_output 00890_00895 4.1 ip2\00890_2_ip.jpg');
    
    I1=imread(input_fullNames(pic_index,:));
    [x_range, y_range]=size(I1);
    
    % Feature/Corner detection
    corners1 =  detectMinEigenFeatures(I1,'MinQuality',0.01,'FilterSize',5);  
    locs1 = corners1.Location;    % locs1 is a matrix stands for feature_points_number*[y_value x_value]
    locs1=ceil(locs1);

    % Add post-feature points equidistantly on long straight(actually a horizontal line) edges
    for x = 1:x_range
        count=0;
        for y = 1:y_range
            if I1(x,y)>=30
                count=count+1;  
            else
                count=0;
            end 

            if count >= 12  % the distance between 2 post-feature points is 10
                locs1=[locs1; y x]; % Add post-feature points into the list
                count=0;
            end
        end
    end
    
    % Add post-feature points equidistantly on long straight(actually a vertical line) edges
    for y = 1:y_range
        count=0;
        for x = 1:x_range
            if I1(x,y)>=30
                count=count+1;  
            else
                count=0;
            end 

            if count >= 10  % the distance between 2 post-feature points is 10
                locs1=[locs1; y x]; % Add post-feature points into the list
                count=0;
            end
        end
    end

    locs1=sortrows(locs1,2);  % Sort rows of the "locs1" matrix by the 2nd column
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
    for cor = 1:rows
        img_output(locs1(cor,2),locs1(cor,1))=255;
    end
    % locs1(:,1) is coordinate value of y-axis and in the range of 0-1050,while
    % locs1(:,2) is coordinate value of x-axis and in the range of 0 to 373
    
    jpgName= char(string(output_folder_pic) + in_fileNames(pic_index,1:end-6)+"fd"+".jpg");
    imwrite(img_output, jpgName);
    
%     imshow()
%     figure(pic_index);
%     imshow(img_output);
%     axis equal;
    
    
    % Save figures in .fig,.mat format
%     picName= char(string(output_folder_pic) + in_fileNames(pic_index,1:end-6)+"fd"+".fig");
%     saveas(pic_index,picName);    
    
    matName= char(string(output_folder_mat) + in_fileNames(pic_index,1:end-6)+"fd"+".mat");
    save(matName,'locs1')
    
end  % the end of "for name_index = 1:pic_numbers"
toc;



