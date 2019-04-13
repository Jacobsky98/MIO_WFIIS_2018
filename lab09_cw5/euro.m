clear; clc; close all;

filename = 'euro.csv';
delimiter = ',';
startRow = 4;
formatSpec = '%s%s%s%s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
fclose(fileID);
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = mat2cell(dataArray{col}, ones(length(dataArray{col}), 1));
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));

for col=[1,2,3,4]
    % Converts text in the input cell array to numbers. Replaced non-numeric
    % text with NaN.
    rawData = dataArray{col};
    for row=1:size(rawData, 1)
        % Create a regular expression to detect and remove non-numeric prefixes and
        % suffixes.
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData(row), regexstr, 'names');
            numbers = result.numbers;
            
            % Detected commas in non-thousand locations.
            invalidThousandsSeparator = false;
            if numbers.contains(',')
                thousandsRegExp = '^[-/+]*\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(numbers, thousandsRegExp, 'once'))
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
            % Convert numeric text to numbers.
            if ~invalidThousandsSeparator
                numbers = textscan(char(strrep(numbers, ',', '')), '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch
            raw{row, col} = rawData{row};
        end
    end
end


R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw); % Find non-numeric cells
raw(R) = {NaN}; % Replace non-numeric cells
dane = cell2mat(raw);
clearvars filename delimiter startRow formatSpec fileID dataArray ans raw col numericData rawData row regexstr result numbers invalidThousandsSeparator thousandsRegExp R;kopia_dane = dane;
kopia_dane = dane;
dane(:, 2) = kopia_dane(:, 4);
dane(:, 4) = kopia_dane(:,2);


n= 1195;
%wybieranie danych
PierwszyDzienDane = 1;
OstatniDzienDane = 600;     
%na ile dni ma byc przewidziane - nDni
ileDniPrzewidziec = 125;
n = OstatniDzienDane - PierwszyDzienDane+1;
Danelab5 = zeros(n, 4);
for i = PierwszyDzienDane : OstatniDzienDane
    Danelab5(i-PierwszyDzienDane+1, :) = dane(i,:);
end


max = 0;
for i = 1 : n
    if(Danelab5(i,4) > max)
        max = Danelab5(i,4);
    end
end
for i = 1 : n
    Danelab5(i,4) = (Danelab5(i,4)/max) - 0.5;
end

net = feedforwardnet([1, 11]);
net.layers{1}.transferFcn = 'tansig';
net.layers{2}.transferFcn = 'tansig';
net.layers{3}.transferFcn = 'tansig';
net.trainParam.lr = 0.05;
net.trainParam.epochs = 3000;
net.trainParam.goal = 1e-7;


nDni = 5;
%ilosc dni przez ktore siec ma byc poczatkowo trenowana
DniTrenujace = n - ileDniPrzewidziec;
X = zeros(nDni,n-nDni);
K = zeros(1, n-nDni);
for i = nDni +1 : n
    for j = 1 : nDni
       X(j,i-nDni) = Danelab5(i-j,4);
       K(1,i-nDni) = Danelab5(i,4);
    end
end
n = n - nDni;


%macierz bool czy dobrze przewidziano wzrost i spadek
WzrostSpadek = zeros(1, n-DniTrenujace);

