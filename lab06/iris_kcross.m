clear; clc;

kod = [0, 1;  %setosa
           1, 0;  %versicolor
           0, 0;  %virginica
          ];

performance = cell(5, 1);
suma = 0;
for iteracja = 1 : 5
    [meas, K] = iris_dataset;
    meas = meas';

    species = zeros(150, 1);
    for i = 1 : 150
       if(((K(1, i) == 1)) && (K(2, i) ==  0) && (K(3, i) == 0))
           species(i, 1) = 00;
       end
       if(((K(1, i) == 0)) && (K(2, i) ==  1) && (K(3, i) == 0))
           species(i, 1) = 01;
       end
       if(((K(1, i) == 0)) && (K(2, i) ==  0) && (K(3, i) == 1))
           species(i, 1) = 10;
       end
    end

    indices = crossvalind('Kfold',species,10);
    cp = classperf(species);
    for i = 1:10
        test = (indices == i); 
        train = ~test;
        class = classify(meas(test,:),meas(train,:),species(train,:));
        classperf(cp,class,test);
    end
    cp.ErrorRate;

    k = zeros(2, 150);
    for i = 1 : 150
       if(((K(1, i) == 1)) && (K(2, i) ==  0) && (K(3, i) == 0))
           k(1, i) = kod(1, 1);
           k(2, i) = kod(1, 2);
       end
       if(((K(1, i) == 0)) && (K(2, i) ==  1) && (K(3, i) == 0))
           k(1, i) = kod(2, 1);
           k(2, i) = kod(2, 2);
       end
       if(((K(1, i) == 0)) && (K(2, i) ==  0) && (K(3, i) == 1))
           k(1, i) = kod(3, 1);
           k(2, i) = kod(3, 2);
       end
    end
    meas_ = meas';
    proba_uczaca = 0;
    for i = 1 : 150
        if(train(i, 1))
            proba_uczaca = proba_uczaca + 1;
        end
    end
    proba_test = 150 - proba_uczaca;
    xu = zeros(4, proba_uczaca);
    ku = zeros(2, proba_uczaca);
    xt = zeros(4, proba_test);
    kt = zeros(2, proba_test);
    u = 1;
    t = 1;
    for i = 1 : 150
        if(train(i, 1))
            xu(:, u) = meas_(:, i);
            ku(:, u) = k(:, i);
            u = u+1;
        end
        if(test(i, 1))
            xt(:, t) = meas_(:, i);
            kt(:, t) = k(:, i);
            t = t+1;
        end
    end
    proby = zeros(2, 1);
    proby(1,1) = proba_uczaca;
    proby(2,1) = proba_test;
    csvwrite('xu.csv', xu);
    csvwrite('ku.csv', ku);
    csvwrite('xt.csv', xt);
    csvwrite('kt.csv', kt);
    csvwrite('proby.csv', proby);
    csvwrite('kod.csv', kod);
    csvwrite('iteracja.csv', iteracja);
    csvwrite('suma.csv', suma);
    clear; 
    xu = csvread('xu.csv');
    ku = csvread('ku.csv');
    xt = csvread('xt.csv');
    kt = csvread('kt.csv');
    proby = csvread('proby.csv');
    kod = csvread('kod.csv');
    iteracja = csvread('iteracja.csv');
    suma = csvread('suma.csv');
    proba_uczaca = proby(1,1);
    proba_test = proby(2,1);


    net = perceptron;
    net.trainParam.epochs = 100;
    net = train(net, xu, ku);

    %view(net)

    y = net(xt);


    dobre = 0;
    for i = 1 : proba_test
        if(y(1, i) == kt(1, i))
            if(y(2, i) == kt(2, i))
                dobre = dobre + 1;
            end
        end
    end
    disp(['Bledy = ' num2str(proba_test - dobre)]);


    performance(iteracja, 1) = dobre/proba_test;
    disp(['Wydajnosc = ' num2str(performance(iteracja, 1))]);
    disp(['Blad calkowity = ' num2str((proba_test-dobre)/(proba_test))]);
    suma = suma + performance(iteracja, 1);
    suma/iteracja;

end
 
disp(['Srednia wydajnosc = ' num2str(suma/iteracja)]);


