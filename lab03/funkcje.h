#ifndef funkcje_h
#define funkcje_h

#define N 22 // długosc chromosomu 
#define pop 20 // rozmiar populacji
#define pcross 1 // prawdopodobieństwo krzyżowania
#define pmut 0.01 // prawdopodobieństwo mutacji
#define imax 100 // maksymalna ilosc iteracji // zwykle warunkiem stopu jest osiągnięcie maksymalnej liczby iteracji



bool** losowanie_populacji(int pop_ = pop, char typ = 'b', int N_ = N);

/*
* Liczy wartosc dziesietna dla ciagu binarnego
*/
void wartosc_dziesietna(double*, bool **, int pop_ = pop, int N_ = N);

/*
* Wypisuje ciag binarny populacji i jej wartosc dziesietna
*/
void wypisz_populacje(bool **, double *, double*, int pop_ = pop, int N_ = N);

/*
* Liczy przystosowanie na podstawie funkcji populacji
*/
void ocena_przystosowania(double *, double*, int pop_ = pop);

/*
* Zwalnia pamiec dla poszczególnych typów zmienych (tablica)
*   'i' -> typ int*
*   'd' -> typ double*
*/

/*
* Metoda selekcji ruletka
*/
int selekcja_ruletka(bool**, double*, int pop_ = pop, int N_ = N);

/*
* Krzyzowanie jednopunktowe
*/
void krzyzowanie(bool **, double*,  int pop_ = pop, int N_ = N, double pcross_ = pcross);

/*
* Mutujemy 𝑝𝑚𝑢𝑡 ∗ 𝑝𝑜𝑝 ∗ 𝑁 genów – wyznaczonych losowo. Mutacja polega na zamianie wartości pojedynczego bitu.
*/
void mutacja(bool**, double pmut_ = pmut, int pop_ = pop, int N_ = N);

/*
* Zwalnia pamiec dla typow double* i int* (podane jako char) 
*/
void zwolnij_pamiec1(void*, char);

/*
* Zwalnia pamiec dla bool**
*/
void zwolnij_pamiec2(bool **, int pop_ = pop);

#endif