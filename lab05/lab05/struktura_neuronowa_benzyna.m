clear; clc;


in(:, 1) = X1



net = perceptron;
net = train(net, in(1, :), out(1,:));
view(net)
% y = net(in);