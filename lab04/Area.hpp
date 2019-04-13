#ifndef Area_h
#define Area_h


double randomDouble(double limitdown, double limitup);

double signum(double val);

double srednia(double* tablica, int size); // zwraca srednia arytmetyczna tablicy

double variation(double* tablica, int size); // zwraca srednie ochylenie standardowe do kwadratu



class Area{
    public:
        Area();
        Area(double down, double up, double left, double right);
        void wypisz();
        ~Area();
        double up_, down_, left_, right_;
        
};


#endif