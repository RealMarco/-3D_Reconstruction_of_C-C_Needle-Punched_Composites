% Test 3D Normal triangulation algorithm by using given data. 
clf;
P1=[ 0 0 0     % Each row of Matrix P stands for the values of x,y,z axis 
    0 2 0     % The ID of a point is the corresponding row number in P.
    2 2 0
    2 0 0
    0 0 2
    0 2 2
    2 2 2 
    2 0 2];    
               
               
T1=[ 1 4 8      % Each row of Matrix T represents the points of a triangle 
    2 5 7];    % The ID of a triangle is the corresponding row number in T.
TR1 = triangulation(T1,P1);
trisurf(TR1);   
% trimesh(TR1)
axis equal;
