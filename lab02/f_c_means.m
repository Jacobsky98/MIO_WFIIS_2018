dane = csvread('lab02_data.csv');

% liczba wejsc
N = 3;

inputData = dane(:,1:N);
outputData = dane(:,N+1);
options = [NaN 25 0.001 0];

opt = NaN(3, 1);
opt(4) = 0;
%generowanie fis
fis = genfis3(inputData, outputData, 'mamdani', N, opt);
%pokazuje reguly
showrule(fis)

%rysowanie wykresow funkcji przynaleznosci
[x, mf] = plotmf(fis, 'input', 1);
subplot(4, 1, 1)
plot(x, mf)
xlabel('Funkcje przynaleznosci dla wejscia 1');

[x,mf] = plotmf(fis,'input',2);
subplot(4,1,2)
plot(x,mf)
xlabel('Funkcje przynaleznosci dla wejscia 2')

[x,mf] = plotmf(fis,'input',3);
subplot(4,1,3)
plot(x,mf)
xlabel('Funkcje przynaleznosci dla wejscia 3')

[x,mf] = plotmf(fis,'output',1);
subplot(4,1,4)
plot(x,mf)
xlabel('Funkcje przynaleznosci dla wyjscia')

% import danych wejsciowych do FIS
output_fis = evalfis(inputData, fis);

% obliczanie bledu sredniokwadratowego dla recznych regul, podpunkt 1
blad_sredniokwadratowy_manual_rules = 0;
suma = 0;

for i = 1 : size(output_fis(:,1))
    suma = suma + ((output_fis(i, 1) - outputData(i, 1))^2);
end

blad_sredniokwadratowy_manual_rules = suma / 255


