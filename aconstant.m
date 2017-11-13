%%% Inputs: The number of edgels that are examined, the matrix with the
%%%         positions of the edgels and the standard deviation of the noise
%%% Output: Constant a

function a = aconstant(numedgels, ematrix, snoise)

mean_contrast(1:numedgels) = 0;
for j = 1:numedgels
    temp = ematrix{j};
    temp1 = temp(:, 1:2);
    temp2 = temp(:, 3:4);
 
 
    mean_contrast(j) = abs(mean2(temp1) - mean2(temp2));
 
 
end
mean_all(1) = mean(mean_contrast);
a = (10 * snoise) / mean_all(1);

end
