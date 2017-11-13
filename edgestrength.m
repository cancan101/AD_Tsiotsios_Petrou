%%% Inputs: Image A and a matrix with the coordinates of the edgels
%%% Output: The brightness values of the interpixels around each edgel

function gedgesr = edgestrength(A, edges)
numedgels = size(edges, 1);
edn = 2;


Soby = [-1 -2 -1; 0 0 0; 1 2 1]; % Sobel operator
Sobx = Soby';
Bx = filter2(Sobx, A);
By = filter2(Soby, A);


% Calculate the direction of the edge
for i = 1:numedgels
    By1 = By(edges(i, 1), edges(i, 2));
    Bx1 = Bx(edges(i, 1), edges(i, 2));
    theta1 = atan(By1 / Bx1);
    theta1 = - 1 * theta1;
    theta(i) = theta1;
end


% Find the coordinates of the interpixels around each edgel
for i = 1:numedgels
 
    edges1(i, :) = [edges(i, 1) + cos(theta(i)) edges(i, 2) + sin(theta(i))];
    edges2(i, :) = [edges(i, 1) - cos(theta(i)) edges(i, 2) - sin(theta(i))];
 
    jnum = 0;
    for j = - edn:edn
     
     
        if j ~= 0
            jnum = jnum + 1;
            edgesni(i, jnum) = edges(i, 1) - j * sin(theta(i));
            edgesnj(i, jnum) = edges(i, 2) + j * cos(theta(i));
         
         
            edgesni1(i, jnum) = edges1(i, 1) - j * sin(theta(i));
            edgesnj1(i, jnum) = edges1(i, 2) + j * cos(theta(i));
         
         
            edgesni2(i, jnum) = edges2(i, 1) - j * sin(theta(i));
            edgesnj2(i, jnum) = edges2(i, 2) + j * cos(theta(i));
        end
    end
 
 
 
    % Calculate the brightness of the interpixels using bilinear interpolation
 
 
    for j = 1:2 * edn
        tempi = fix(edgesni(i, j));
        tempj = fix(edgesnj(i, j));
        i0 = edgesni(i, j) - tempi;
        j0 = edgesnj(i, j) - tempj;
        din = A(tempi, tempj);
        ain = A(tempi, tempj + 1) - A(tempi, tempj);
        bin = A(tempi + 1, tempj) - A(tempi, tempj);
        cin = A(tempi, tempj) - A(tempi, tempj + 1) - A(tempi + 1, tempj) + A(tempi + 1, tempj + 1);
        gedges(j) = ain * j0 + bin * i0 + cin * i0 * j0 + din;
     
    end
 
 
    for j = 1:2 * edn
        tempi = fix(edgesni1(i, j));
        tempj = fix(edgesnj1(i, j));
        i0 = edgesni1(i, j) - tempi;
        j0 = edgesnj1(i, j) - tempj;
        din = A(tempi, tempj);
        ain = A(tempi, tempj + 1) - A(tempi, tempj);
        bin = A(tempi + 1, tempj) - A(tempi, tempj);
        cin = A(tempi, tempj) - A(tempi, tempj + 1) - A(tempi + 1, tempj) + A(tempi + 1, tempj + 1);
        gedges1(j) = ain * j0 + bin * i0 + cin * i0 * j0 + din;
     
    end
 
 
    for j = 1:2 * edn
        tempi = fix(edgesni2(i, j));
        tempj = fix(edgesnj2(i, j));
        i0 = edgesni2(i, j) - tempi;
        j0 = edgesnj2(i, j) - tempj;
        din = A(tempi, tempj);
        ain = A(tempi, tempj + 1) - A(tempi, tempj);
        bin = A(tempi + 1, tempj) - A(tempi, tempj);
        cin = A(tempi, tempj) - A(tempi, tempj + 1) - A(tempi + 1, tempj) + A(tempi + 1, tempj + 1);
        gedges2(j) = ain * j0 + bin * i0 + cin * i0 * j0 + din;
     
    end
 
    % Assign the brightness values of the interpixels around each edgel i to
    % a cell "gedgesr".
    gedgesr{i} = [gedges; gedges1; gedges2];
 
end


end