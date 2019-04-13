#include <iostream>
#include <cstdlib>
#include <ctime>

//#define _USE_MATH_DEFINES // dla visual studio do <cmath>
#include <math.h>
#include <conio.h>



bool** losowanie_populacji(int pop, char typ, int N){
    bool **populacja = new bool *[pop];
    for(int i = 0; i < pop; i++){
        populacja[i] = new bool [N];
    }
    for(int i = 0; i < pop; i++){
        for(int j = 0; j < N; j++){
            populacja[i][j] = rand()%2;
            if(typ == 'g')
                populacja[i][j] = populacja[i][j] ^ (populacja[i][j] / 2); // kod greya
        }
    }
    return populacja;
}

void wartosc_dziesietna(double *wartosc, bool **populacja, int pop, int N){
    for(int i = 0; i < pop; i++){
        wartosc[i] = 0;
        for(int j = 0; j < N; j++){
            wartosc[i] += (double)populacja[i][N-1-j] * pow((double)2, (double)j); 
        }
        wartosc[i] = (wartosc[i] / ((pow((double)2, (double)N) - 1) / 3.0)) - 1;
    }
}
 
void wypisz_populacje(bool **populacja, double *wartosc, double* przystosowanie, int pop, int N){
    std::cout << std::endl;
    std::cout << "Nr\t";
//    std::cout.width(25);
//    std::cout.fill(' ');
    std::cout << "Chromosom";
 //   std::cout.width(15);
//    std::cout.fill(' ');
    std::cout << "Fenotyp";
    std::cout << "Wartosc przystosowania" << std::endl;
    for(int i = 0; i < pop; i++){
        std::cout << i << '\t';
//        std::cout.width(25);
//        std::cout.fill(' ');
        for(int j = 0; j < N; j++){
            std::cout << populacja[i][j];
        }
        std::cout << "   ";
  //      std::cout.width(15);
    //    std::cout.fill(' ');
        std::cout << "\t" << wartosc[i];

        std::cout << '\t' << przystosowanie[i] << std::endl;
    }
}

void ocena_przystosowania(double *f_przystosowania, double *x, int pop){
    for(int i = 0; i < pop; i++){
        f_przystosowania[i] = x[i] * sin(10 * M_PI * x[i]) + 1;
    }
}

int selekcja_ruletka(bool** populacja, double* przystosowanie, int pop, int N){
    
    
    double suma = 0.0;
    for(int i = 0; i < pop; i ++){
        suma += abs(przystosowanie[i]);
    }
    double* p_selection = new double [pop];
    double* acc_p_selection = new double [pop];
    for (int i = 0; i < pop; i++){
        p_selection[i] = abs(przystosowanie[i]) / suma;
    }

    acc_p_selection[0] = p_selection[0];
    for(int i = 1; i < pop; i++){
        acc_p_selection[i] = p_selection[i] + acc_p_selection[i-1];
    }
        
        
    for(int i = 0; i < pop; i++){
        double punkt = (double)rand()/RAND_MAX;
        int r = 0;
        while(((r < pop) && (punkt > acc_p_selection[r] ))){
       // while((r < pop) && (punkt > (p_selection[r]/suma))){
            r++;
            
        }
        if(r < pop)
            return r;
        else
            return -1;
        if(r<pop){
            for(int j = 0; j < N; j++){
                populacja[i][j] = populacja[r][j];
            }
        }

    }

    delete [] p_selection;
    delete [] acc_p_selection;
}

void krzyzowanie(bool** populacja, double* przystosowanie, int pop, int N, double pcross){
/*
    int locus = rand()%(N);
    int liczba_krzyzowan = (ceil(pcross*pop) /2);
    if(liczba_krzyzowan%2)
        liczba_krzyzowan++;
    for(int k = 0; k < liczba_krzyzowan; k++){
        int osobnik1 = rand()%pop;
        int osobnik2 = rand()%pop;
        if(osobnik1 != osobnik2){
            for(int i = locus; i < N; i++){
                bool temp = populacja[osobnik1][i];
                populacja[osobnik1][i] = populacja[osobnik2][i];
                populacja[osobnik2][i] = temp;
            }
        }
        locus = rand()%(N);
*/

    int locus = rand()%(N); 
    int liczba_krzyzowan = (ceil(pcross*pop)  );
    if(liczba_krzyzowan%2)
        liczba_krzyzowan++;
    for(int k = 0; k < liczba_krzyzowan; k++){
        int osobnik1 = selekcja_ruletka(populacja, przystosowanie, pop, N);
        int osobnik2 = selekcja_ruletka(populacja, przystosowanie, pop, N);
        std::cout << osobnik1 << "   " << osobnik2 << std::endl;
        if((osobnik1 >= 0) && (osobnik2 >= 0)){
            for(int i = locus; i < N; i++){
                bool temp = populacja[osobnik1][i];
                populacja[osobnik1][i] = populacja[osobnik2][i];
                populacja[osobnik2][i] = temp;
            }
        }
        locus = rand()%(N);
    }
    

}

void mutacja(bool** populacja, double pmut, int pop, int N){
    int j = 0;
    int i = 0;
    int ilosc_genowDoMutacji = ceil(pmut*pop*N);
    while(j < ilosc_genowDoMutacji){
        int k = rand()%N;
        if(pmut > ((double)rand()/RAND_MAX)){
            populacja[i][k] = !populacja[i][k];
            j++;
        }
        if(i < (pop-1))
            i++;
        else
            i = 0;
       
      }
}

void zwolnij_pamiec1(void *x, char typ){
    if(typ == 'i')
        delete [] (int*)x;

    else if(typ == 'd')
        delete [] (double*)x;
    
}

void zwolnij_pamiec2(bool **populacja, int pop){
    for(int i = 0; i < pop; i++){
        delete [] populacja[i];
    }
    delete [] populacja;
}

