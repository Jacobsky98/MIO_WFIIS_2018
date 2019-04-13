#ifndef pso_hpp
#define pso_hpp

#include "Czastka.hpp"



class Swarm{
    public:
        Swarm();
        Swarm(int size, Area granice, double c1, double c2, double vmax, double (*przystosowanie)(V2d&));
        void oneStep();
        double getBest() const { return bestValue_; }   // zwraca najlepsza wartosc funkcji jaka kiedykolwiek powstala
        V2d getBestPlace() const { return bestPlace_; } // zwraca miejsce gdzie najlepsza wartosc funkcji jaka kiedykolwiek powstala
        int getSize() const { return size_; }   // zwraca rozmiar roju
        const Czastka* operator[](int n);   // zwraca staly wskaznik do czastki w roju
        ~Swarm();
    private:
        double (*przystosowanie_)(V2d&);
        int size_;
        double c1_;
        double c2_;
        double vmax_;
        Czastka* swarmTable_;
        V2d bestPlace_;
        double bestValue_;
        
        
};

#endif