clear; clc;

%kodawanie wyniku
kod = [0,1;
       1,0;      
       0,0;
       1,1];

%dane uczace
proba_wzorca = 50;

xu = randn(2, 4*proba_wzorca);
xu(1, 1:proba_wzorca) = xu(1, 1:proba_wzorca) + 2;
xu(1, (proba_wzorca+1) : (2*proba_wzorca)) = xu(1, (proba_wzorca+1) : (2*proba_wzorca)) - 2;
xu(2, (2*proba_wzorca+1) : (3*proba_wzorca)) = xu(2, (2*proba_wzorca+1) : (3*proba_wzorca)) + 2;
xu(2, (3*proba_wzorca+1) : (4*proba_wzorca)) = xu(2, (3*proba_wzorca+1) : (4*proba_wzorca)) - 2;


ku = zeros(2, 4*proba_wzorca);
ku(1, 1:proba_wzorca) = kod(1,1);
ku(2, 1:proba_wzorca) = kod(1,2);
ku(1, (proba_wzorca+1):(2*proba_wzorca)) = kod(2,1);
ku(2, (proba_wzorca+1):(2*proba_wzorca)) = kod(2,2);
ku(1, (2*proba_wzorca+1):(3*proba_wzorca)) = kod(3,1);
ku(2, (2*proba_wzorca+1):(3*proba_wzorca)) = kod(3,2);
ku(1, (3*proba_wzorca+1):(4*proba_wzorca)) = kod(4,1);
ku(2, (3*proba_wzorca+1):(4*proba_wzorca)) = kod(4,2);


%dane testowe
proba_test = 1000;
xt = randn(2, 4*proba_test);
xt(1, 1:proba_test) = xt(1, 1:proba_test) + 2;
xt(1, (proba_test+1) : (2*proba_test)) = xt(1, (proba_test+1) : (2*proba_test)) - 2;
xt(2, (2*proba_test+1) : (3*proba_test)) = xt(2, (2*proba_test+1) : (3*proba_test)) + 2;
xt(2, (3*proba_test+1) : (4*proba_test)) = xt(2, (3*proba_test+1) : (4*proba_test)) - 2;

kt = zeros(2, 4*proba_test);
kt(1, 1:proba_test) = kod(1,1);
kt(2, 1:proba_test) = kod(1,2);
kt(1, (proba_test+1):(2*proba_test)) = kod(2,1);
kt(2, (proba_test+1):(2*proba_test)) = kod(2,2);
kt(1, (2*proba_test+1):(3*proba_test)) = kod(3,1);
kt(2, (2*proba_test+1):(3*proba_test)) = kod(3,2);
kt(1, (3*proba_test+1):(4*proba_test)) = kod(4,1);
kt(2, (3*proba_test+1):(4*proba_test)) = kod(4,2);



net = perceptron;

net.trainParam.epochs = 30;
net = train(net, xu, ku);

%view(net)

y = net(xt);

%wzor funkcji
wagi = net.iw{1,1};
bias = net.b{1};

a1 = -wagi(1, 1)/wagi(1, 2);
b1 = -bias(1, 1)/wagi(1, 2);
if(b1 >= 0)
    disp(['Hiperplaszczyzna 1 y = ' num2str(a1) 'x + ' num2str(b1)]);
else
    disp(['Hiperplaszczyzna 1 y = ' num2str(a1) 'x ' num2str(b1)]);
end
a2 = -wagi(2, 1)/wagi(2, 2);
b2 = -bias(2, 1)/wagi(2, 2);
if(b2 >= 0)
    disp(['Hiperplaszczyzna 2 y = ' num2str(a2) 'x + ' num2str(b2)]);
else
    disp(['Hiperplaszczyzna 2 y = ' num2str(a2) 'x ' num2str(b2)]);
end


plot(xu(1, 1:proba_wzorca), xu(2, 1:proba_wzorca), 'r.')
hold on;
plot(xu(1, (proba_wzorca+1) : (2*proba_wzorca)), xu(2, (proba_wzorca+1) : (2*proba_wzorca)), 'g.')
plot(xu(1, (2*proba_wzorca+1) : (3*proba_wzorca)), xu(2, (2*proba_wzorca+1) : (3*proba_wzorca)), 'c.')
plot(xu(1, (3*proba_wzorca+1) : (4*proba_wzorca)), xu(2, (3*proba_wzorca+1) : (4*proba_wzorca)), 'k.')

plotpc(wagi(1, 1:2), bias(1, 1))
plotpc(wagi(2, 1:2), bias(2, 1))
legend('K1', 'K2', 'K3', 'K4', 'HipPlasz 1', 'HipPlasz 2');

dobre = 0;
for i = 1 : 4*proba_test
    if(y(1, i) == kt(1, i))
        if(y(2, i) == kt(2, i))
            dobre = dobre + 1;
        end
    end
end
%disp(['Bledy = ' num2str(4*proba_test - dobre)]);


klasyfikacja = zeros(4, 4);
kolumna = 1;
for i = 1 : 4
    for j = ((i-1)*proba_test + 1) : i*proba_test
        if((y(1, j) == kod(1,1)) && (y(2, j) == kod(1,2)))
            kolumna = 1;
        end
        if((y(1, j) == kod(2,1)) && (y(2, j) == kod(2,2)))
            kolumna = 2;
        end
        if((y(1, j) == kod(3,1)) && (y(2, j) == kod(3,2)))
            kolumna = 3;
        end
        if((y(1, j) == kod(4,1)) && (y(2, j) == kod(4,2)))
            kolumna = 4;
        end
        klasyfikacja(i, kolumna) = klasyfikacja(i, kolumna) + 1;
    end
end



performance = (klasyfikacja(1, 1) + klasyfikacja(2,2)+klasyfikacja(3,3)+klasyfikacja(4,4))/(4*proba_test);
disp(['Wydajnosc = ' num2str(performance*100) '%']);
disp(['Blad calkowity = ' num2str((1-performance)*100) '%']);
klasyfikacja;

hold off;



