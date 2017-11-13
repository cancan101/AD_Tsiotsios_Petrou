%%% Inputs: The noisy image A, the conductance function option (optional), the standard
%%%         deviation of the noise (optional) and the number of iterations. (optional)
%%%         At least A is required.
%%% Ouputs: The filtered image using AD

function diff_Im = Main_AD(A, ConductFunction, Time, Snoise)

if nargin < 1 || nargin > 4
    error('Wrong number of arguments')
end

if size(A, 3) > 1
    error('Wrong type of image (use monochrome version)')
end

stop_criterion = false;
A = im2double(A);

if nargin == 1
    Snoise = noise_estimate(A);
    stop_criterion = true;
    ConductFunction = 1;
 
else
 
    if isempty(Snoise) == 1
        Snoise = noise_estimate(A);
    end
 
    if isempty(Time) == 1
        stop_criterion = true;
    end
 
    if isempty(ConductFunction) == 1
        ConductFunction = 1;
    end
end


hS = [0 1 0; 0 -1 0; 0 0 0]; % Kernel for computing South differences using convolution
hN = [0 0 0; 0 -1 0; 0 1 0]; % North Differences
hW = [0 0 0; 0 -1 1; 0 0 0]; % West differences
hE = [0 0 0; 1 -1 0; 0 0 0]; % East differences

lambda = 1 / 4; % Fixed lambda variable
numedgels = 200; % Number of edgels to use for the stopping criterion


gfilter = gaussianfilter(Snoise); % Calculate the gaussian filter


diff_Im = A;
diffgaus = conv2(diff_Im, gfilter, 'same'); % Smoothed version of the noisy image

if stop_criterion == true
    edgels = edgesmatrix(diffgaus, numedgels); % Find the positions of the edgels
    tu1 = edgestrength(diff_Im, edgels); % Calculate the interpixel intensities around each edgel
    resedge{1} = tu1;
    ematrix = resedge{1};
    a = aconstant(numedgels, ematrix, Snoise); % Calculate constant a
 
    for i = 1:numedgels
        temp = ematrix{i};
        temp1 = temp(:, 1:2);
        temp2 = temp(:, 3:4);
        Q(i, 1) = abs((mean2(temp1) - mean2(temp2))) - a * (std(temp1(:), 1) + std(temp2(:), 1)); % Q reflects the quality of each edgel
    end
end


j = 0;
stop = false;
while stop == false
    j = j + 1;
 
    diffgaus = conv2(diff_Im, gfilter, 'same'); % Smoothed version of the image
 
    deltaNgaus = imfilter(diffgaus, hN, 'conv'); % Differences (local gradients) in the smoothed version
    deltaSgaus = imfilter(diffgaus, hS, 'conv');
    deltaWgaus = imfilter(diffgaus, hW, 'conv');
    deltaEgaus = imfilter(diffgaus, hE, 'conv');
 
    deltaN = imfilter(diff_Im, hN, 'conv'); % Differences in the noisy image
    deltaS = imfilter(diff_Im, hS, 'conv');
    deltaW = imfilter(diff_Im, hW, 'conv');
    deltaE = imfilter(diff_Im, hE, 'conv');
 
 
    absdeltaN = abs(deltaN);
    absdeltaW = abs(deltaW);
    [kappaN, kappaW] = kneethreshold(absdeltaN, absdeltaW); % Calculate the gradient threshold parameters
 
 
 
    if ConductFunction == 1
        % Use the scaled Perona-Malik conductance function
        cN = exp(- (deltaNgaus / (kappaN / sqrt(5))) .^ 2);
        cS = exp(- (deltaSgaus / (kappaN / sqrt(5))) .^ 2);
        cW = exp(- (deltaWgaus / (kappaW / sqrt(5))) .^ 2);
        cE = exp(- (deltaEgaus / (kappaW / sqrt(5))) .^ 2);
     
    else
        % Use Tukey's biweight conductance function
     
        aN = find(abs(deltaNgaus) > kappaN);
        deltaN(aN) = 0;
        aS = find(abs(deltaSgaus) > kappaN);
        deltaS(aS) = 0;
        aE = find(abs(deltaEgaus) > kappaW);
        deltaE(aE) = 0;
        aW = find(abs(deltaWgaus) > kappaW);
        deltaW(aW) = 0;
     
        cN = 0.67 * ((1 - ((deltaNgaus / kappaN) .^ 2)) .^ 2);
        cS = 0.67 * ((1 - ((deltaSgaus / kappaN) .^ 2)) .^ 2);
        cW = 0.67 * ((1 - ((deltaWgaus / kappaW) .^ 2)) .^ 2);
        cE = 0.67 * ((1 - ((deltaEgaus / kappaW) .^ 2)) .^ 2);
    end
 
 
    diff_Im = diff_Im + lambda * (cN .* deltaN + cS .* deltaS + cW .* deltaW + cE .* deltaE); % The diffused image
 
 
 
    if stop_criterion == true
        tu1 = edgestrength(diff_Im, edgels);
        resedge{j + 1} = tu1;
        ematrix = resedge{j + 1};
     
        for k = 1:numedgels
            temp = ematrix{k};
            temp1 = temp(1:3, 1:2);
            temp2 = temp(1:3, 3:4);
            Q(k, j + 1) = abs((mean2(temp1) - mean2(temp2))) - a * (std(temp1(:), 1) + std(temp2(:), 1));
        end
     
        Qav = sum(Q);
        Qav = Qav / numedgels; % The average quality of the edgels
     
        if Qav(j + 1) < Qav(j)
            stop = true;
            stime = j;
        end
     
    else
        if j == Time
            stop = true;
            stime = Time;
        end
     
    end
 
 
 
 
 
end

fprintf('%g Iterations performed.\n', stime)
end
