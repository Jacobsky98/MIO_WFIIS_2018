%   sprawozdanie na 30.11
%   mail tytul      SSN_lab1_Nazwisko       w mailu ma być archiwum zip ze
%   sprawozdaniem i kodem

clear; clc;
%dane uczace neuron
xu = randn(50, 2);
xu(51:100,:) = randn(50,2);
xu(51:100, 1) = xu(51:100,1) + 2;
ku = zeros(50, 1);
ku(51:100,1) = 1;

%jedna klasa to dane rozwiazanie np. klasa jeden to rozwiazanie 1

%dane testowe
%macierz xt nalezaca do pierwszej klasy
xt = randn(1000,2);

%generowanie drugiej klasy i dodawanie jej do tej wczesniejszej macierz
xt(1001:2000, :) = randn(1000,2);
xt(1001:2000, 1) = xt(1001:2000, 1) + 2;

%macierz 
kt = zeros(1000, 1);
kt(1001:2000,1) = 1;

%transponowanie macierzy bo siec przyjmuje jedna zmienna to jeden wiersz a
%my mielismy jedna zmienna jedna kolumna
xu = xu';
ku = ku';
xt = xt';
kt = kt';



net = perceptron;
net = train(net, xu, ku);

train(net, xt, kt)
view(net)

%sprawdzanie jak sie nauczylo 

%y od 1 do 1000 ma wychodzic 0 a od 1001 do 2000 same 1
y = net(xt)