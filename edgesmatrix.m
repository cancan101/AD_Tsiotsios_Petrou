%%% Inputs: Image A and the number of edgels 
%%% Output: Matrix edgm containing the coordinates of the edgels

function edgm=edgesmatrix(A,numedgels)

[m, n] = size(A);
dislimit=(1/35)*min(m,n); % The minimum distance between each edgel

Soby = [-1 -2 -1 ; 0 0 0 ; 1 2 1]; % Sobel operator
Sobx=Soby';


Bx = filter2(Sobx,A);
By = filter2(Soby,A);
B = sqrt(Bx.^2 + By.^2);

B(1:3,:)=0; % Exclude the borders
B(:,1:3)=0;
B(:,end-2:end)=0;
B(end-2:end,:)=0;

maxB=reshape(B,m*n,1); % Reshape the magnitudes into a descending order
maxB=sort(maxB,'descend');


edgm=[Inf,Inf];
checkdis=Inf;

j=0;


% Choose the edgels with the highest magnitudes, that have a min distance > dislimit between each other
 
for i=1:numedgels
    nextedge=true;
    
    while nextedge==true
    nextedge=false;
    j=j+1;
    tempmax=maxB(j);   
[a,b]=find(B==tempmax);
a=a(1);
b=b(1);

for k=1:size(edgm,1)
checkdis=norm([a,b]-[edgm(k,1),edgm(k,2)]); % Check the distance between each edgel and all other selected edgels
if checkdis<dislimit
    nextedge=true;
end
end
    end
 edgm(i,1)=a;
 edgm(i,2)=b;
      
end


% % Plot the edgels
% figure
% imshow(A)
% hold on
% for i=1:numedgels
% plot(edgm(i,2),edgm(i,1),'x','Markersize',10,'Markeredgecolor','r','LineWidth',1.5);
% hold on
% end

end