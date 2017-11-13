%%% Input:  Noisy image A
%%% Output: The estimate of the standard deviation of the noise


function snoise = noise_estimate(A)


m = size(A, 1);

% A sliding window of size relative to the width of the image is used
if mod(round(m / 5), 2) == 1
    pixNHOOD = round(m / 5);
else
    pixNHOOD = round(m / 5) - 1;
end

NHOOD = ones(pixNHOOD);

% The intensity standard deviation of the most uniform window is used as the
% estimate of the standard deviation of the noise
J = stdfilt(A, NHOOD);
snoise = min(min(J));

end
