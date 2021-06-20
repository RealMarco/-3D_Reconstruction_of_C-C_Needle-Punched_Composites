% Triangulating a CT slice through 2D Delaunay Triangulation algorithm.
% Useless for the project 
clf;
ct=imread('F:\CR\pics\interpolation_output 00890_00895 4.1 ip2\00890_1_ip.jpg');
subplot(2,1,1);
imshow(ct);
axis equal ;
% colormap(gray);

%%Getting the coordinates
ct_double=double(ct);
F = find(ct_double>=30);
y=373-mod(F,373);
x=ceil(F/373);
coordinates=[x y];

%%convex hull
% hold on;
% CH=convhull(x,y);
% plot(x(CH),y(CH),'-r');
% hold off

%%delaunayTriangulation
ct_dt = delaunayTriangulation(coordinates);
subplot(2,1,2);
triplot(ct_dt);
hold on
FB = freeBoundary(ct_dt);          % freeBoundary
% FB=convexHull(ct_dt);
plot(x(FB),y(FB),'-r','LineWidth',1);
axis equal;
hold off