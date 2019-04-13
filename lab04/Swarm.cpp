#include <iostream>
#include <time.h>
#include <stdlib.h>
#include <math.h>

#include "Swarm.hpp"

using std::cout;
using std::endl;



Swarm::Swarm(int size, Area granice, double c1, double c2, double vmax, double (*przystosowanie)(V2d&)){
    przystosowanie_ = przystosowanie;
    c1_ = c1;
    c2_ = c2;
    vmax_ = vmax;
    size_ = size;
    swarmTable_ = new Czastka[size_];
    for(int i = 0; i < size_; i++){
        swarmTable_[i] = Czastka(granice, vmax);
    }
    bestValue_ = 10000.;
}

void Swarm::oneStep(){
    for(int i = 0; i<size_; i++){
        swarmTable_[i].move();
        double tmp = swarmTable_[i].f_Przystosowania(przystosowanie_);
        if(tmp<bestValue_){
            bestValue_ = tmp;
            bestPlace_ = V2d(swarmTable_[i].getPos().getX(),swarmTable_[i].getPos().getY());
        }
    }
    for(int i = 0; i<size_; i++){
        
        double omega = 1.0; // podstawowa wersja algorytmu

        double fi = c1_ + c2_; // wersja Clerca
        if(fi > 4){
            omega = 2.0 / (abs)(2.0 - fi - sqrt(fi*fi - 4*fi)); // wersja Clerca
        }
        swarmTable_[i].adjustSpeed(bestPlace_,c1_,c2_, omega);
    }
}


const Czastka* Swarm::operator[](int n){
    return (const Czastka*)(swarmTable_ + n);
}

Swarm::~Swarm(){
    delete [] swarmTable_;
}