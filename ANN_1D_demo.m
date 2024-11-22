% Neural Network Regression on Noisy 1D Polynomial Function

clear;
clc;
close all;

% Generate synthetic data: Polynomial function with noise
% Define a polynomial with multiple inflection points, minima, and maxima
x = linspace(-5, 5, 501)';    % Input values (1D data)
y_true = 0.1*x.^5 - 0.5*x.^3 + x.^2 - 2*x;  % True function (5th-degree polynomial)

% Add noise to the polynomial function
noise = 5 * randn(size(x));  % Gaussian noise
y_noisy = y_true + noise;      % Noisy data

split_type = 1;

%% SPLITTING DATA
if split_type==1
    % Split data into training and testing sets (80% train, 20% test)
    % training only covers the first part of the domain --> extrapolation issue
    nTrain = round(0.8 * length(x));
    x_train = x(1:nTrain);
    y_train = y_noisy(1:nTrain);
    
    x_test = x(nTrain+1:end);
    y_test = y_noisy(nTrain+1:end);
else
    % Randomly shuffle the data indices
    nData = length(x);
    randIndices = randperm(nData);
    
    % Define training and testing data sizes (80% training, 20% testing)
    nTrain = round(0.8 * nData);
    trainIndices = randIndices(1:nTrain);
    testIndices = randIndices(nTrain+1:end);
    
    % Use the shuffled indices to select training and testing data
    x_train = x(trainIndices);
    y_train = y_noisy(trainIndices);
    
    x_test = x(testIndices);
    y_test = y_noisy(testIndices);
    
    % Sort the training data in increasing order of x
    [x_train, trainSortIdx] = sort(x_train);
    y_train = y_train(trainSortIdx);
    
    % Sort the testing data in increasing order of x
    [x_test, testSortIdx] = sort(x_test);
    y_test = y_test(testSortIdx);
end


%% CONFIGURE ANN
% Create and configure a neural network for regression (fitnet)
hiddenLayerSize = 20;  % Number of neurons in the hidden layer
net = fitnet(hiddenLayerSize);

% Divide data for training, validation, and testing
net.divideParam.trainRatio = 0.7;
net.divideParam.valRatio = 0.15;
net.divideParam.testRatio = 0.15;

% Train the network
[net, tr] = train(net, x_train', y_train');

% Predict the output using the trained network
y_train_pred = net(x_train');
y_test_pred = net(x_test');

% Plot results
figure;
subplot(2,1,1);
plot(x, y_true, 'k', 'LineWidth', 1.5); hold on;  % True polynomial
plot(x_train, y_train, 'bo');                    % Noisy training data
plot(x_train, y_train_pred, 'r', 'LineWidth', 2);% Neural network fit (train)
legend(...
    'True Function',...
    'Noisy Training Data',...
    'NN Approximation (Train)',Location='north');
title('Neural Network Regression (Training Set)');
xlabel('x');
ylabel('y');
grid on;

subplot(2,1,2);
plot(x, y_true, 'k', 'LineWidth', 1.5); hold on;  % True polynomial
plot(x_test, y_test, 'go');                      % Noisy testing data
plot(x_test, y_test_pred, 'r', 'LineWidth', 2);  % Neural network fit (test)
legend(...
    'True Function',...
    'Noisy Test Data',...
    'NN Approximation (Test)',...
    Location='north');
title('Neural Network Regression (Testing Set)');
xlabel('x');
ylabel('y');
grid on;

% Evaluate performance (MSE)
trainMSE = mse(y_train' - y_train_pred);
testMSE = mse(y_test' - y_test_pred);

fprintf('Training MSE: %.4f\n', trainMSE);
fprintf('Testing MSE: %.4f\n', testMSE);
