clear; clc; close all;

%wczytywanie danych
filename = 'dane/2000-2019.csv';
delimiter = ',';
startRow = 2;
formatSpec = '%*s%f%f%f%f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
fclose(fileID);
daneWszystkie = [dataArray{1:end-1}];
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%obliczanie ilosci wszystkich danych w pliku 
sz = size(daneWszystkie);
if(sz(1,1) > sz(1,2))
    n = sz(1,1);
else
    n = sz(1,2);
end
clear sz;

%wczytywanie danych do ANFIS
kolumnaDane = 4;    % kolumna w ktorej znajduja sie interesujace nas dane
OstatniWiersz = n-100;  % wiersz w ktorym znajduje sie ostatni dzien ktory bedziemy wczytywac do danych
IloscDni = 400;        % ilosc dni ktore chcemy dac jako dane
PierwszyWiersz = OstatniWiersz - IloscDni+1;  % wiersz w danych z pliku w ktorym znajduje pierwszy dzien do danych do ANFIS1
IloscDniTestowych = 50;
IloscDniUczacych = IloscDni - IloscDniTestowych;
nDni = 4;   %ilosc wejsc


Xu = zeros(nDni, IloscDniUczacych);
Ku = zeros(1, IloscDniUczacych);
Xt = zeros(nDni, IloscDni-IloscDniUczacych);
Kt = zeros(1, IloscDni-IloscDniUczacych);

rozrzutUczace = zeros(1, IloscDniUczacych);
for i = PierwszyWiersz : PierwszyWiersz+IloscDniUczacych-1
    for j = 1 : nDni
        Xu(nDni-j+1,i-PierwszyWiersz+1) = daneWszystkie(i-j,kolumnaDane);
        rozrzutUczace(1,i-PierwszyWiersz+1) = rozrzutUczace(1,i-PierwszyWiersz+1) + Xu(nDni-j+1,i-PierwszyWiersz+1);
    end
    rozrzutUczace(1,i-PierwszyWiersz+1) = rozrzutUczace(1,i-PierwszyWiersz+1) / nDni;
    Ku(1,i-PierwszyWiersz+1) = daneWszystkie(i,kolumnaDane);
    suma = 0;
   	for j = 1 : nDni
      suma = suma + (rozrzutUczace(1,i-PierwszyWiersz+1) - Xu(nDni-j+1,i-PierwszyWiersz+1))^2;
    end
    rozrzutUczace(1,i-PierwszyWiersz+1) = sqrt(suma/nDni);
end

%odchylenie standardowe danych testowych od sredniej ich wartosci w nDni
rozrzutTestowe = zeros(1, IloscDniTestowych);
for i = PierwszyWiersz+IloscDniUczacych : OstatniWiersz
   for j = 1 : nDni
       Xt(nDni-j+1,i-PierwszyWiersz-IloscDniUczacych+1) = daneWszystkie(i-j,kolumnaDane);
       rozrzutTestowe(1,i-PierwszyWiersz-IloscDniUczacych+1) = rozrzutTestowe(1,i-PierwszyWiersz-IloscDniUczacych+1) + Xt(nDni-j+1,i-PierwszyWiersz-IloscDniUczacych+1);
   end   
   Kt(1,i-PierwszyWiersz-IloscDniUczacych+1) = daneWszystkie(i,kolumnaDane);
   rozrzutTestowe(1,i-PierwszyWiersz-IloscDniUczacych+1) = rozrzutTestowe(1,i-PierwszyWiersz-IloscDniUczacych+1) / nDni;
   suma = 0;
   for j = 1 : nDni
      suma = suma + (rozrzutTestowe(1,i-PierwszyWiersz-IloscDniUczacych+1) - Xt(nDni-j+1,i-PierwszyWiersz-IloscDniUczacych+1))^2;
   end
   rozrzutTestowe(1,i-PierwszyWiersz-IloscDniUczacych+1) = sqrt(suma/nDni);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Uczace = zeros(IloscDniUczacych, nDni+1);
Testowe = zeros(IloscDni-IloscDniUczacych, nDni+1);

Uczace(:, nDni+1) = Ku';
Testowe(:, nDni+1) = Kt';
Uczace(:, 1:nDni) = Xu';
Testowe(:, 1:nDni) = Xt';

