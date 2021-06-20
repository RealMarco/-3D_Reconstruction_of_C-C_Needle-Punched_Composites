% Testing 3D Delaunay Triangulation with given data. 
% X = rand(10,3);                % % using random points
X =[

    0.6557    0.7060    0.4387
    0.0357    0.0318    0.3816
    0.8491    0.2769    0.7655
    0.9340    0.0462    0.7952
    0.6787    0.0971    0.1869
    0.7577    0.8235    0.4898
    0.7431    0.6948    0.4456
    0.3922    0.3171    0.6463
    0.6555    0.9502    0.7094
    0.1712    0.0344    0.7547];   % using certain points
dt = delaunayTriangulation(X);
subplot(1,3,1);
% axis([0 1 0 1 0 1])
tetramesh(dt, 'FaceColor', 'cyan');

%
[F,P] = freeBoundary(dt);
subplot(1,3,2);
trisurf(F,P(:,1),P(:,2),P(:,3),'FaceColor','cyan','FaceAlpha',0.8);

% To display large tetrahedral meshes use the convexHull method to
% compute the boundary triangulation and plot it using trisurf.
% For example;
triboundary = convexHull(dt);
subplot(1,3,3);
trisurf(triboundary, X(:,1), X(:,2), X(:,3), 'FaceColor', 'cyan');