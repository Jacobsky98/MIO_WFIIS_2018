
% wczytywanie danych z pliku lab02_data.csv

dane = csvread('lab02_data.csv');
input_data = dane;
input_data(:,4) = [];
output_data = dane(:, 4);

% import danych wejsciowych do FIS
fis_manual = readfis('fuzzy_c_means.fis');
output_manual_fis = evalfis(input_data, fis_manual);

% obliczanie bledu sredniokwadratowego dla recznych regul, podpunkt 1
blad_sredniokwadratowy_manual_rules = 0;
suma = 0;

for i = 1 : size(output_manual_fis(:,1))
    suma = suma + ((output_manual_fis(i, 1) - output_data(i, 1))^2);
end

blad_sredniokwadratowy_manual_rules = suma / 255