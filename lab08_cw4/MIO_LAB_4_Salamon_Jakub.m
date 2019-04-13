clear; clc; close all;
% wcztywanie danych
training = load('Lab4_training.txt');   training = training';
testing = load('Lab4_testing.txt');     testing  = testing';
iteracje = 10;
wydajnosc = zeros(1, iteracje);
% podzial danych
Xu = training (1:4, :);
Ku = training(5:7, :);
Xt = testing (1:4, :);
Kt = testing (5:7, :);

neurony = 8;

for iter = 1 : iteracje
    %zaczac od 50 ukrytych schodzic co 10 a potem co 1 od 10
    net = feedforwardnet(neurony);
    net.layers{1}.transferFcn = 'logsig'; % zmiana funkcji aktywacji w warstwie ukrytej
   % net.layers{2}.transferFcn = 'hardlim';   % wlaczyc do hardlim
    net.trainParam.epochs = 60;
    net.trainParam.min_grad = 10^(-25);

    %net.trainParam.mu = 0.56*10^(15);
    net = configure(net,Xu,Ku);
    net.divideFcn = 'dividetrain'; % blokada automatycznego podzialu na testujace i uczace
    %net.divideParam.max_fail = 100;

    net = train(net, Xu, Ku);
    %view(net);
    y = net(Xt);
    y_copy = y;
    for i = 1 : 3
        for j = 1 : 18
            if(y(i, j) > 0.5001)
                y(i, j) = 1;
            else
                y(i, j) = 0;
            end
        end
    end
    
    dobre = 0;
    for i = 1 : 18
        ile = 0;
        for j = 1 : 3
           if(y(j,i) == Kt(j,i))
               ile = ile + 1;
           end
        end
        if(ile == 3)
            dobre = dobre + 1;
        end
    end
    wydajnosc(1,iter) = 100*dobre/18;
    display(['Wydajnosc ' num2str(wydajnosc(1,iter)) '%  Pomylki ' num2str(18*(100-wydajnosc(1,iter))/100)]);
end

display(['Wydajnosc srednia ' num2str(sum(wydajnosc)/iteracje) '%  Pomylki ' num2str(18*(100-(sum(wydajnosc)/iteracje))/100)]);
%    scatter3(training(1,:), training(2,:), training(3,:), 15, training(4,:), 'filled' );
%    scatter3(testing(1,:), testing(2,:), testing(3,:), 15, testing(4,:), 'filled' );
%    hold on;
%    axis equal;
%    c = colorbar;
%    xlabel('x_1');
%    ylabel('x_2');
%    zlabel('x_3');
%    c.Label.String = 'x_4';
%    view(60, 30)