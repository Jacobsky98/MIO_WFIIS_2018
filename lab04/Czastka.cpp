#include "Czastka.hpp"
#include <iostream>
#include <cmath>

Czastka::Czastka(){
    position_ = V2d();
    speed_ = V2d();
}

Czastka::Czastka(Area granice, double vmax){
    vmax_ = vmax;
    granice_ = granice;
    bestVal_ = 10000.;
    position_ = V2d(randomDouble(granice.left_, granice.right_), randomDouble(granice.down_, granice.up_));
    speed_ = V2d(randomDouble(-1*vmax, vmax), randomDouble(-1*vmax, vmax));
}

void Czastka::move(){
    position_ = position_ + speed_;

    if(position_.getX() < granice_.left_)
        speed_.bounceVertical();

    if(position_.getX() > granice_.right_)
        speed_.bounceVertical();

    if(position_.getY() < granice_.down_)
        speed_.bounceHorizontal();

    if(position_.getY() > granice_.up_)
        speed_.bounceHorizontal();
}

double Czastka::f_Przystosowania(double (*przystosowanie)(V2d& punkt)){
    double tmp = przystosowanie(position_);
    if(tmp < bestVal_){
        bestVal_ = tmp;
        bestPlace_ = position_;
    }
    lastVal_ = tmp;
    return tmp;
}

void Czastka::adjustSpeed(V2d bestPos, double c1, double c2, double omega){
    double newx = omega*(speed_.getX() + randomDouble(0, c1)*(bestPlace_.getX()-position_.getX())+randomDouble(0, c2)*(bestPos.getX() - position_.getX()));
    double newy = omega*(speed_.getY() + randomDouble(0, c1)*(bestPlace_.getY()-position_.getY())+randomDouble(0, c2)*(bestPos.getY() - position_.getY()));
    speed_ = V2d(abs(newx)>abs(vmax_)?vmax_*signum(newx):newx,abs(newy)>abs(vmax_)?vmax_*signum(newy):newy);
}