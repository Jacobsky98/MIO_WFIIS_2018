#include <iostream>
#include <math.h>
#include <time.h>


#include "Swarm.hpp"

const double PI = 3.14159265359;

using std::cout;
using std::endl;

const int populacja = 20;
const int iteracje = 2000;
const double c1 = 2.2;
const double c2 = 2.2;
const double vmax = 0.01;

double przystosowanie(V2d& punkt){
    return punkt.getX() * punkt.getX() + punkt.getY() * punkt.getY() - 20*(cos(PI*punkt.getX()) + cos(PI*punkt.getY()) - 2.);
}

int main(){
    srand(time(nullptr));
    Area przedzial(-10., 10., -10., 10.); // os Y dol gora, os X lewo prawo
    Swarm s1 = Swarm(populacja, przedzial, c1, c2, vmax, przystosowanie); //generowanie roju

   // przedzial.wypisz();
    double BestTable[iteracje];
    double* TableOfValidators = new double[s1.getSize()];
    double* BestValidators = new double[s1.getSize()];
    double* odchylenieStandardowe = new double[iteracje];
    double* sredniePrzystosowanie = new double[iteracje];


    for(int j = 0; j<iteracje; j++){
        double sumaNajlepszychPrzystosowan = 0.0;
        //for(int i = 0; i<10; i++){
            s1.oneStep();
            
            cout << s1.getBest() << " at " << s1.getBestPlace().getX() << " " << s1.getBestPlace().getY() << endl;
            
            for(int k = 0; k<s1.getSize(); k++){
                TableOfValidators[k] = s1[k]->getLastVal();
                BestValidators[k] = s1[k]->getBestVal();
                sumaNajlepszychPrzystosowan += BestValidators[k];
            }

            
            //cout << i << "," << s1.getBest() << "," << srednia(TableOfValidators,s1.getSize()) << "," << sqrt(variation(TableOfValidators,s1.getSize())) << "," << srednia(BestValidators,s1.getSize()) << "," << sqrt(variation(BestValidators,s1.getSize()))  << endl;
            
      //  }
        
        for(int k = 0; k<s1.getSize(); k++){
      //      cout << s1[k]->getBestVal() << " " << s1[k]->getLastVal() << " " << s1[k]->getPos().getX() << " " << s1[k]->getPos().getY() << endl;
        }
        
        BestTable[j] = s1.getBest();
        double sumaOdchylenie = 0.0;
        for(int k = 0; k < s1.getSize(); k++){
            sumaOdchylenie += (BestValidators[k] - BestTable[j])*(BestValidators[k] - BestTable[j]);
        }
        odchylenieStandardowe[j] = sqrt(sumaOdchylenie/s1.getSize());
        sredniePrzystosowanie[j] = sumaNajlepszychPrzystosowan / (s1.getSize() * 10);
    }

double fi = c1 + c2;
if(fi > 4){
    cout << endl << 2.0 / (abs)(2.0 - fi - sqrt(fi*fi - 4*fi)) << endl; // wersja Clerca
}


// wypisywanie najlepszych wartosci funkcji przystosowania w danej iteracji
    FILE *f1 = fopen("bestTable.csv", "w");
    if(f1 == NULL){
        cout << "error opening file" << endl; 
        exit(1); 
    }
    for (int i = 0; i < iteracje; i++){
        fprintf(f1, "%lf\n", BestTable[i]); 
    }
    fclose(f1);

// wypisywanie najlepszych wartosci funkcji przystosowania w danej iteracji >400
    FILE *f4 = fopen("bestTable2.csv", "w");
    if(f4 == NULL){
        cout << "error opening file" << endl; 
        exit(1); 
    }
    for (int i = 0; i < 400; i++){
        fprintf(f4, "%lf\n", 0.0); 
    }
    for (int i = 400; i < iteracje; i++){
        fprintf(f4, "%lf\n", BestTable[i]); 
    }
    fclose(f4);

    

// wypisuje srednie przystosowania
    FILE *f2 = fopen("sredniePrzystosowanie.csv", "w");
    if(f2 == NULL){
        cout << "error opening file" << endl; 
        exit(1); 
    }
    for (int i = 0; i < iteracje; i++){
        fprintf(f2, "%lf\n", sredniePrzystosowanie[i]); 
    }
    fclose(f2);

    // wypisuje srednie przystosowania dla indeksow >=400
    FILE *f5 = fopen("sredniePrzystosowanie2.csv", "w");
    if(f5 == NULL){
        cout << "error opening file" << endl; 
        exit(1); 
    }
    for (int i = 0; i < 400; i++){
        fprintf(f5, "%lf\n", 0.0); 
    }
    for (int i = 400; i < iteracje; i++){
        fprintf(f5, "%lf\n", sredniePrzystosowanie[i]); 
    }
    fclose(f5);

// wypisuje odchylenie standardowe najlepszych przystosowan
    FILE *f3 = fopen("odchylenieStandardowe.csv", "w");
    if(f3 == NULL){
        cout << "error opening file" << endl; 
        exit(1); 
    }
    for (int i = 0; i < iteracje; i++){
        fprintf(f3, "%lf\n", odchylenieStandardowe[i]); 
    }
    fclose(f3);

// wypisuje odchylenie standardowe dla indeksow >=400
    FILE *f6 = fopen("odchylenieStandardowe2.csv", "w");
    if(f6 == NULL){
        cout << "error opening file" << endl; 
        exit(1); 
    }
    for (int i = 0; i < 400; i++){
        fprintf(f6, "%lf\n", 0.0); 
    }
    for (int i = 400; i < iteracje; i++){
        fprintf(f6, "%lf\n", odchylenieStandardowe[i]); 
    }
    fclose(f6);


    delete [] TableOfValidators;
    delete [] BestValidators;
    delete [] odchylenieStandardowe;
    delete [] sredniePrzystosowanie;

    return 0;
}