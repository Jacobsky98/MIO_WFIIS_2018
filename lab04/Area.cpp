#include <iostream>
#include <cmath>
#include "Area.hpp"


double randomDouble(double limitdown, double limitup){
    return limitdown + ( (double)rand()/(double)RAND_MAX ) * (limitup - limitdown);
}

double signum(double val){
    if(val > 0.0)
        return 1; 
    else
        return -1;
}

double srednia(double* tablica, int size){
    double suma = 0.;
    for(int i = 0; i < size; i++)
        suma += tablica[i];
    return suma/size;
}

double variation(double* tablica, int size){
    double suma = 0.;
    double srednia_ = srednia(tablica, size);
    for(int i = 0; i < size; i++)
        suma += (tablica[i] - srednia_) * (tablica[i] - srednia_);
    return suma/(size+1);
}

Area::Area(){
    up_ = 1.;
    down_ = -1.; 
    left_ = -1.;
    right_ = 1.;
}
        
Area::Area(double down, double up, double left, double right){
    up_ = up;
    down_ = down;
    left_ = left;
    right_ = right;
}

void Area::wypisz(){
    std::cout << "left    " << left_ << std::endl;
    std::cout << "right    " << right_ << std::endl;
    std::cout << "down    " << down_ << std::endl;
    std::cout << "up    " << up_ << std::endl;
}
Area::~Area(){
   // delete this;
}

