#ifndef Czastka_h
#define Czastka_h

#include "V2d.hpp"

class Czastka{
    public:
        Czastka();
        Czastka(Area granice, double vmax); // stwarza czastke w granica i ustala maksylana predkosc, losuje predkosc i polozenie poczatkowe
        void move(); // przemieszcza czastke zgodnie z jej predkoscia i sprawdza czy miesci sie w granicach 
        double f_Przystosowania(double (*przystosowanie)(V2d& punkt)); // oblicza wartosc funkcji przystosowania
        void adjustSpeed(V2d bestPos, double weight1, double weight2, double omega); // dostosowuje predkosc dla znanej wagi1, wagi2, omega oraz najlepszej lokalizacji
        V2d getPos() const { return position_; } // zwraca pozycje czastki
        double getBestVal() const { return bestVal_; } // zwraca ostatnia wartosc funkcji dla czastki
        double getLastVal() const { return lastVal_; } // zwraca najlepsza wartosc funkcji dla tej czastki
    private:
        V2d position_;
        V2d speed_;
        V2d bestPlace_;
        double bestVal_;
        double vmax_;
        Area granice_;
        double lastVal_;
};

#endif