clear; clc;
LWUczDlaKlasy = 50; % liczba wzorcow uczacych w kazdej z klas
epoki = 50;

%proba uczaca
xu= randn(2, 2*LWUczDlaKlasy);
xu(1, (LWUczDlaKlasy+1):(2*LWUczDlaKlasy)) = xu(1, (LWUczDlaKlasy+1):(2*LWUczDlaKlasy)) + 2;
ku = zeros(1, LWUczDlaKlasy);
ku(1, (LWUczDlaKlasy+1):(2*LWUczDlaKlasy)) = 1;

%proba testowa
xt = randn(2, 1000);
xt(:, 1001:2000) = randn(2, 1000);
xt(1, 1001:2000) = xt(1, 1001:2000) + 2; 
kt = zeros(1, 1000);
kt(1, 1001:2000) = 1;

net = perceptron;
net.trainParam.epochs = epoki;
net = train(net, xu, ku);

y = net(xt);
%view(net)

%macierz klasyfikacji
klasyfikacja = zeros(2, 2);
for i = 1 : 1000
  if(y(i) == 0)
    klasyfikacja(1, 1) = klasyfikacja(1, 1) + 1;
  else
    klasyfikacja(1, 2) = klasyfikacja(1, 2) + 1;
    
  end
end

for i = 1001 : 2000
  if(y(i) == 0)
    klasyfikacja(2, 1) = klasyfikacja(2, 1) + 1;
  else
    klasyfikacja(2, 2) = klasyfikacja(2, 2) + 1;
  end
end

wagi = net.iw{1,1};
bias = net.b{1};

%plot(xt(1, 1:1000), xt(2, 1:1000), 'r.')
%hold on;
%plot(xt(1, 1001:2000), xt(2, 1001:2000), 'g.')

plot(xu(1, 1:LWUczDlaKlasy), xu(2, 1:LWUczDlaKlasy), 'r.')
hold on;
plot(xu(1, (LWUczDlaKlasy+1):(2*LWUczDlaKlasy)), xu(2, (LWUczDlaKlasy+1):(2*LWUczDlaKlasy)), 'g.')

plotpc(wagi, bias)
legend('klasa 1', 'klasa 2', 'hiperplaszczyzna');
title(['Po ', num2str(LWUczDlaKlasy), ' dla kazdej z klas']);

%wartosci a i b dla wyznaczenia funkcji hiperplaszczyzny
a = -wagi(1, 1)/wagi(1, 2);
b = -bias/wagi(1, 2);

%jaki procent danych jest poprawnie sklasyfikowany
poprawnosc = (klasyfikacja(1, 1) + klasyfikacja(2, 2))/2000 * 100;
if(b >= 0)
    disp(['Funkcja y = ' num2str(a) 'x + ' num2str(b)]);
else
    disp(['Funkcja y = ' num2str(a) 'x ' num2str(b)]);
end
disp(['Poprawnosc sklasyfikowania ' num2str(poprawnosc) '%']);
disp(['Liczba epok ' num2str(epoki)]);
hold off;