opt = anfisOptions('InitialFIS', 2, 'EpochNumber', 10);
opt.DisplayErrorValues = 0;
opt.DisplayStepSize = 0;
fis = anfis(Uczace, opt);
anfisOutput = evalfis(fis, Xt');
anfisOutputUczace = evalfis(fis, Xu');

MSE_uczace = 0;
for i = 1 : IloscDniUczacych
    MSE_uczace = MSE_uczace + (Ku(1,i) - anfisOutputUczace(i,1))^2;
end
MSE_uczace = MSE_uczace/IloscDniUczacych;

MSE_test = 0;
OdchylenieProcent = zeros(IloscDniTestowych,1);
OdchylenieKwota = zeros(IloscDniTestowych,1);
SredniaPomylkaKwoty = 0;
WzrostSpadek = zeros(1, IloscDniTestowych);  %poprawne przewidywanie wzrostow i spadkow, 1 dobrze, 0 zle
for i = 1 : IloscDniTestowych
    MSE_test = MSE_test + (Kt(1,i) - anfisOutput(i,1))^2;
    OdchylenieProcent(i,1) = (anfisOutput(i,1) - Kt(1,i)) *100 / Kt(1,i);
    OdchylenieKwota(i,1) = (anfisOutput(i,1) - Kt(1,i));
    if(i > 1)
        if(((Kt(1,i) >= Kt(1,i-1)) && (anfisOutput(i,1) >= anfisOutput(i-1,1)))  || (((Kt(1,i) <= Kt(1,i-1)) && (anfisOutput(i,1)) <= anfisOutput(i-1,1))))
            WzrostSpadek(1, i) = 1; 
        end
    else
        if(((Kt(1,i) >= Ku(1,IloscDniUczacych)) && (anfisOutput(i,1) >= Ku(1,IloscDniUczacych)))  || (((Kt(1,i) <= Ku(1,IloscDniUczacych))) && (anfisOutput(i,1) <= Ku(1,IloscDniUczacych))))
            WzrostSpadek(1, i) = 1; 
        end
    end
    SredniaPomylkaKwoty = SredniaPomylkaKwoty + abs(anfisOutput(i,1) - Kt(1,i));
end
MSE_test = MSE_test/IloscDniTestowych;
SredniaPomylkaKwoty = SredniaPomylkaKwoty / IloscDniTestowych;
f1 = figure;
title('Testowanie');
hold on;
plot(anfisOutput, 'r');
plot(Kt, 'g');
legend('Predykcja ANFIS', 'Dane testujace');
hold off;

f2 = figure;
title('Uczenie');
hold on;
%plot(anfisOutputUczace, 'r');
plot(Ku, 'g');
%legend('ANFIS uczace', 'Wlasciwe');
legend('Dane uczace');
hold off;

f3 = figure;
plot(OdchylenieKwota);
title('Odchylenie kwota');

f4 = figure;
plot(OdchylenieProcent);
title('Odchylenie procentowe');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%wydajnosc przewidywania wzrostow i spadkow w procentach
WydajnoscWzrostSpadek = 0;
SredniRozrzutDanychTestowych = 0;
for i = 1 : IloscDniTestowych
    if(WzrostSpadek(1,i) == 1)
        WydajnoscWzrostSpadek = WydajnoscWzrostSpadek + 1;
    end
    SredniRozrzutDanychTestowych = SredniRozrzutDanychTestowych + rozrzutTestowe(1,i);
end
WydajnoscWzrostSpadek = WydajnoscWzrostSpadek/IloscDniTestowych*100;
SredniRozrzutDanychTestowych = SredniRozrzutDanychTestowych / IloscDniTestowych;

%badanie monotonicznosci danych testowych
if nDni >=3
MonotonicznoscTestowe = zeros(1, IloscDniTestowych);
for i = 1 : IloscDniTestowych
    if Testowe(i, nDni) >= Testowe(i, nDni-1) && Testowe(i, nDni-1) >= Testowe(i, nDni-2)
            MonotonicznoscTestowe(1,i) = 1;
    else if (Testowe(i, nDni-2) >= Testowe(i, nDni-1) && Testowe(i, nDni-1) >= Testowe(i,nDni))
            MonotonicznoscTestowe(1,i) = 1; 
        end
    end
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
SredniRozrzutDanychUczacych = 0;
for i = 1 : IloscDniUczacych
    SredniRozrzutDanychUczacych = SredniRozrzutDanychUczacych + rozrzutUczace(1,i);
end
SredniRozrzutDanychUczacych = SredniRozrzutDanychUczacych / IloscDniUczacych;

CzyRozrzutJestDuzy = zeros(1, IloscDniTestowych);
for i = 1 : IloscDniTestowych
    if(rozrzutTestowe(1,i) > SredniRozrzutDanychTestowych)
        CzyRozrzutJestDuzy(1,i) = 1;
    end
end

WydajnoscDuzyRozrzut = 0;
WydajnoscMalyRozrzut = 0;
IloscDuzychRozrzutow = 0;
for i = 1 : IloscDniTestowych
    if(CzyRozrzutJestDuzy(1,i) == 1)
        IloscDuzychRozrzutow = IloscDuzychRozrzutow + 1;
        if(WzrostSpadek(1,i) == 1)
            WydajnoscDuzyRozrzut = WydajnoscDuzyRozrzut + 1;
        end
    else
        if(WzrostSpadek(1,i) == 1)
           WydajnoscMalyRozrzut = WydajnoscMalyRozrzut + 1; 
        end
    end
end
WydajnoscMalyRozrzut = WydajnoscMalyRozrzut / (IloscDniTestowych - IloscDuzychRozrzutow)*100;
WydajnoscDuzyRozrzut = WydajnoscDuzyRozrzut / IloscDuzychRozrzutow*100;

WydajnoscMonotoniczne = 0;
WydajnoscNiemonotoniczne = 0;
IloscMonotonicznych = sum( MonotonicznoscTestowe);
for i = 1 : IloscDniTestowych
    if WzrostSpadek(1,i) == 1
        if MonotonicznoscTestowe(1,i) == 1
            WydajnoscMonotoniczne = WydajnoscMonotoniczne + 1;
        else 
            WydajnoscNiemonotoniczne = WydajnoscNiemonotoniczne + 1;
        end    
    end
end
WydajnoscMonotoniczne = WydajnoscMonotoniczne/IloscMonotonicznych*100;
WydajnoscNiemonotoniczne = WydajnoscNiemonotoniczne/(IloscDniTestowych - IloscMonotonicznych)*100;


WydajnoscMaleNiemonotoniczne = 0;
MaleNiemonotoniczne = zeros(1, IloscDniTestowych);
IloscMalychNiemonotonicznych = 0;
for i = 1 : IloscDniTestowych
    if CzyRozrzutJestDuzy(1,i) == 0 && MonotonicznoscTestowe(1,i) == 0
        MaleNiemonotoniczne(1, i) = 1;
    end
    IloscMalychNiemonotonicznych = sum(MaleNiemonotoniczne);
    
    if MaleNiemonotoniczne(1, i) == 1
        if WzrostSpadek(1, i) == 1
            WydajnoscMaleNiemonotoniczne = WydajnoscMaleNiemonotoniczne + 1;
        end
    end   
end
WydajnoscMaleNiemonotoniczne = WydajnoscMaleNiemonotoniczne/IloscMalychNiemonotonicznych * 100;

WydajnoscDuzeMonotoniczne = 0;
DuzeMonotoniczne = zeros(1, IloscDniTestowych);
IloscDuzychMonotonicznych = 0;
for i = 1 : IloscDniTestowych
    if CzyRozrzutJestDuzy(1,i) == 1 && MonotonicznoscTestowe(1,i) == 1
        DuzeMonotoniczne(1, i) = 1;
    end
    IloscDuzychMonotonicznych = sum(DuzeMonotoniczne);
    
    if DuzeMonotoniczne(1, i) == 1
        if WzrostSpadek(1, i) == 1
            WydajnoscDuzeMonotoniczne = WydajnoscDuzeMonotoniczne + 1;
        end
    end   
end
WydajnoscDuzeMonotoniczne = WydajnoscDuzeMonotoniczne/IloscDuzychMonotonicznych * 100;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

CzyAnfisDobry = zeros(1, IloscDniTestowych);
for i=1:IloscDniTestowych
    if CzyRozrzutJestDuzy(1,i) == 0
        if MonotonicznoscTestowe(1,i) == 0
            CzyAnfisDobry(1,i) = 2;
        else
            CzyAnfisDobry(1,i) = 1;
        end        
    else
        if MonotonicznoscTestowe(1,i) == 0
            CzyAnfisDobry(1,i) = 1;
        else
            CzyAnfisDobry(1,i) = 0;
        end       
    end
end

%wypisywanie wynikow
disp(['Dobrze przewidziane wzrosty i spadki (duzy rozrzut) ' num2str(WydajnoscDuzyRozrzut) '%']);
disp(['Dobrze przewidziane wzrosty i spadki (maly rozrzut) ' num2str(WydajnoscMalyRozrzut) '%']);
disp(['Dobrze przewidziane wzrosty i spadki (monotoniczne) ' num2str(WydajnoscMonotoniczne) '%']);
disp(['Dobrze przewidziane wzrosty i spadki (niemonotoniczne) ' num2str(WydajnoscNiemonotoniczne) '%']);
disp(['Dobrze przewidziane wzrosty i spadki (duze, monotoniczne) ' num2str(WydajnoscDuzeMonotoniczne) '%']);
disp(['Dobrze przewidziane wzrosty i spadki (male, niemonotoniczne) ' num2str(WydajnoscMaleNiemonotoniczne) '%']);
disp(['Dobrze przewidziane wzrosty i spadki cen akcji ' num2str(WydajnoscWzrostSpadek) '%']);
disp(['Blad sredniokwadratowy danych uczacych ' num2str(MSE_uczace)]);
disp(['Blad sredniokwadratowy dane testujace ' num2str(MSE_test)]);
disp(['Srednia pomylka ceny o ' num2str(SredniaPomylkaKwoty)]);
disp(['Sredni rozrzut danych testowych ' num2str(SredniRozrzutDanychTestowych)]);
disp(['Sredni rozrzut danych uczacych ' num2str(SredniRozrzutDanychUczacych)]);

%zapisywanie danych do plikow
csvwrite('zapisane/CzyRozrzutJestDuzy2.csv', CzyRozrzutJestDuzy);
%csvwrite('zapisane/CzyAnfisDobry.csv', CzyAnfisDobry); %zapisa
csvwrite('zapisane/MonotonicznoscTestowe2.csv', MonotonicznoscTestowe);
csvwrite('zapisane/WzrostSpadek.csv',WzrostSpadek);

clear i; clear j;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fuzzy CMEANS
clear ;
%wczytanie najlepszych wynikow
load zapisane/CzyRozrzutJestDuzy.csv
load zapisane/MonotonicznoscTestowe.csv
load zapisane/CzyAnfisDobry.csv
%wczytywanie danych do sprawdzenia 
load zapisane/CzyRozrzutJestDuzy2.csv
load zapisane/MonotonicznoscTestowe2.csv
load zapisane/WzrostSpadek.csv
TestData(:,1) = CzyRozrzutJestDuzy2(1,:);
TestData(:,2) = MonotonicznoscTestowe2(1,:);
inputData(:,1) = CzyRozrzutJestDuzy(1,:);
inputData(:,2) = MonotonicznoscTestowe(1,:);
outputData = CzyAnfisDobry';
opt = genfisOptions('FCMClustering','FISType','mamdani');
opt.NumClusters = 3;
opt.Verbose = 0;
fis = genfis(inputData,outputData,opt);
%showrule(fis)

genfisOutput = evalfis(fis, TestData);
nn = size(genfisOutput);
n = nn(1,1);
clear nn;
decyzja = zeros(1,n); ileJedynek = 0;
for i = 1 : n
   if(genfisOutput(i,1) >= 1)
       decyzja(1,i) = 1;
       ileJedynek = ileJedynek + 1;
   else
       decyzja(1,i) = 0;
   end
end
ileDobrze = 0;
for i = 1 : n
   if(decyzja(1,i) == WzrostSpadek(1,i))
       ileDobrze = ileDobrze + 1;
   end
end
%ileJedynek / n
disp(['Wydajnosc ' num2str(ileDobrze/n*100) '%']);

f5 = figure;

[x,mf] = plotmf(fis,'input',1);
subplot(3,1,1)
plot(x,mf)
xlabel('Membership Functions for Input 1')

[x,mf] = plotmf(fis,'input',2);
subplot(3,1,2)
plot(x,mf)
xlabel('Membership Functions for Input 2')

[x,mf] = plotmf(fis,'output',1);
subplot(3,1,3)
plot(x,mf)
xlabel('Membership Functions for Output')
