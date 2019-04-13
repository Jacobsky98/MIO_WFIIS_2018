clear; clc;
epoki = 10000;

poprawnosc = zeros(5, 1);
punkty_dzielenia = zeros(5, 1);
suma_poprawnosci = 0;
wagi = zeros(5, 3);
bias = zeros(5, 1);

for n = 1 : 5
    punkt_dzielenia = randi([2 29],1,1);
    punkty_dzielenia(n, 1) = punkt_dzielenia;
    dane = importdata('Lab1_training.txt');
    dane = dane';

    %dane uczace
    wejscieU = dane(1:3, 1:punkt_dzielenia);
    wyjscieU = dane(4, 1:punkt_dzielenia);

    %dane testowe
    wejscieT = dane(1:3, (punkt_dzielenia+1):30);
    wyjscieT = dane(4, (punkt_dzielenia+1):30);

    %odpowiednie ukladanie danych testowych aby moc potem ocenic
    %ich sklasyfikowanie
    wejscieT_tmp = zeros(3, 30-punkt_dzielenia);
    wyjscieT_tmp = zeros(1, 30-punkt_dzielenia);

    j = 1;
    k = 30-punkt_dzielenia;
    for i = 1 : (30-punkt_dzielenia)
       if(wyjscieT(i) == 0)
          wejscieT_tmp(1:3, j) = wejscieT(1:3,i);
          wyjscieT_tmp(1, j) = 0;
          j = j+1;
       else
          wejscieT_tmp(1:3, k) = wejscieT(1:3,i);
          wyjscieT_tmp(1, k) = 1;
          k = k-1;
       end
    end

    wejscieT = wejscieT_tmp;
    wyjscieT = wyjscieT_tmp;




    net = perceptron;
    net.trainParam.epochs = epoki;
    net = train(net, wejscieU, wyjscieU);

    y = net(wejscieT);
    %view(net)
    klasyfikacja = zeros(2, 2);
    for i = 1 : (j-1)
      if(y(i) == 0)
        klasyfikacja(1, 1) = klasyfikacja(1, 1) + 1;
      else
        klasyfikacja(1, 2) = klasyfikacja(1, 2) + 1;

      end
    end

    for i = (k+1) : (30-punkt_dzielenia)
      if(y(i) == 0)
        klasyfikacja(2, 1) = klasyfikacja(2, 1) + 1;
      else
        klasyfikacja(2, 2) = klasyfikacja(2, 2) + 1;
      end
    end

    wagi(n, 1:3) = net.iw{1};
    bias(n, 1) = net.b{1};

    %jaki procent danych jest poprawnie sklasyfikowany
    poprawnosc(n, 1) = (klasyfikacja(1, 1) + klasyfikacja(2, 2))/(30-punkt_dzielenia) * 100;
    suma_poprawnosci = suma_poprawnosci + poprawnosc(n, 1);
    
    disp(['Poprawnosc sklasyfikowania ' num2str(poprawnosc(n, 1)) '%']);
end

srednie_sklasyfikowanie = suma_poprawnosci/5;
disp(['Srednia poprawnosc sklasyfikowania ' num2str(srednie_sklasyfikowanie) '%']);
punkty_dzielenia




