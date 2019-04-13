clear; clc; close all;
iteracje = 1;
% proba wzorcowa licznosc
warstwy = 11;   % ilosc neuronow warstwy ukrytej
wzorcowa = 50;  % licznosc proby uczacej
testowe = 1000; % licznosc proby testowej
najgorsze_S = 0;
najlepsze_S = 1000000;

wagi1_najlepsze = zeros(warstwy,1);
wagi2_najlepsze = zeros(warstwy,1);
wagi1_najgorsze = zeros(warstwy,1);
wagi2_najgorsze = zeros(warstwy,1);
bias1_najgorszy = zeros(warstwy, iteracje);
bias2_najgorszy = 0;
bias1_najlepszy = zeros(warstwy, iteracje);
bias2_najlepszy = 0;

A = 1;
B = 3;
C = 7;
D = 1;
E = 2;
F = 9;

%dziedzina
d1 = -2;
d2 =  5;

S = zeros(iteracje, 1);

for i = 1 : iteracje
    % przedzial x % dane uczace wybieramy z losowej dziedziny
    x1 = rand;
    x2 = rand;
    while(x1 > x2)
        x2 = rand;
    end

    %dane uczace
    Xu = rand(1,wzorcowa)*(d2 - d1) + d1;
    Xu = sort(Xu);
    for w = 1 : wzorcowa
        Ku(1, w) = A*sin(B*Xu(1, w) + C) + D*cos(E*Xu(1, w) + F);
    end


    %dane testowe
    Xt = rand(1,testowe)*(d2 - d1) + d1;
    Xt = sort(Xt);
    csvwrite('X.csv', Xt);
    for w = 1 : testowe
        Kt(1, w) = A*sin(B*Xt(1, w) + C) + D*cos(E*Xt(1, w) + F);
    end
    
    
    plot(Xu, Ku, 'g');
    hold on;
    plot(Xt, Kt, 'r')


    net = feedforwardnet(warstwy);
    net.trainParam.epochs = 1000;
    net.trainParam.goal = 10^(-10);    % Performance goal
    net.trainParam.time = inf;  % Maximum time to train in seconds
    net.trainParam.min_grad = 10^(-15);
    net.trainParam.mu = 0.56*10^(-15);
    %net.trainParam.max_fail = 1000;
    net.layers{1}.transferFcn = 'logsig';  %funkcja aktywacji warstwy ukrytej
    net.layers{2}.transferFcn = 'purelin';   %funkcja aktywacji warstwy wyjsciowej
    net = configure(net, Xu, Ku);
    [trainInd,valInd,testInd] = divideind(3000,1:wzorcowa,(wzorcowa/5):wzorcowa,(wzorcowa+1):(wzorcowa+testowe));
    divideParam.valInd = [];
    net = train(net,Xu,Ku);
    %view(net)
    y = net(Xt);
    
   % layer1transferfunction = net.layers{1}.transferFcn


    plot(Xt, y, 'b')

    
    %blad aproksymacji srednikwadratowej
    for w = 1 : testowe
        S(i,1) = S(i,1) + (Kt(1,w) - y(1,w))^2;
    end
    S(i,1) = S(i,1)/testowe;
    
    if(najgorsze_S < S(i,1))
        najgorsze_S = S(i,1);
        wagi1_najgorsze = net.IW{1};
        wagi2_najgorsze = (net.LW{2,1})';
        bias1_najgorszy = net.b{1};
        bias2_najgorszy = net.b{2};
        csvwrite('najgorsza.csv', y);
    end
    if(S(i,1) < najlepsze_S)
        najlepsze_S = S(i,1);
        wagi1_najlepsze = net.IW{1};
        wagi2_najlepsze = (net.LW{2,1})';
        bias1_najlepszy = net.b{1};
        bias2_najlepszy = net.b{2};
        csvwrite('wagi1.csv', wagi1_najlepsze);
        csvwrite('wagi2.csv', wagi2_najlepsze);
        csvwrite('bias1.csv', bias1_najlepszy);
        csvwrite('bias2.csv', bias2_najlepszy);
        csvwrite('najlepsza.csv', y);
    end
    
    


    %blad sieci neuronowej (to samo co s)
    %perf = perform(net, y, Kt)


end



hold off;

f2 = figure;
hold on;
%plot(Xt, csvread('najgorsza.csv'), 'r');
plot(Xt, csvread('najlepsza.csv'), 'g');
plot(Xt, Kt, 'b');
%legend('Najgorszy', 'Najlepszy', 'Wlasciwy');
title(['Proba uczaca ', num2str(wzorcowa), ' elementow']);
legend('Dopasowana', 'Wlasciwa');
najlepsze_S
najgorsze_S

hold off;


Xt = csvread('X.csv');
%f3 = figure;
hold on;
wagi1 = csvread('wagi1.csv');
wagi2 = csvread('wagi2.csv');
bias1 = csvread('bias1.csv');
bias2 = csvread('bias2.csv');
Y_dop = zeros(1,1000);
for t = 1 : 1000
    Y_dop(1,t) = 0;
    wagi2_suma = 0;
    for j = 1 : warstwy
        Y_dop(1,t) = Y_dop(1,t)  + ( wagi2(j,1) * logsig( wagi1(j,1)*(Xt(1,t)) + bias1(j,1) )); 
    end
    Y_dop(1,t) = purelin(Y_dop(1,t) +( bias2) );
end

%plot(Xt, Y_dop, 'g')
%plot(Xt, csvread('najlepsza.csv'), 'r')
%legend('Dopasowany wzor', 'taki jak ma byc');

% wypisywanie wzoru
disp(['Q(x) = ' num2str(bias2) '(']);
for w = 1 : warstwy
   if((w < warstwy) && (wagi2(w+1,1) < 0) && (bias1(w,1) >= 0))
       disp([num2str(wagi2(w,1)) ' * ' net.layers{1}.transferFcn '(' num2str(wagi1(w,1)) 'x + ' num2str(bias1(w,1)) ')']);
   end
   if((w < warstwy) && (wagi2(w+1,1) < 0) && (bias1(w,1) < 0))
       disp([num2str(wagi2(w,1)) ' * ' net.layers{1}.transferFcn '(' num2str(wagi1(w,1)) 'x ' num2str(bias1(w,1)) ')']);
   end
   if((w < warstwy) && (wagi2(w+1,1) >= 0) && (bias1(w,1) >= 0))
       disp([num2str(wagi2(w,1)) ' * ' net.layers{1}.transferFcn '(' num2str(wagi1(w,1)) 'x + ' num2str(bias1(w,1)) ') +']);
   end
   if((w < warstwy) && (wagi2(w+1,1) >= 0) && (bias1(w,1) < 0))
       disp([num2str(wagi2(w,1)) ' * ' net.layers{1}.transferFcn '(' num2str(wagi1(w,1)) 'x ' num2str(bias1(w,1)) ') +']);
   end
   if((w == warstwy))
       disp([num2str(wagi2(w,1)) ' * ' net.layers{1}.transferFcn '(' num2str(wagi1(w,1)) 'x ' num2str(bias1(w,1)) ')']);
   end
end
if(bias2(1,1) >= 0)
       disp([') ' '+' num2str(bias2(1,1))]); 
end
if(bias2(1,1) < 0)
       disp([') ' num2str(bias2(1,1))]); 
end
display(['Blad aproksymacji ' num2str(najlepsze_S)]);
najlepsze_S
najgorsze_S