#ifndef V2d_h
#define V2d_h

#include "Area.hpp"

class V2d{
    public:
        V2d();
        V2d(double x, double y);
        V2d operator+(V2d& punkt);
        double getX() const { return x_; }
        double getY() const { return y_; }
        void bounceVertical() { x_ = -x_; }
        void bounceHorizontal() { y_ = -y_; }
    private:
        double x_;
        double y_;
};

#endif