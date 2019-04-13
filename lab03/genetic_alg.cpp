/*
*Proszę, korzystając z algorytmu genetycznego 
*znaleźć maksimum funkcji
*   𝑓(𝑥) = 𝑥 sin(10𝜋 ∗ 𝑥) + 1
*    w przedziale 𝑥 ∈ [−1,2],
*    przy założeniu że rozwiązanie 
*   jest reprezentowane przez 22 bity.
*/


// rozdzielczosc populacji na przedziale [-1, 2]

#include <iostream>
// #define _USE_MATH_DEFINES // dla visual studio do <cmath>
#include <cmath>
#include <cstdlib>
#include <ctime>
   
#include "funkcje.h"

using namespace std;

int main(){
    srand(time(NULL));
    bool **populacja = losowanie_populacji(); //losowanie_populacji(populacja);
    double *x = new double [pop];
    wartosc_dziesietna(x, populacja); // znajdowanie wartosci dziesietnej danej populacji
    double *przystosowanie = new double [pop];
    ocena_przystosowania(przystosowanie, x);

    double* hist_srednie_przystosowanie = new double [imax];
    double* hist_najlepsze_przystosowanie = new double [imax];

    int iteracja = 0; 
    wypisz_populacje(populacja, x, przystosowanie);

    while(iteracja < imax){
        //selekcja_ruletka(populacja, przystosowanie);
        krzyzowanie(populacja, przystosowanie);
        mutacja(populacja);
        wartosc_dziesietna(x, populacja); // znajdowanie wartosci dziesietnej danej populacji
        ocena_przystosowania(przystosowanie, x);
        
        
        int i_najlepsze = 0;
        double suma = 0.;
        for(int i = 0; i < pop; i++){
            if(przystosowanie[i] > przystosowanie[i_najlepsze])
                i_najlepsze = i;
            suma += abs(przystosowanie[i]);
        }
        hist_srednie_przystosowanie[iteracja] = suma / pop;
        hist_najlepsze_przystosowanie[iteracja] = przystosowanie[i_najlepsze];
        iteracja++;
    }
    wypisz_populacje(populacja, x, przystosowanie);
    int x_maxx = 0, f_max = 0;
    for(int i = 0; i < imax; i++){
        if(hist_najlepsze_przystosowanie[f_max] < hist_najlepsze_przystosowanie[i])
            f_max = i;
    }

    std::cout << "Najlepsza wartosc = " << hist_najlepsze_przystosowanie[f_max] << std::endl;
    
    FILE *f1 = fopen("fit_best.csv", "w");
    if(f1 == NULL){
        cout << "error opening file" << endl; 
        exit(1); 
    }
    for (int i = 0; i < imax; i++){
        fprintf(f1, "%lf\n", hist_najlepsze_przystosowanie[i]);
    }
    fclose(f1);
    //************************************************
    FILE *f2 = fopen("avg_fit.csv", "w");
    if(f2 == NULL){
        cout << "error opening file" << endl; 
        exit(1); 
    }
    for (int i = 0; i < imax; i++){
        fprintf(f2, "%lf\n", hist_srednie_przystosowanie[i]);
    }
    fclose(f2);
    
    
    //zwolnij_pamiec1(x, 'd');  // zwalnianie pamieci dla double
    //zwolnij_pamiec1(iteracja, 'i'); // zwalnianie pamieci dla int
    //zwolnij_pamiec1(przystosowanie, 'd'); // zwalnianie pamieci dla double
    delete [] x;
    delete [] przystosowanie;
    delete [] hist_srednie_przystosowanie;
    delete [] hist_najlepsze_przystosowanie;
    //delete iteracja;
    zwolnij_pamiec2(populacja); // zwalnianie pamieci dla bool**

   
   
    return 0;
}