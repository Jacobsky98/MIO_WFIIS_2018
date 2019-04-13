#include "V2d.hpp"

V2d::V2d(){
    x_ = 0.;
    y_ = 0.;
}

V2d::V2d(double x, double y){
    x_ = x;
    y_ = y;
}

V2d V2d::operator+(V2d& punkt){
    return V2d(this->x_+punkt.getX(), this->y_+punkt.getY());
}