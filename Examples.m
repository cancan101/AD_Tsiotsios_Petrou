% This package contains an implementation of the Anisotropic Diffusion algorithm as described in:
% C.Tsiotsios, M.Petrou, On the choice of the parameters for anisotropic diffusion in image processing, Pattern Recognition (2012), http://dx.doi.org/10.1016/j.patcog.2012.11.012
% Please cite in case of using any version of the algorithm.

%%%%% The main function is "Main_AD". It returns the resultant greyscale diffused image, after using the proposed algorithm. 
%%%%% I=Main_AD(A) --> Fully automated version of the method 
%%%%% I=Main_AD(A,ConductFunction, Time, Snoise)  --> Parameterized version of the method


% Input 'A' is the greyscale noisy image.
% Optional Input 'ConductFunction' sets the conductance function to be used. Set '1' for the Perona-Malik function or '2' for the Tukey's biweight function. Default is '1'.
% Optional Input 'Time' sets the number of iterations to be performed. 
% Optional Input 'Snoise' sets the a-priori known standard deviation of the noise

% Output 'I' is the filtered image


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%   EXAMPLE 1   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% The function requires at least input 'A' (noisy image) to operate.
%%% In this case, values are automatically set or estimated for the rest of the
%%% inputs.
% Example: 

clear all

A0=imread('lena.png'); % Noise free image
A=imnoise(A0,'gaussian',0, 0.002); % Input noisy greyscale image

I=Main_AD(A); % Filtered image

figure
subplot(1,3,1); imshow(A0);
title('Original noise free image')
subplot(1,3,2); imshow(A);
title('Noisy image')
subplot(1,3,3); imshow(I);
title('Filtered image')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%   EXAMPLE 2   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% 'ConductFunction' input, determines the conductance function that 
%%% will be used. Set '1' for the Perona-Malik function or '2' for the 
%%% Tukey's biweight function. When no value is specified,
%%% 'ConductFunction' is automatically set to '1'. 
%%% (Empty brackets should be used for the rest of the inputs to be
%%% estimated automatically).
% Example: 

clear all
A0=imread('lena.png'); % Noise free image
A=imnoise(A0,'gaussian',0, 0.002); % Input noisy greyscale image


I1=Main_AD(A,1,[],[]); % Filtered image using Perona-Malik function
I2=Main_AD(A,2,[],[]); % Filtered image using Tukey's biweight function
figure
subplot(2,2,1); imshow(A0);
title('Original noise free image')
subplot(2,2,2); imshow(A);
title('Noisy image')
subplot(2,2,3); imshow(I1);
title('Filtered image using PM function')
subplot(2,2,4); imshow(I2);
title('Filtered image using Tukeys weight function')



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%   EXAMPLE 3   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% 'Time' input can be used when specific number of iterations is chosen. 
% Example: 
clear all
A0=imread('lena.png'); % Noise free image
A=imnoise(A0,'gaussian',0, 0.002); % Input noisy greyscale image

I1=Main_AD(A,[],5,[]); % Filtered image after 5 iterations
I2=Main_AD(A,[],30,[]); % Filtered image after 30 iterations

figure
subplot(2,2,1); imshow(A0);
title('Original noise free image')
subplot(2,2,2); imshow(A);
title('Original noisy image')
subplot(2,2,3); imshow(I1);
title('Filtered image after 5 iterations')
subplot(2,2,4); imshow(I2);
title('Filtered image after 30 iterations')



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%   EXAMPLE 4   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% 'Snoise' input can be used when the standard deviation of the noise of  
%%% the input image is known a-priori.
% Example:

clear all
A0=imread('lena.png'); % Noise free image
A=imnoise(A0,'gaussian',0, 0.002); % Input noisy greyscale image


I1=Main_AD(A,[],[], sqrt(0.002)); % Filtered image when the standard deviation of the noise is known a-priori
I2=Main_AD(A); % Filtered image when the standard deviation of the noise is estimated automatically

figure
subplot(2,2,1); imshow(A0);
title('Original noise free image')
subplot(2,2,2); imshow(A);
title('Original noisy image')
subplot(2,2,3); imshow(I1);
title('A-priori known standard deviation of noise')
subplot(2,2,4); imshow(I2);
title('Automatically estimated standard deviation of noise ')

