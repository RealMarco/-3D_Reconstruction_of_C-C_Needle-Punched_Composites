% Triangulating two adjacent CT slices through 3D Delaunay Triangulation algorithm.
% Failed. 
clf;
I1=imread('F:\CR\pics\interpolation_output 00890_00895 4.1 ip2\00890_1_ip.jpg');
I2=imread('F:\CR\pics\interpolation_output 00890_00895 4.1 ip2\00890_2_ip.jpg');
I3=imread('F:\CR\pics\interpolation_output 00890_00895 4.1 ip2\00890_3_ip.jpg');
% I=imread('F:\CR\pics\Original\00895.tif');
% create output RGB frame
% Y = repmat(I,[1 1 3]);    % repmat-Repeat copies of array
Y1=zeros(size(I1));
Y2=zeros(size(I2));
% corners = detectFASTFeatures(I,'minContrast',4/255,'minQuality',5/255);
% corners = detectHarrisFeatures(I,'MinQuality',0.01,'FilterSize',3);
corners1 = detectMinEigenFeatures(I1,'MinQuality',0.005,'FilterSize',3);  %developed by Shi and Tomasi
corners2 = detectMinEigenFeatures(I2,'MinQuality',0.005,'FilterSize',3); 
% corners = detectFASTFeatures(I);
locs1 = corners1.Location;    %Location of points, specified as an M-by-2 array of [x y] coordinates.
locs2 = corners2.Location;  
% for ii = 1:size(locs1,1)
%     %Y(floor(locs(ii,2)),floor(locs(ii,1)),2) = 255; % green dot
%     Y1(floor(locs1(ii,2)),floor(locs1(ii,1)))=255;
% end
% imshow(Y1)

locs1(:,3)=0;
locs2(:,3)=30;
locs_final=double([locs1;locs2]);
dt=delaunayTriangulation(locs_final);  % tetrahedra
% %plot the feature points.
% plot3(locs_final(:,1),locs_final(:,2),locs_final(:,3),'.');axis equal;

% tetramesh(dt, 'FaceColor', 'cyan');
[F,P] = freeBoundary(dt);
trisurf(F,P(:,1),P(:,2),P(:,3),'FaceColor','cyan','FaceAlpha',0.8);
axis equal;

