% Testing 2D Delaunay Triangulation 
x = rand(10,1);
y = rand(10,1);
dt = delaunayTriangulation(x,y);
triplot(dt);

%Find and highlight free boundary edges.
hold on
F = freeBoundary(dt);
plot(x(F),y(F),'-r','LineWidth',2)
% axis equal 
% Display the Vertex and Triangle labels on the plot
% hold on
% vxlabels = arrayfun(@(n) {sprintf('P%d', n)}, (1:10)');
% Hpl = text(x, y, vxlabels, 'FontWeight', 'bold', 'HorizontalAlignment',...
%    'center', 'BackgroundColor', 'none');
% ic = incenter(dt);
% numtri = size(dt,1);
% trilabels = arrayfun(@(x) {sprintf('T%d', x)}, (1:numtri)');
% Htl = text(ic(:,1), ic(:,2), trilabels, 'FontWeight', 'bold', ...
%    'HorizontalAlignment', 'center', 'Color', 'blue');
% hold off