%%% Input:  The variance of the noise
%%% Output: The smoothing 2D gaussian filter

% The steps for the construction of the 2D gaussian filter are described in
% "M. Petrou and C. Petrou, Image Processing: The Fundamentals, John Wiley 2010".


function gfilter = gaussianfilter(snoise)

ey = 3 * snoise;
M = snoise * sqrt(- 2 * log(ey));


i = 0;
for x = - 2 * M:M:2 * M
    j = 0;
    i = i + 1;
    for y = - 2 * M:M:2 * M
        j = j + 1;
        gfilter(i, j) = exp(- (x ^ 2 + y ^ 2) / (2 * (snoise ^ 2)));
    end
end
gfilter = gfilter / (sum(sum(gfilter)));

end