%macierz pieciodniowych prognoz
Prognoza = zeros(n-DniTrenujace, n-DniTrenujace);
for i = DniTrenujace : n-1 
    Xu = X(:, 1:i);
    Ku = K(:, 1:i);
    Xt = X(:, i+1:n);
    Kt = K(:, i+1:n);
    net = train(net, Xu, Ku);
    Y = net(Xt);
    if(i == DniTrenujace)
       wydajnoscUczace = perform(net, Xu, Ku); 
    end
    if(((K(1,i) >= K(1,i-1)) && (Y(1,1) >= K(1,i-1)))  || ((K(1,i) < K(1,i-1)) && (Y(1,1) < K(1,i-1))))
       WzrostSpadek(1, i-DniTrenujace + 1) = 1; 
    end
    for j = 1 : n-i
        Prognoza(j, i-DniTrenujace+1) = ((Y(1,j))' + 0.5)*max;
    end
end

%dekodowanie danych z przedzia?u [-0.5, 0.5]
for i = 1 : n+nDni
    Danelab5(i,4) = (Danelab5(i,4)+ 0.5)*max ;
end
for i = 1 : n-DniTrenujace
    
end
WydajnoscWzrostSpadek = 0;
for i = 1 : n-DniTrenujace
    if(WzrostSpadek(1,i) == 1)
        WydajnoscWzrostSpadek = WydajnoscWzrostSpadek + 1;
    end
end

%wydajnosc przewidywania wzrostow i spadkow w procentach
WydajnoscWzrostSpadek = WydajnoscWzrostSpadek/(n-DniTrenujace)*100;

%porownanie danych z wynikami
hold on;
plot((Danelab5((DniTrenujace+nDni):n+nDni,4))', 'g');
plot(Prognoza(:,1), 'r')
%plot(Prognoza(1,:)');
legend('Prawdziwe dane', 'Przewidywanie');
title('Przewidywania');
legend('Prawdziwe dane', 'Przewidywanie 1-dniowe', 'Przewidywanie na wszystkie dni');
hold off;

%obliczanie MSE
MSE_1dzien = 0;
MSE_wszystkieDni = 0;
sredniaPomylkaKwoty = 0;
error = zeros(1,n-DniTrenujace);
errorProcent = zeros(1,n-DniTrenujace);

MSE_1dzien_max = 0;
MSE_1dzien_min = 99999999;

for i = DniTrenujace+nDni : n+nDni-1
    MSE_1dzien = MSE_1dzien + (Danelab5(i,4) - Prognoza(1, i+1-DniTrenujace-nDni))^2;
    if(((Danelab5(i,4) - Prognoza(1, i+1-DniTrenujace-nDni))^2) > MSE_1dzien_max)
        MSE_1dzien_max = (Danelab5(i,4) - Prognoza(1, i+1-DniTrenujace-nDni))^2;
    end
    if(((Danelab5(i,4) - Prognoza(1, i+1-DniTrenujace-nDni))^2) < MSE_1dzien_min)
        MSE_1dzien_min = (Danelab5(i,4) - Prognoza(1, i+1-DniTrenujace-nDni))^2;
    end
    
    error(1,i+1-DniTrenujace-nDni) = Prognoza(1, i+1-DniTrenujace-nDni) - Danelab5(i,4);
    errorProcent(1,i+1-DniTrenujace-nDni) = (Prognoza(1, i+1-DniTrenujace-nDni) - Danelab5(i,4)) / Danelab5(i,4);
    MSE_wszystkieDni = MSE_wszystkieDni + (Danelab5(i,4) - Prognoza(i+1-DniTrenujace-nDni, 1))^2;
    sredniaPomylkaKwoty = sredniaPomylkaKwoty + abs(Danelab5(i,4) - Prognoza(1, i+1-DniTrenujace-nDni))/Danelab5(i,4);
end
MSE_1dzien = MSE_1dzien / (n-DniTrenujace);
MSE_wszystkieDni = MSE_wszystkieDni / (n-DniTrenujace);
sredniaPomylkaKwoty = sredniaPomylkaKwoty / (n-DniTrenujace);

display(['Blad sredniokwadratowy danych uczacych ' num2str(wydajnoscUczace)]);
display(['Blad sredniokwadratowy dane testujace ' num2str(MSE_1dzien)]);
%display(['Blad sredniokwadratowych przewidywanie ' num2str(size(Prognoza(1,:))) ' dni ' num2str(MSE_wszystkieDni)]);
display(['Srednie odchylenie przewidywan ' num2str(sredniaPomylkaKwoty) '%']);
display(['Dobrze przewidziane wzrostu i spadki cen akcji ' num2str(WydajnoscWzrostSpadek) '%']);

f2 = figure;
plot(error);
title('Odchylenie przewidywania o kwote');

f3 = figure;
plot(errorProcent);
title('Procentowe odchylenie przewidywania');

