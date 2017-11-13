%%% Inputs:  The differences in the North (A1) and West (A2) directions
%%% Outputs: The gradient threshold parameters for the North and West differences

% The steps of the knee algorithm are described in "M. Petrou and C. Petrou,
% Image Processing: The Fundamentals, John Wiley 2010".

function [kappaN, kappaW] = kneethreshold(AN, AW)

bins = 20; % number of histogram bins used for the knee algorithm


[m, n] = size(AN);


for i = 1:2
 
 
    if i == 1 % Find the histogram of the North differences
        absdeltai = AN;
        Bvecti = reshape(absdeltai, m * n, 1);
        [countsi, xi] = hist(Bvecti, bins);
    elseif i == 2 % Find the histogram of the West differences
        absdeltai = AW;
        Bvecti = reshape(absdeltai, m * n, 1);
        [countsi, xi] = hist(Bvecti, bins);
    end
 
 
    %%% Apply the knee algorithm
 
    % Fit first three bins with a straight line using least squares
    [zzz, xpeak] = max(countsi);
    posleft = find(xi >= xi(xpeak) & xi <= xi(xpeak + 3));
    leftx = xi(posleft);
    lefty = countsi(posleft);
    [pleft, Sleft] = polyfit(leftx, lefty, 1);
 
    % Fit last three bins with a straight line using least squares
    posright = find(xi <= xi(end) & xi >= xi(end - 3));
    rightx = xi(posright);
    righty = countsi(posright);
    [pright, Sright] = polyfit(rightx, righty, 1);
 
    % Find the intersection point of the two lines
    t1 = (pright(2) - pleft(2)) / (pleft(1) - pright(1));
 
 
    %Consider all bins between the peak and x<t1 and fit them with a straight line
 
    posnewleft = find(xi <= t1 & xi >= xi(xpeak));
    newlefty = countsi(posnewleft);
    newleftx = xi(posnewleft);
    leftdev = std(newlefty);
    [pnewleft, Snewleft] = polyfit(newleftx, newlefty, 1);
 
 
    % Omit the points with error larger than a tolerance and refit the rest with
    % a least square error line
    fitleft = polyval(pnewleft, newleftx, Snewleft);
    residleft = fitleft - newlefty; % Fitting residuals
    residleft = abs(residleft);
 
 
 
    outleft = find(residleft > leftdev);
    if size(outleft, 2) > 0
        posnewleft(outleft) = [];
        newlefty = countsi(posnewleft);
        newleftx = xi(posnewleft);
        [pnewleft, Snewleft] = polyfit(newleftx, newlefty, 1);
     
    end
 
    % Do the same for bins with x>t1
 
    posnewright = find(xi > t1);
 
    newrighty = countsi(posnewright);
 
    newrightx = xi(posnewright);
    rightdev = std(newrighty);
    [pnewright, Snewright] = polyfit(newrightx, newrighty, 1);
 
 
    fitright = polyval(pnewright, newrightx, Snewright);
    residright = fitright - newrighty; % Fitting residuals
    residright = abs(residright);
 
 
    outright = find(residright > rightdev);
    if size(outright, 2) > 0
     
        posnewright(outright) = [];
        newrighty = countsi(posnewright);
        newrightx = xi(posnewright);
        [pnewright, Snewright] = polyfit(newrightx, newrighty, 1);
     
    end
 
 
    % Find the intersection point of the two lines. Consider this point as the threshold
    % between the two populations (gradient threshold parameter).
    t2 = (pnewright(2) - pnewleft(2)) / (pnewleft(1) - pnewright(1));
 
 
    if i == 1
        kappaN = t2;
    else
        kappaW = t2;
    end
 
end
